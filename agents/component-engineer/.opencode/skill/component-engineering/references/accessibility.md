# Accessibility (a11y) & State Reference

<overview>
Accessibility is a baseline requirement. All components MUST be usable by everyone, including keyboard-only and screen-reader users.
</overview>

<rules>

### 1. Semantic HTML & Keyboard Maps
- **Foundation**: You MUST start with native elements (`<button>`, `<select>`).
- **Keyboard Navigation**: All interactive elements MUST be reachable via `Tab`.
- **Keyboard Map Implementation**:
```tsx
const handleKeyDown = (e: React.KeyboardEvent) => {
  switch(e.key) {
    case 'ArrowDown': focusNext(); break;
    case 'Escape': close(); break;
    case 'Enter': case ' ': select(); break;
  }
};
```

### 2. ARIA Patterns
- **Role**: Define what it is (`role="menu"`, `role="dialog"`).
- **State**: Describe dynamic status (`aria-expanded`, `aria-invalid`, `aria-checked`).
- **Properties**: Define relationships (`aria-controls="id"`, `aria-labelledby="id"`).
- **Live Regions**: Use `aria-live="polite"` for dynamic content updates (e.g., "3 results found").

### 3. Focus Management
- **Focus Trapping**: You MUST use for Modals/Dialogs to keep focus inside while open.
- **Focus Restoration**: You MUST return focus to the trigger element when a component closes.
- **Focus Visible**: Use `:focus-visible` in CSS to show focus indicators only for keyboard users.

### 4. Color & Contrast
- **WCAG Ratios**: 4.5:1 for normal text, 3:1 for large text.
- **Color Independence**: You MUST NOT convey info with color alone. Use icons or text labels.

### 5. Controlled vs. Uncontrolled State
Professional components SHOULD support both modes.
- **Controlled**: Parent owns state via `value` and `onChange`.
- **Uncontrolled**: Component owns state via `defaultValue`.
- **Implementation**: Use `useControllableState` (from Radix UI or similar) to merge both paths seamlessly.

```tsx
const [value, setValue] = useControllableState({
  prop: controlledValue,
  defaultProp: defaultValue,
  onChange: onValueChange,
});
```

</rules>
