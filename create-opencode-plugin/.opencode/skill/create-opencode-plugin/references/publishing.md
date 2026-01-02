# Publishing Plugins

> How to publish plugins to npm

<instructions>

## Before Publishing - Ask the User

Before creating a publishable package, MUST ask the user:

1. **Package name**: What should the npm package be called?
   - Unscoped: `opencode-my-plugin`
   - Scoped: `@username/opencode-my-plugin`

2. **npm scope/username**: If scoped, what's their npm username or org?

3. **Version**: Starting version? (default: `0.1.0`)

4. **License**: MIT, Apache-2.0, etc.? (default: MIT)

5. **Description**: One-line description of what the plugin does

<example>

**Example prompt:**

> "Before I create the npm package, I need a few details:
>
> 1. What should the package name be? (e.g., `opencode-background-process` or `@yourusername/opencode-background-process`)
> 2. What's your npm username/scope if using a scoped package?
> 3. Starting version? (default: 0.1.0)
> 4. License? (default: MIT)"

</example>

## How OpenCode Manages Plugins

**Users do NOT need to run `npm install`** - OpenCode automatically installs plugin dependencies at runtime.

Users simply add the plugin name to their config:

```jsonc
{
  "plugin": [
    "my-plugin@1.0.0", // Pinned version - won't auto-update
    "another-plugin", // No version = "latest" - updates on launch
  ],
}
```

**On launch, OpenCode:**

1. Runs `bun add --force` for each plugin (auto-installs)
2. Caches pinned versions until user changes config
3. For unpinned plugins, resolves `latest` and caches actual version

This means the README SHOULD NOT include `npm install` instructions - just tell users to add the plugin to their config.

</instructions>

<checklist>

## Publishing Checklist

1. **Package structure:**

   ```
   my-plugin/
   ├── src/
   │   └── index.ts          # Main plugin entry
   ├── dist/                  # Built output (gitignored)
   ├── package.json
   ├── tsconfig.json
   ├── README.md
   ├── LICENSE
   ├── example-opencode.json  # Example config for users
   ├── .gitignore
   └── .npmignore
   ```

2. **package.json** (replace placeholders with user's answers):

   ```json
   {
     "name": "<PACKAGE_NAME>",
     "version": "<VERSION>",
     "description": "<DESCRIPTION>",
     "type": "module",
     "main": "dist/index.js",
     "types": "dist/index.d.ts",
     "files": ["dist", "README.md", "LICENSE"],
     "keywords": ["opencode", "opencode-plugin", "plugin"],
     "license": "<LICENSE>",
     "peerDependencies": {
       "@opencode-ai/plugin": "^1.0.0"
     },
     "devDependencies": {
       "@opencode-ai/plugin": "^1.0.0",
       "@types/bun": "^1.2.0",
       "@types/node": "^22.0.0",
       "typescript": "^5.7.0"
     },
     "scripts": {
       "clean": "rm -rf dist",
       "build": "npm run clean && tsc",
       "prepublishOnly": "npm run build"
     },
     "publishConfig": {
       "access": "public"
     }
   }
   ```

   Notes:
   - MUST use `peerDependencies` for `@opencode-ai/plugin` - OpenCode provides this at runtime
   - MUST add `"publishConfig": { "access": "public" }` for scoped packages

3. **example-opencode.json:**

   ```json
   {
     "$schema": "https://opencode.ai/config.json",
     "plugin": ["<PACKAGE_NAME>"]
   }
   ```

4. **README.md Installation Section:**

   ````markdown
   ## Installation

   Add to your `opencode.json`:

   ```json
   {
     "plugin": ["<PACKAGE_NAME>"]
   }
   ```

   OpenCode automatically installs plugin dependencies at runtime.
   ````

5. **Publish:**

   For scoped packages (first time):

   ```bash
   npm publish --access public
   ```

   For unscoped or subsequent publishes:

   ```bash
   npm publish
   ```

</checklist>

<update_notifications>

## Update Notifications for Pinned Versions

When users pin to a specific version (e.g., `my-plugin@1.0.0`), they won't see updates automatically.

SHOULD include an update checker that shows a toast when newer versions are available. See `references/update-notifications.md` for the full implementation.

</update_notifications>

<common_mistakes>

## Common Mistakes

| Mistake                         | Fix                                  |
| ------------------------------- | ------------------------------------ |
| Missing `type: "module"`        | Add to package.json                  |
| Not building before publish     | Add `prepublishOnly` script          |
| Wrong main entry                | Point to compiled JS, not TS         |
| Missing @opencode-ai/plugin dep | Add as peerDependency                |
| Scoped package 404              | Add `publishConfig.access: "public"` |
| Assumed package name            | MUST ask user for name/scope first   |

</common_mistakes>
