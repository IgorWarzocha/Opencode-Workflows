---
name: security-django
description: Django security audit patterns. Load when reviewing Django apps (settings.py or manage.py present). Covers SECRET_KEY, ALLOWED_HOSTS, DEBUG, CSRF, SecurityMiddleware, and Django-specific issues.
---

<overview>

Security audit patterns for Django applications covering critical settings, security middleware, CSRF protection, and common vulnerabilities.

</overview>

<rules>

## Critical Settings (settings.py)

### SECRET_KEY
```python
# ❌ CRITICAL: Hardcoded or committed
SECRET_KEY = 'django-insecure-abc123...'
SECRET_KEY = 'my-super-secret-key'

# ✓ From environment
import os
SECRET_KEY = os.environ['DJANGO_SECRET_KEY']

# ✓ Or use django-environ
import environ
env = environ.Env()
SECRET_KEY = env('SECRET_KEY')
```

**Check:** Is SECRET_KEY in .env and .env is in .gitignore?

### DEBUG
```python
# ❌ CRITICAL: Debug in production
DEBUG = True  # Exposes full stack traces, settings, SQL queries

# ✓ Environment-controlled
DEBUG = os.environ.get('DEBUG', 'False').lower() == 'true'
```

### ALLOWED_HOSTS
```python
# ❌ CRITICAL: Accept any host
ALLOWED_HOSTS = ['*']

# ❌ HIGH: Empty in production (500 errors, but still bad)
ALLOWED_HOSTS = []

# ✓ Explicit hosts
ALLOWED_HOSTS = ['example.com', 'www.example.com']
```

## Security Middleware

### Required Middleware
```python
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',  # MUST be first!
    # ...
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]
```

**Check:** Is SecurityMiddleware present and near the top?

### Security Middleware Settings
```python
# ✓ Enable these in production
SECURE_BROWSER_XSS_FILTER = True  # Deprecated but harmless
SECURE_CONTENT_TYPE_NOSNIFF = True
SECURE_HSTS_SECONDS = 31536000  # 1 year
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True
SECURE_SSL_REDIRECT = True  # Force HTTPS
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
```

</rules>

<vulnerabilities>

## CSRF Protection

### Disabled CSRF (Critical)
```python
# ❌ CRITICAL: Globally disabled
MIDDLEWARE = [
    # 'django.middleware.csrf.CsrfViewMiddleware',  # Commented out!
]

# ❌ HIGH: Decorator abuse
@csrf_exempt
def payment_webhook(request):  # MAY be OK for webhooks with other auth
    ...

@csrf_exempt
def update_profile(request):  # MUST NOT do this!
    ...
```

**Audit:** Search for `@csrf_exempt` - each needs justification.

### CSRF Trusted Origins (Django 4.0+)
```python
# ❌ Too permissive
CSRF_TRUSTED_ORIGINS = ['https://*']

# ✓ Explicit
CSRF_TRUSTED_ORIGINS = ['https://example.com', 'https://admin.example.com']
```

## Common Vulnerabilities

### SQL Injection
```python
# ❌ Raw SQL with string formatting
User.objects.raw(f"SELECT * FROM users WHERE id = {user_id}")
cursor.execute(f"DELETE FROM logs WHERE date < '{date}'")

# ✓ Parameterized
User.objects.raw("SELECT * FROM users WHERE id = %s", [user_id])
cursor.execute("DELETE FROM logs WHERE date < %s", [date])

# ✓ ORM (safe by default)
User.objects.filter(id=user_id)
```

### Command Injection
```python
# ❌ User input in subprocess
import subprocess
subprocess.run(f"convert {user_filename} output.png", shell=True)
os.system(f"process {user_input}")

# ✓ Use arrays, avoid shell=True
subprocess.run(["convert", user_filename, "output.png"])
```

### Path Traversal
```python
# ❌ User-controlled path
def download(request, filename):
    return FileResponse(open(f'uploads/{filename}', 'rb'))

# ✓ Validate path
import os
def download(request, filename):
    safe_name = os.path.basename(filename)
    filepath = os.path.join(settings.UPLOAD_DIR, safe_name)
    if not filepath.startswith(settings.UPLOAD_DIR):
        raise Http404()
    return FileResponse(open(filepath, 'rb'))
```

### IDOR (Insecure Direct Object Reference)
```python
# ❌ No ownership check
class DocumentView(View):
    def get(self, request, doc_id):
        doc = Document.objects.get(id=doc_id)
        return JsonResponse(doc.to_dict())

# ✓ Check ownership
class DocumentView(LoginRequiredMixin, View):
    def get(self, request, doc_id):
        doc = Document.objects.get(id=doc_id, owner=request.user)
        return JsonResponse(doc.to_dict())
```

### Auth Decorators Missing
```python
# ❌ No auth required
def admin_dashboard(request):
    return render(request, 'admin/dashboard.html', {'users': User.objects.all()})

# ✓ Auth required
@login_required
@user_passes_test(lambda u: u.is_staff)
def admin_dashboard(request):
    ...
```

## Django REST Framework

```python
# Check DRF settings
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': [
        # ❌ SessionAuth without CSRF = vulnerable
        'rest_framework.authentication.SessionAuthentication',
    ],
    'DEFAULT_PERMISSION_CLASSES': [
        # ❌ Allow any by default
        'rest_framework.permissions.AllowAny',
        # ✓ Require auth by default
        'rest_framework.permissions.IsAuthenticated',
    ],
}
```

</vulnerabilities>

<commands>

## Quick Audit Commands

```bash
# Check critical settings
rg "(SECRET_KEY|DEBUG|ALLOWED_HOSTS)" settings*.py

# Find csrf_exempt usage
rg "@csrf_exempt" . -g "*.py"

# Django deployment checklist (high signal)
python manage.py check --deploy

# Find raw SQL
rg "\.raw\(|cursor\.execute\(" . -g "*.py" -A 1

# Find subprocess/os.system
rg "(subprocess\.|os\.system|os\.popen)" . -g "*.py"

# Check for missing login_required
rg "^def " views.py | head -20  # Then check which have decorators

# Find shell=True
rg "shell\s*=\s*True" . -g "*.py"
```

</commands>

<checklist>

## Hardening Checklist

- [ ] SECRET_KEY from environment, not hardcoded
- [ ] DEBUG = False in production
- [ ] ALLOWED_HOSTS explicitly set (no wildcards)
- [ ] SecurityMiddleware enabled and configured
- [ ] CSRF middleware enabled
- [ ] SECURE_SSL_REDIRECT = True
- [ ] SESSION_COOKIE_SECURE = True
- [ ] CSRF_COOKIE_SECURE = True
- [ ] No @csrf_exempt without justification
- [ ] All views have appropriate auth decorators
- [ ] No raw SQL with string formatting
- [ ] DRF has IsAuthenticated as default permission

</checklist>
