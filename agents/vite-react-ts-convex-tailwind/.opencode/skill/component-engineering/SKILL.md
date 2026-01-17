---
name: component-engineering
description: |-
  Apply the formal standard for React component engineering focusing on accessibility, composition, and styling. Use for building professional, composable React artifacts. Use proactively when creating or reviewing React components.
  Examples:
  - user: "/component-create Button trigger" → build accessible button with asChild and keyboard map
  - user: "/component-review src/components/Input.tsx" → audit for accessibility and composition compliance
  - user: "Build a responsive slider" → select taxonomy type and implement with data attributes
  - user: "Review my layout component" → check for monolithic patterns vs composition
---

<overview>
This skill embodies the formal standard for building professional, accessible, and composable React artifacts.
</overview>

<context name="Knowledge Deep-Dives">
You MUST read these reference files to perform your duties:
- **Architecture**: `composition.md` - asChild, Taxonomy, Composition.
- **Accessibility**: `accessibility.md` - Keyboard maps, ARIA, Focus management.
- **Styling**: `styling.md` - `cn` utility, Data attributes, CVA, Design tokens.
</context>

<workflow>

<phase name="review">
### /component-review [file]
Strictly audit the file against the specification pillars.
1. You MUST read all reference files in the `references/` directory before proceeding.
2. You SHOULD classify the artifact using `taxonomy.md`.
3. Evaluate **Accessibility**: You MUST check keyboard support and semantic HTML against `accessibility.md`.
4. Evaluate **Architecture**: You MUST check for monolithic patterns vs composition against `composition.md`.
5. Evaluate **Styling**: You SHOULD look for `data-slot` usage and prop spreading against `styling.md`.
</phase>

<phase name="create">
### /component-create [name] [intent]
Build a new artifact following the "Architecture First" workflow.
1. You MUST read the relevant `references/*.md` files to select the correct patterns.
2. You SHOULD choose the **Taxonomy** type.
3. You SHOULD select the base **Semantic Element** or **Headless Primitive**.
4. You MUST implement the **Keyboard Map**.
5. You MUST apply **asChild** support if the component is an activator/trigger.
6. You MUST expose **Data Attributes** (`data-state`, `data-slot`).
7. You SHOULD use the `cn` utility for class merging.
</phase>

</workflow>
