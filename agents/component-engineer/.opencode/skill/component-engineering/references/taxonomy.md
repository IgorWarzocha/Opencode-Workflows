# Artifact Taxonomy Reference

<overview>
Use these heuristics to classify and name UI artifacts.
</overview>

<context>

### 1. Primitive
Headless, unstyled behavioral foundation. You MUST encapsulate semantics, focus, keyboard, and ARIA.
- **Example**: Radix UI Dialog.

### 2. Component
Styled, reusable UI unit. You MUST add visual design to primitives.
- **Example**: shadcn/ui Button.

### 3. Pattern
Specific composition of primitives/components solving a recurring problem. Independent of implementation.
- **Example**: Form validation with inline errors.

### 4. Block
Opinionated, production-ready composition for a specific use case (e.g., Pricing Table). Trades generality for speed.

### 5. Page
Complete single-route view composed of multiple blocks.

### 6. Template
Multi-page collection or full-site scaffold.

### 7. Utility
Non-visual helper for ergonomics or composition (e.g., hooks, class utilities).

</context>
