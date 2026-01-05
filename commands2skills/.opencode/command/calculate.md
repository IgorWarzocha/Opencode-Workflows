---
description: Quick math via CLI tool
---

<arguments>
$ARGUMENTS contains the mathematical expression to evaluate.
If empty, determine appropriate calculation from conversation context.
</arguments>

<instructions>

1. Parse the calculation request from $ARGUMENTS
2. Execute using the calculate.js CLI tool:
   ```bash
   node calculate.js "$EXPRESSION"
   ```
3. Format and display the result with context

</instructions>

<supported_operations>

| Category | Operations |
|----------|------------|
| Basic | `+`, `-`, `*`, `/` |
| Power | `^` (e.g., `2 ^ 8`) |
| Functions | `sqrt()`, `log()`, `sin()`, `cos()`, `tan()` |
| Constants | `pi`, `e` |

</supported_operations>

<examples>

- `15 + 27` → Basic addition
- `2 ^ 10` → Power calculation (1024)
- `sqrt(25) + 3` → Square root with addition (8)
- `50 * sin(30)` → Trigonometric calculation

</examples>

<error_handling>

- Invalid expressions return clear error messages
- Division by zero handled gracefully
- Unsupported operations flagged with suggestions

</error_handling>
