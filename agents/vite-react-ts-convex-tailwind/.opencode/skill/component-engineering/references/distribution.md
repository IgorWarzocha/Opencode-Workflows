# Component Engineering Principles

<rules>

### Distribution
- You SHOULD provide source maps and readable code.
- You MUST document project structure and dependencies clearly.
- You MUST include migration guides for breaking changes.

</rules>

<context>

### Artifact Taxonomy
1. **Primitive**: Headless, behavior-only foundation (e.g., Radix `Dialog`).
2. **Component**: Styled, reusable unit (e.g., `Button`).
3. **Block**: Composition solving a specific product use case (e.g., `PricingTable`).
4. **Pattern**: Documentation of a recurring composition (e.g., `Typeahead`).
5. **Template**: Page-level scaffold with routing/providers.
6. **Utility**: Non-visual logic (e.g., `useId`, `cn`).

</context>
