---
name: component-review
description: Performs an audit of a React component.
---
<overview>
Perform a rigorous, spec-aligned engineering review of a React component.
</overview>

<context>
- `file`: Path to the React component file.
</context>

<workflow>

1. **Load Skill**: You MUST use the `skill` tool to load `component-engineering`.
2. **Read References**: You MUST read `taxonomy.md`, `accessibility.md`, `composition.md`, and `styling.md` from the skill's references directory.
3. **Audit**:
   - **Classify**: Identify the artifact type using the taxonomy.
   - **Accessibility**: Verify semantic HTML and keyboard maps.
   - **Composition**: Check for `asChild` support and monolithic patterns.
   - **Styling**: Inspect `data-slot` and `data-state` usage.
4. **Report**:
   - **Classification**: Identified artifact type.
   - **Findings**: Report professional patterns found, a11y violations, and refactoring opportunities.

</workflow>
