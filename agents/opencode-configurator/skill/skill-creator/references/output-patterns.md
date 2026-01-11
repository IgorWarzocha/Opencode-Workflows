# Output Patterns

<template_pattern>

## Template Outputs

**Strict format** (for API responses, data formats):

```markdown
ALWAYS use this structure:

# [Title]
## Executive summary
[One paragraph]
## Key findings
- Finding 1
- Finding 2
## Recommendations
1. Action 1
2. Action 2
```

- MUST use exact structure for strict templates
- MUST NOT deviate from specified headings

**Flexible format** (when adaptation useful):

```markdown
Default format (adjust as needed):

# [Title]
## Summary
## Findings
## Recommendations
```

- SHOULD follow default structure
- MAY adjust based on content needs

</template_pattern>

<examples_pattern>

## Example-Based Outputs

Show input/output pairs when output style matters:

```markdown
**Example 1:**
Input: Added user auth with JWT
Output:
```
feat(auth): implement JWT authentication

Add login endpoint and token middleware
```

**Example 2:**
Input: Fixed date display bug
Output:
```
fix(reports): correct date timezone conversion
```
```

- SHOULD use examples over descriptions for style guidance
- SHOULD include 2-3 examples covering different cases

</examples_pattern>
