---
description: Package plugin as npm package
---
# OpenCode Plugin Packaging Instructions

## Mission
**Your Task:** Convert $1 JS/TS OpenCode plugin directory into a publishable npm package.
**Runtime:** OpenCode uses **Bun**. Output must be **ESM**.
**Constraint:** Execute idempotently. Do not break existing logic.

**Plugin Name:** $1

## 1. Required Analysis

### 1.1 Identify Entrypoint
You MUST locate the main export file:
- Standard: `src/index.ts` or `plugin/main.ts`  
- OpenCode nested: `.opencode/plugin/PLUGIN_NAME/index.ts`
- Root-level: `index.ts` (common for npm plugins)

### 1.2 Determine Package Name
You MUST use scoped naming: `@username/plugin-name`
- Use the npm username as scope
- Package name must be lowercase/kebab-case
- For plugin "$1", use appropriate naming convention

### 1.3 Validate Plugin Interface
You MUST ensure entrypoint exports a function satisfying `Plugin` type from `@opencode-ai/plugin`:
```ts
import type { Plugin } from "@opencode-ai/plugin"
export const MyPlugin: Plugin = implementation
```

## 2. Project Structure & Dependencies

### 2.1 Create package.json
You MUST create/update `package.json` with this exact ESM configuration:
```json
{
  "name": "{{PLUGIN_NAME}}",
  "version": "0.1.0",
  "type": "module",
  "main": "./dist/index.js",
  "types": "./dist/index.d.ts",
  "files": [ "dist", "README.md", "LICENSE" ],
  "peerDependencies": {
    "@opencode-ai/plugin": "^1.0.0"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "@types/node": "^20.0.0",
    "@opencode-ai/plugin": "^1.0.0"
  },
  "scripts": {
    "build": "tsc -p tsconfig.json",
    "prepublishOnly": "npm run build"
  }
}
```
**Note**: DO NOT include `"exports"` field - it causes Bun installation failures

### 2.2 Install Dependencies
You MUST install these dependencies:
```bash
npm install --save-dev typescript @types/node @opencode-ai/plugin
```

## 3. TypeScript Configuration

### 3.1 Create tsconfig.json
You MUST configure for pure ESM output with these exact settings:
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "declaration": true,
    "outDir": "./dist"
  },
  "include": ["."]
}
```

## 4. Required Refactoring

### 4.1 Handle OpenCode Structure
If plugin exists in `.opencode/plugin/PLUGIN_NAME/`, you MUST:
1. **Option A**: Move files to root level for npm packaging (simpler)
2. **Option B**: Copy to `src/` to preserve existing installation
3. Choose based on project needs - both approaches work

### 4.2 Create index.ts (at root or src/)
You MUST create this entrypoint:
```ts
import type { Plugin } from "@opencode-ai/plugin";
import { implementation } from "./impl"; 

export const MyPlugin: Plugin = implementation;
```

### 4.3 ESM Import Extensions
TypeScript handles extensions automatically. Use standard imports:
```ts
import { implementation } from "./impl"  // Works fine
```

## 5. Documentation

### 5.1 Create README.md
You MUST generate with this exact installation block:
```markdown
# {{PLUGIN_NAME}}

[Plugin description]

## Installation

Add to your repository `opencode.json` or user-level `~/.config/opencode/opencode.json`:

```json
{
  "plugin": ["{{PACKAGE_NAME}}"]
}
```

## How It Works

[Brief explanation of plugin functionality]
```

## 6. Verification & Publish

### 6.1 Build Package
You MUST run:
```bash
npm run build
```

### 6.2 Verify Output
You MUST verify `dist/` contains:
- `index.js` (ESM module)
- `index.d.ts` (TypeScript declarations)
- Any other compiled files

### 6.3 Test Module Loading
You MUST test with:
```bash
node -e "import('./dist/index.js').then(console.log)"
```
This MUST output the plugin function without errors.

### 6.4 Publish to npm
You MUST publish:
```bash
npm whoami  # Check login
npm publish --access public
```

## 7. Required Validation

### 7.1 Common Issues & Fixes
You MUST fix these issues if encountered:
- **"Unexpected token export"**: Ensure `package.json` has `"type": "module"`
- **Import resolution failures**: Verify `"moduleResolution": "bundler"` in tsconfig.json
- **Type errors**: Add `@opencode-ai/plugin` to devDependencies
- **Bun installation failures**: Remove `"exports"` field from package.json

### 7.2 Mandatory Validation Checklist
You MUST complete ALL these checks:
- [ ] Package name uses scope: `@username/plugin-name`
- [ ] `type: "module"` in package.json
- [ ] No `"exports"` field in package.json (Bun compatibility)
- [ ] Build produces `.js` and `.d.ts` files
- [ ] Module verification passes
- [ ] Installation instructions are exact format

## 8. Migration Requirements

When converting from OpenCode's nested structure, you MUST:
- **Option A**: Move files from `.opencode/plugin/PLUGIN_NAME/` to root level
- **Option B**: Copy to `src/` structure if you prefer separation
- **Option C**: Keep as-is if already at root level
- Test that the plugin builds and loads correctly
- Consider separate git branches for npm maintenance if maintaining both structures