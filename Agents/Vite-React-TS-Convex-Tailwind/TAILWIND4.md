# TAILWIND4.md — Tailwind CSS 4.1 Agent Reference

> Use this file as a *mechanical spec* for Tailwind CSS v4.1.
> Assume modern browsers (Safari ≥16.4, Chrome ≥111, Firefox ≥128) unless legacy mode is explicitly required.
> v4.1 Released: April 2025.

---

## 1. Mental Model

- Tailwind v4+ is **CSS-first**:
  - No `@tailwind base/components/utilities` by default.
  - Single main CSS entry (for example `app.css`) with:
    - `@import "tailwindcss";`
    - Optional `@theme { ... }`, `@utility`, `@variant`, `@custom-variant`, `@source`, `@apply`, `@reference`.
- Design tokens are **theme variables**:
  - Declared via `@theme { --namespace-token: value; }`.
  - Tokens determine which utilities and variants exist.
- The build engine:
  - Scans **source files as plain text** for class tokens.
  - Generates CSS only for used utilities (+ any safelisted via `@source inline()`).
- v4.1 builds on v4.0:
  - **New Utilities**: Text shadows (`text-shadow-*`), colored drop shadows (`drop-shadow-*`), masks (`mask-*`), overflow wrap (`wrap-*`).
  - **New Alignments**: Baseline-last alignment (`items-baseline-last`) and safe alignment variants.
  - **Improved Fallbacks**: Better degradation for `oklab`/`oklch` and `@property` in older browsers (Safari 15, Firefox <128).

---

## 2. Installation & Build Setup

### 2.1 Base CSS entry file

- Always have a main stylesheet, e.g. `src/app.css`:

  - Minimal:

        @import "tailwindcss";

  - With design tokens:

        @import "tailwindcss";
        @theme {
          --font-sans: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
          --color-brand-500: oklch(0.72 0.14 250);
          --breakpoint-2xl: 96rem;
        }

### 2.2 Common integration patterns

- **Vite plugin** (preferred for most React / Svelte / Vue / etc.):
  - Install via npm: `tailwindcss` + `@tailwindcss/vite`
  - `vite.config.ts`:
        import { defineConfig } from "vite";
        import tailwindcss from "@tailwindcss/vite";
        export default defineConfig({
          plugins: [tailwindcss()],
        });

- **CLI**:
  - Use when no bundler or as standalone build step.
  - Command: `tailwindcss -i ./src/app.css -o ./dist/output.css --watch`

- **PostCSS plugin**:
  - Install `tailwindcss` + `@tailwindcss/postcss`.
  - Configure in `postcss.config` and import CSS via `@import "tailwindcss";`.

### 2.3 Project layout assumptions

- Tailwind scans **all non-ignored files** under the working directory by default.
- Automatically skips: `node_modules/`, `.gitignore` entries, binary files, and CSS files.

---

## 3. Theme Variables & Design Tokens

> Full docs: https://tailwindcss.com/docs/theme

### 3.1 Defining tokens with `@theme`

- Syntax:

      @theme {
        --color-brand-500: oklch(0.75 0.12 260);
        --font-display: "Satoshi", system-ui, sans-serif;
        --text-xl: 1.25rem;
        --leading-snug: 1.375;
        --breakpoint-3xl: 120rem;
      }

- Effect:
  - Creates utilities and/or variants **derived from namespaces**.
  - Tailwind also defines CSS variables mirroring tokens for direct use.

### 3.2 Key namespaces (pattern, not exhaustive)

- `--color-*` → color utilities (`bg-*`, `text-*`, `border-*`, `shadow-*`).
- `--font-*` → `font-*` utilities.
- `--text-*` → `text-*` size utilities.
- `--font-weight-*` → `font-*` weight utilities.
- `--tracking-*` → `tracking-*` (letter-spacing) utilities.
- `--leading-*` → `leading-*` (line-height) utilities.
- `--radius-*` → `rounded-*` utilities.
- `--shadow-*` → `shadow-*` (box-shadow) and `text-shadow-*` (v4.1).
- `--spacing` → Global spacing scale (margin, padding, width, height, gap).
- `--breakpoint-*` → Responsive variants (`sm:*`, `md:*`, `3xl:*`).

### 3.3 Using tokens directly

