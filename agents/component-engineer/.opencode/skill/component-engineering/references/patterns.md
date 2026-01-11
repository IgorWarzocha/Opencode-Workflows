# Component Patterns Reference

<rules>

### Accessibility Checklist
- [ ] You MUST NOT use `onClick` on `<div>` without `role` and `tabIndex`.
- [ ] SVGs MUST have `aria-hidden="true"` or a `<title>`.
- [ ] Focus indicators MUST be visible.
- [ ] Form inputs MUST have associated `<label>` or `aria-label`.

</rules>

<context>

### Composition Patterns
- **Root**: Container with context provider.
- **Trigger**: Activator using `asChild`.
- **Content**: The main displayed part.

### Naming Conventions
- You SHOULD use standard suffixes: `Trigger`, `Content`, `Header`, `Footer`, `Title`, `Description`.
- You MUST use kebab-case for `data-slot`.

</context>
