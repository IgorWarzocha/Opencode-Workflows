---
name: component-create
description: Generates a new React component.
---

# /component-create [name] [intent]

<overview>
Generate a professional, spec-compliant React component.
</overview>

<context>
- `name`: Name of the component (e.g., `MetricCard`).
- `intent`: What the component SHOULD do (e.g., "display a value with a trend indicator").
</context>

<workflow>

1. **Load Skill**: You MUST use the `skill` tool to load `component-engineering`.
2. **Read References**: You MUST read the relevant `references/*.md` files to align with the engineering specification.
3. **Design**:
   - Select **Artifact Type** (Primitive, Component, Block).
   - You MUST define the **Keyboard Map** and **Focus Strategy**.
   - Design **Slot** and **State** data attributes.
4. **Implement**:
   - Use **Semantic HTML** or an appropriate **Primitive**.
   - You MUST apply **asChild** support for interactive parts.
   - You MUST implement **Prop Spreading** and **Ref Forwarding**.
5. **Review**: Self-audit the result against the loaded skill.

</workflow>
