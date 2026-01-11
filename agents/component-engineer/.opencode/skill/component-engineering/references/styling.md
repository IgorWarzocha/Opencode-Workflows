# Styling & Theming Reference

<overview>
Modern component libraries SHOULD use a combination of Tailwind CSS, design tokens, and attribute-driven styling.
</overview>

<instructions>

### 1. The `cn` Utility (Class Merging)
You MUST combine `clsx` (conditional logic) and `tailwind-merge` (intelligent override resolution).
```tsx
import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

### 2. Class Variance Authority (CVA)
Declarative API for managing component variants.
```tsx
const buttonVariants = cva("base-classes", {
  variants: {
    variant: {
      primary: "bg-blue-500 text-white",
      destructive: "bg-red-500 text-white",
    },
    size: {
      sm: "h-8 px-3",
      md: "h-10 px-4",
    }
  },
  defaultVariants: { variant: "primary", size: "md" }
});
```

### 3. Attribute-Driven Styling
You MUST use data attributes to expose internal state to CSS.
- **data-state**: Visual states (`open`, `closed`, `active`).
- **data-slot**: Stable identifiers for sub-parts (`data-slot="trigger"`).
- **Benefit**: No need for `openClassName` props. Style from outside with `data-[state=open]:opacity-100`.

### 4. Design Tokens (Semantic Variables)
You SHOULD separate theme from usage using CSS variables.
```css
:root {
  --background: oklch(1 0 0);
  --primary: oklch(0.2 0 0);
}
.dark {
  --background: oklch(0.1 0 0);
}
```

</instructions>

<context name="Distribution Principles">
- **Registry (Source)**: Users copy code directly (e.g., shadcn/ui). High ownership, easy customization.
- **NPM (Package)**: Pre-built dependency. Centralized updates, harder to customize.
- **Transparency**: You MUST always provide source code access or clear documentation.
</context>