- CSS variable form: `var(--color-brand-500)`
- Arbitrary value: `bg-[var(--color-brand-500)]` or `px-[calc(var(--spacing)*3)]`.

### 3.4 Overriding the default theme

- Default tokens live in `tailwindcss/theme.css`.
- To override, simply declare the same variable name in your `@theme` block.
- To extend, declare new variable names.

---

## 4. Functions and Directives

> Full docs: https://tailwindcss.com/docs/functions-and-directives

### 4.1 Core directives

- `@import "tailwindcss";`
  - Required entry point. optionally `source("../src")`.
- `@theme { ... }`
  - Declares design tokens.
- `@source <path>` / `@source not <path>`
  - Explicitly include/exclude directories.
- `@source inline("...")`
  - Safelist specific classes. Supports brace expansion: `inline("{hover:,}bg-red-500")`.
- `@utility <name> { ... }`
  - Define custom utilities that support variants:
        @utility tab-4 { tab-size: 4; }
- `@variant`
  - Apply existing variants in custom CSS:
        @variant dark { background: black; }
- `@custom-variant <name> (<selector>)`
  - Register new variant:
        @custom-variant theme-midnight (&:where([data-theme="midnight"] *));
- `@apply`
  - Inline utility styles.
- `@reference "<path>"`
  - Import theme variables/utilities for use in `@apply` without outputting CSS.

### 4.2 Build-time functions

- `--alpha(color / opacity)`
  - Modifies color opacity: `color: --alpha(var(--color-red-500) / 50%);`
- `--spacing(n)`
  - Access spacing scale: `padding: --spacing(4);`

---

## 5. Content Detection & Safelisting

> Full docs: https://tailwindcss.com/docs/detecting-classes-in-source-files

### 5.1 Class detection rules

- Scans files as **plain text**.
- **NO** string concatenation: `text-{{ color }}-600` (Will not work).
- **YES** full class names: `text-red-600`.
- Maps/Objects:
      const variants = { error: "text-red-600", success: "text-green-600" };

### 5.2 Explicit sources & Safelisting

- Add source: `@source "../node_modules/ui-lib";`
- Safelist:
      @source inline("text-shadow-sm", "text-shadow-red-500");

---

## 6. Variants (States, Responsive, Container, etc.)

> Full docs: https://tailwindcss.com/docs/hover-focus-and-other-states

### 6.1 Common state variants

- `hover:`, `focus:`, `active:`, `visited:`, `disabled:`
- `focus-visible:`, `focus-within:`
- `group-*` (parent state), `peer-*` (sibling state).

### 6.2 Responsive breakpoints

- Derived from `--breakpoint-*`.
- Standard: `sm:`, `md:`, `lg:`, `xl:`, `2xl:`.
- Custom: `3xl:`, `mobile:` (if defined in theme).

### 6.3 Dark mode

> Full docs: https://tailwindcss.com/docs/dark-mode

- Default: Uses `prefers-color-scheme`.
- Class-based override:
      @custom-variant dark (&:where(.dark, .dark *));

### 6.4 Container queries

> Full docs: https://tailwindcss.com/docs/responsive-design#container-queries

- Parent: `class="@container"` (or `@container/name`).
- Child variants: `@sm:`, `@md:`, `@lg:`, `@xl:`.
- Range variants: `@min-md:@max-xl:hidden`.

### 6.5 v4.1 Interaction & Device Variants

- **Pointer**: Target input precision.
  - `pointer-coarse:` (touch), `pointer-fine:` (mouse).
  - `any-pointer-coarse:`, `any-pointer-fine:`.
- **Hover capability**:
  - `hover-hover:` (device can hover), `hover-none:` (cannot hover).
- **Scripting**:
  - `noscript:` (Applies when JS is disabled).

### 6.6 Form Validation (v4.1)

- `user-valid:` / `user-invalid:`
  - Matches `:user-valid` / `:user-invalid` pseudo-classes (style only after user interaction).
  - Example:
        <input class="border user-invalid:border-red-500 user-valid:border-green-500" />

---

## 7. Layout, Spacing, Transforms, and Effects

### 7.1 3D Transforms (v4+)

