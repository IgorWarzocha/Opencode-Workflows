---
description: Perform mathematical calculations with basic arithmetic operations and functions
---

## Arguments
- $ARGUMENTS contains the user-provided argument or is empty
- If empty, determine appropriate action from context

**CRITICAL. Always execute these exact steps**

Steps
1. Parse calculation request from $ARGUMENTS
2. Choose appropriate calculation method
   - Basic arithmetic: +, -, *, /
   - Power operations: ^
   - Functions: sqrt(), log(), sin(), cos(), tan()
3. Execute calculation using calculate.js CLI tool
4. Format and display results with context

**Supported operations**
- Basic: addition, subtraction, multiplication, division
- Advanced: powers, square roots, logarithms, trigonometric functions
- Constants: pi, e

**Usage patterns**
- **Simple calculations**: "2 + 3" or "10 * 5"
- **Complex expressions**: "2 + 3 * 4 - 1"
- **Power operations**: "2 ^ 8" (2 to the power of 8)
- **Functions**: "sqrt(16)" or "log(100)"

**Command execution template**
```bash
node calculate.js "$EXPRESSION"
```

**Examples of proper expressions**
- "15 + 27" - Basic addition
- "100 / 4" - Division
- "3.14 * 2" - Decimal multiplication
- "2 ^ 10" - Power calculation
- "sqrt(25) + 3" - Square root with addition
- "50 * sin(30)" - Trigonometric calculation

**Error handling**
- Invalid expressions return clear error messages
- Division by zero handled gracefully
- Unsupported operations flagged with suggestions

Output: Formatted mathematical result with explanation