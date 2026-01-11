# Composition & Component Architecture Reference

<overview>
Composition is the foundation of modern, flexible UI. You MUST distribute responsibility across multiple cooperating components instead of using monolithic "god components" with dozens of props.
</overview>

<instructions>

### Pillar 1: Composable Components
Break complex UIs into focused sub-components. Follow the **Root-Subpart** pattern.

#### Anti-pattern: The Monolith
```tsx
// ❌ Hard to customize, leads to prop explosion
<Accordion title="Items" data={data} headerClassName="..." contentClassName="..." />
```

#### Pro-pattern: Composition
```tsx
// ✅ Flexible, semantic, no wrapper hell
<Accordion.Root value="item-1">
  <Accordion.Item value="item-1">
    <Accordion.Trigger>Title</Accordion.Trigger>
    <Accordion.Content>Content</Accordion.Content>
  </Accordion.Item>
</Accordion.Root>
```

### Pillar 2: asChild (Slot Pattern)
The `asChild` prop allows a component to merge its behaviors and props into its immediate child, eliminating extra wrapper elements.

#### Usage with Radix UI Slot
```tsx
import { Slot } from "@radix-ui/react-slot";

function Button({ asChild, ...props }) {
  const Comp = asChild ? Slot : "button";
  return <Comp {...props} />;
}

// Usage: Link styled as a Button
<Button asChild>
  <a href="/home">Home</a>
</Button>
```

### Pillar 3: Single Element Wrapping
Each exported component SHOULD wrap exactly **one** HTML or JSX element.
- **Why**: Allows direct prop spreading, easy styling overrides, and predictable DOM structure.
- **Rule**: If you need to style a nested part, you MUST export it as a separate component (e.g., `CardHeader`).

### Pillar 4: Polymorphism (The 'as' prop)
Allows the consumer to specify the HTML element.
- **Preference**: You SHOULD prefer `asChild` for interactive components; use `as` for simple typographic or layout elements.

</instructions>

<context name="Artifact Taxonomy">
1. **Primitive**: Headless, behavior-only foundation (e.g., Radix `Dialog`).
2. **Component**: Styled, reusable unit (e.g., `Button`).
3. **Block**: Composition solving a specific product use case (e.g., `PricingTable`).
4. **Pattern**: Documentation of a recurring composition (e.g., `Typeahead`).
5. **Template**: Page-level scaffold with routing/providers.
6. **Utility**: Non-visual logic (e.g., `useId`, `cn`).
</context>
