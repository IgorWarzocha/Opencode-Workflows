---
description: Modularise and optimise code
---

<context>
Targets: $ARGUMENTS

If no targets specified, identify files created this session or scan for worst offenders (250+ lines).
</context>

<objective>
Modularise and clean up code according to strict standards.
</objective>

<instructions>

## File Structure & Modularity

- MUST break large files into focused, single-purpose modules
- SHOULD use barrel exports (`index.ts`) to expose public APIs
- MUST start every file with a 2-3 sentence block comment explaining its purpose:

```typescript
/**
 * utils/formatting.ts
 * Provides currency and date formatting utilities for the billing dashboard.
 * Handles locale detection and fallback states.
 */
```

## Code Hygiene

- MUST remove ALL emojis from comments, strings, and UI text unless strictly necessary
- MUST remove chatty or redundant comments; comment ONLY major sections or complex logic
- SHOULD remove excessive defensive checks if data path is trusted or validated
- MUST NOT use `any` casts; fix the types properly
- MUST remove all `console.log` statements

## Core Principles

- MUST abstract patterns seen twice (DRY)
- MUST throw errors clearly; MUST NOT hide failures
- SHOULD fail fast with clear error messages

</instructions>

<workflow>

1. Analyze files against these rules
2. Refactor structure (split files if needed)
3. Clean up code (remove slop, add headers, fix types)

</workflow>
