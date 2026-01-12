---
description: Run repository quality audit
agent: repo-maintainer
---

Run the audit script and report any violations.

`!python3 .opencode/skill/repo-maintenance/scripts/audit_repo.py`

<post_audit>

If the audit fails (errors or warnings found):

1. Read each file listed in the output
2. Analyze what changes would fix the issues
3. Use the question tool to ask the user which files/issues to address
4. MUST NOT auto-fix all issues without explicit user approval

Mass auto-fixes can break working configurations. Let the user decide.

</post_audit>
