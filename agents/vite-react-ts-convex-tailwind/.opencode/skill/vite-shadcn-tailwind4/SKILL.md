---
name: vite-shadcn-tailwind4
description: |-
  Initialize shadcn/ui + Tailwind CSS v4 in Vite projects (Vite-specific, not Next.js/Remix). Use proactively for Vite project setup, shadcn component installation, or Tailwind v4 configuration.
  
  Examples:
  - user: "Setup shadcn in my Vite project" → install deps, configure tailwind v4 CSS-first, init shadcn, verify components work
  - user: "Add shadcn to existing Vite app" → check existing config, install CLI, add components.json, update CSS imports
  - user: "Use Tailwind v4 with shadcn" → configure @import with @theme, remove v3 config, setup custom tokens
  - user: "Create Vite + React + shadcn project" → scaffold Vite, install shadcn, configure theme, add sample components
---

<overview>
Protocol for initializing shadcn/ui with Tailwind CSS v4 in a **Vite** project.
</overview>

<instructions>
This skill is Vite-specific due to:
- Vite's solution-style `tsconfig.json` (references pattern)
- `@tailwindcss/vite` plugin requirement
- CSS entry file conventions (`src/index.css`)

For Next.js, Remix, or other frameworks, You MUST use their respective shadcn installation guides.

<question_tool>
- **Batching Rule**: You MUST use only for 2+ related questions; single questions use plain text.
- **Syntax Constraints**: header max 12 chars, labels 1-5 words, mark defaults with `(Recommended)`.
- **Purpose**: Clarify component selection, style preferences, and optional AI elements before running shadcn CLI.
</question_tool>

</instructions>

<workflow>

<phase name="verify-prerequisites">
## Step 1: Verify Prerequisites
Check that the project is ready:
- `vite.config.ts` MUST exist.
- `package.json` MUST contain `tailwindcss` (v4+) and `@tailwindcss/vite`.
- TypeScript MUST be configured.

If prerequisites are missing, You MUST help the user set up Tailwind v4 first.
</phase>

<phase name="fix-typescript-aliases">
## Step 2: Fix TypeScript Aliases
The shadcn CLI fails if paths aren't in the root `tsconfig.json`. Vite uses a solution-style config with references, but shadcn doesn't parse those.

**Action**: You MUST update `tsconfig.json` to include `compilerOptions`:

```json
{
  "files": [],
  "references": [
    { "path": "./tsconfig.app.json" },
    { "path": "./tsconfig.node.json" }
  ],
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}
```
</phase>

<phase name="verify-vite-config">
## Step 3: Verify Vite Config
You MUST confirm `vite.config.ts` has the Tailwind plugin and path alias:

```ts
import tailwindcss from "@tailwindcss/vite";
import path from "path";

export default defineConfig({
  plugins: [react(), tailwindcss()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
});
```
</phase>

<phase name="initialize-shadcn">
## Step 4: Initialize Shadcn
You MUST instruct the user to run:
```bash
npx shadcn@latest init
```

You SHOULD recommend these settings:
- Style: New York
- Base Color: Neutral or Zinc
- CSS Variables: Yes

**You MUST wait for user confirmation before continuing.**
</phase>

<phase name="add-components">
## Step 5: Add Components
You MUST instruct the user to run:
```bash
npx shadcn@latest add
```

You SHOULD instruct them to select all components (`a` then Enter).

**You MUST wait for user confirmation before continuing.**
</phase>

<phase name="add-extensions">
## Step 6: Add Extensions (Optional)
If user wants AI elements, You MUST instruct them to run:
```bash
npx shadcn@latest add @ai-elements/all
```

You SHOULD instruct them to answer **NO** to all overwrite prompts.

**You MUST wait for user confirmation before continuing.**
</phase>

<phase name="install-missing-dependencies">
## Step 7: Install Missing Dependencies
The CLI MAY miss dependencies. You MUST check `package.json` and install any missing.

**Required packages**:
- `tw-animate-css` (devDep) - v4 replacement for `tailwindcss-animate`
- `tailwind-merge` (dep) - used by `cn()` utility
- `clsx` (dep) - used by `cn()` utility
- `class-variance-authority` (dep) - used by shadcn components

**You MUST run if any are missing**:
```bash
npm install tailwind-merge clsx class-variance-authority
npm install -D tw-animate-css
```
</phase>

<phase name="clean-css">
## Step 8: Clean CSS for v4 Compliance
You MUST rewrite `src/index.css` to match strict v4 structure:

```css
@import "tailwindcss";
@import "tw-animate-css";

@custom-variant dark (&:is(.dark *));

@theme inline {
  /* Variable mappings: --color-X: var(--X); */
}

:root {
  /* Token definitions using oklch() */
}

.dark {
  /* Dark mode tokens using oklch() */
}

@layer base {
  * {
    @apply border-border outline-ring/50;
  }
  body {
    @apply bg-background text-foreground;
  }
}
```

You MUST remove these if present:
- `@media (prefers-color-scheme)` blocks
- Duplicate `@theme` blocks (keep only `@theme inline`)
- `@config` directives
</phase>

<phase name="verify-setup">
## Step 9: Verify Setup
You MUST run typecheck to catch any issues:
```bash
npm run lint
```

You MUST fix any TypeScript errors before marking setup complete.
</phase>

</workflow>
