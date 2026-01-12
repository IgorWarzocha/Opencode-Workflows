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

# Vite + Shadcn + Tailwind v4 Setup

<instructions>

Protocol for initializing shadcn/ui with Tailwind CSS v4 in a **Vite** project. This skill is Vite-specific due to:

- Vite's solution-style `tsconfig.json` (references pattern)
- `@tailwindcss/vite` plugin requirement
- CSS entry file conventions (`src/index.css`)

For Next.js, Remix, or other frameworks, use their respective shadcn installation guides.

<question_tool>

**Batching Rule:** Use only for 2+ related questions; single questions use plain text.

**Syntax Constraints:** header max 12 chars, labels 1-5 words, mark defaults with `(Recommended)`.

**Purpose:** Clarify component selection, style preferences, and optional AI elements before running shadcn CLI.

</question_tool>

</instructions>

<workflow>

## Step 1: Verify Prerequisites [AGENT]


Check that the project is ready:

- `vite.config.ts` exists
- `package.json` contains `tailwindcss` (v4+) and `@tailwindcss/vite`
- TypeScript is configured

If prerequisites are missing, help the user set up Tailwind v4 first.

---

## Step 2: Fix TypeScript Aliases [AGENT]

The shadcn CLI fails if paths aren't in the root `tsconfig.json`. Vite uses a solution-style config with references, but shadcn doesn't parse those.

**Action:** Update `tsconfig.json` to include `compilerOptions`:

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

---

## Step 3: Verify Vite Config [AGENT]

Confirm `vite.config.ts` has the Tailwind plugin and path alias:

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

---

## Step 4: Initialize Shadcn [USER]

**Tell the user to run:**

```bash
npx shadcn@latest init
```

Recommend these settings:

- Style: New York
- Base Color: Neutral or Zinc
- CSS Variables: Yes

**Wait for user confirmation before continuing.**

---

## Step 5: Add Components [USER]

**Tell the user to run:**

```bash
npx shadcn@latest add
```

Instruct them to select all components (`a` then Enter).

**Wait for user confirmation before continuing.**

---

## Step 6: Add Extensions (Optional) [USER]

If user wants AI elements, **tell them to run:**

```bash
npx shadcn@latest add @ai-elements/all
```

Instruct them to answer **NO** to all overwrite prompts.

**Wait for user confirmation before continuing.**

---

## Step 7: Install Missing Dependencies [AGENT]

The CLI may miss dependencies. Check `package.json` and install any missing:

**Required packages:**

- `tw-animate-css` (devDep) - v4 replacement for `tailwindcss-animate`
- `tailwind-merge` (dep) - used by `cn()` utility
- `clsx` (dep) - used by `cn()` utility
- `class-variance-authority` (dep) - used by shadcn components

**Run if any are missing:**

```bash
npm install tailwind-merge clsx class-variance-authority
npm install -D tw-animate-css
```

---

## Step 8: Clean CSS for v4 Compliance [AGENT]

Rewrite `src/index.css` to match strict v4 structure:

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

**Remove these if present:**

- `@media (prefers-color-scheme)` blocks
- Duplicate `@theme` blocks (keep only `@theme inline`)
- `@config` directives

---

## Step 9: Verify Setup [AGENT]

Run typecheck to catch any issues:

```bash
npm run lint
```

Fix any TypeScript errors before marking setup complete.

</workflow>