- Utilities: `rotate-x-*`, `rotate-y-*`, `scale-z-*`, `translate-z-*`.
- `perspective-*`, `perspective-origin-*`.
- `transform-3d`, `transform-flat` (preserves-3d vs flat).

### 7.2 v4.1 Safe Alignment & Baseline

- **Safe Alignment**:
  - Ensures overflowing content remains accessible.
  - Usage: `justify-safe-center`, `align-safe-center`.
- **Baseline Last**:
  - `items-baseline-last`, `self-baseline-last`.
  - Aligns items based on the *last* line of text in the element.

---

## 8. v4.1 Effects: Text Shadow, Masks, Filters

> Full docs: https://tailwindcss.com/docs/text-shadow

### 8.1 Text Shadow Utilities

- **Sizes**: `text-shadow-2xs`, `text-shadow-xs`, `text-shadow-sm`, `text-shadow`, `text-shadow-md`, `text-shadow-lg`, `text-shadow-xl`.
- **Colors**: `text-shadow-red-500`, `text-shadow-black`.
- **Opacity**: `text-shadow-black/50` or `text-shadow-lg/50` (shorthand).
- **None**: `text-shadow-none`.

### 8.2 Mask Utilities

> Full docs: https://tailwindcss.com/docs/mask-image

- **Linear Masks**:
  - `mask-linear`: Creates a linear gradient mask.
  - Direction: `mask-to-t`, `mask-to-b`, `mask-to-r`, `mask-to-l`.
  - Stops: `mask-from-white`, `mask-to-transparent`, `mask-via-black/50`.
- **Radial Masks**:
  - `mask-radial`, `mask-radial-farthest`, `mask-radial-closest`.
  - Position: `mask-at-t`, `mask-at-c`, `mask-at-b`.
- **Image Masks**:
  - `mask-{image-url}` (using arbitrary values or theme).

### 8.3 Colored Drop Shadows

- Syntax: `drop-shadow-{color}`.
- Examples: `drop-shadow-indigo-500`, `drop-shadow-red-500/50`.
- Combines with sizes: `drop-shadow-lg drop-shadow-blue-500`.

### 8.4 Overflow Wrap

- Controls `overflow-wrap` property.
- Utilities:
  - `wrap-normal` (normal)
  - `wrap-break-word` (break-word)
  - `wrap-anywhere` (anywhere) — *v4.1 Addition for aggressive wrapping.*

---

## 9. Browser Compatibility (v4 / v4.1)

> Full docs: https://tailwindcss.com/docs/compatibility

- **Target**: Safari ≥16.4, Chrome ≥111, Firefox ≥128.
- **v4.1 Improvements**:
  - **Color Fallbacks**: `oklch` / `oklab` colors now degrade gracefully in older Safari/Firefox.
  - **@property Fallbacks**: Features relying on `@property` (like gradients interpolating) have better non-interpolating fallbacks.
- **Legacy Support**:
  - Use Tailwind v3.4 if IE11 or strict older browser support is mandated.

---

## 10. Custom Styles & Plugins (v4 Style)

> Full docs: https://tailwindcss.com/docs/adding-custom-styles

### 10.1 CSS-first Extensibility

- **Custom Utility**:
      @utility btn {
        @apply px-4 py-2 rounded bg-blue-500 text-white;
      }
- **Custom Variant**:
      @custom-variant pointer-coarse (@media (pointer: coarse));

### 10.2 Legacy Config

- v4 supports `@config "tailwind.config.js"` for migration.
- `theme()` function works but `--alpha(var(--token))` is preferred.

---

## 11. LLM-Specific Guidance

- **Code Generation**:
  - Use **v4.1 features** (text-shadow, mask, wrap-anywhere) where appropriate.
  - **Do not** use deprecated v3 config (`tailwind.config.js`) unless explicitly asked.
  - Use `@theme` inside the CSS file for tokens.
  - Prefer `@import "tailwindcss";` over `@tailwind ...`.
- **Syntax Precision**:
  - Text Shadow: `text-shadow-sm text-shadow-blue-500/20`.
  - Masks: `mask-linear mask-to-b mask-from-black mask-to-transparent`.
  - Containers: `w-full @container`. Child: `@md:flex-row`.
- **Validation**:
  - If a user asks for "input validation styles", use `user-valid:*` and `user-invalid:*`.
