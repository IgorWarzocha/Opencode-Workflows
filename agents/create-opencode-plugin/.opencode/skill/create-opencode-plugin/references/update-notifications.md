# Update Notifications for Pinned Versions

> Pattern for notifying users when a newer plugin version is available

<overview>

When users pin plugins to specific versions (e.g., `my-plugin@1.0.0`), OpenCode won't auto-update them. Plugins can check npm for newer versions and show a toast notification, letting users decide when to update.

</overview>

<guidelines>

## When to Use

Use this pattern when:

- Your plugin is published to npm
- Users MAY pin to specific versions for stability
- You want to inform users about available updates

**Not needed for:**

- Local/file-based plugins
- Plugins users always run with `@latest`

</guidelines>

<implementation>

## Implementation

```typescript
/**
 * Update Checker for Pinned Plugin Versions
 *
 * Checks npm registry for newer versions and shows a toast if available.
 * Non-blocking - runs in background and fails silently.
 */

// ============================================================================
// Version Comparison
// ============================================================================

/**
 * Compares two semver versions. Returns true if `latest` is newer than `current`.
 */
function isNewerVersion(current: string, latest: string): boolean {
  const clean = (v: string) => v.replace(/^v/, "")
  const partsA = clean(current).split(".").map(Number)
  const partsB = clean(latest).split(".").map(Number)

  for (let i = 0; i < Math.max(partsA.length, partsB.length); i++) {
    const a = partsA[i] ?? 0
    const b = partsB[i] ?? 0
    if (a < b) return true
    if (a > b) return false
  }
  return false
}

// ============================================================================
// Registry Fetch
// ============================================================================

/**
 * Fetches latest version from npm. Returns null on any error.
 */
async function fetchLatestVersion(packageName: string): Promise<string | null> {
  try {
    const controller = new AbortController()
    const timeout = setTimeout(() => controller.abort(), 5000)

    const response = await fetch(`https://registry.npmjs.org/${packageName}`, {
      headers: { Accept: "application/json" },
      signal: controller.signal,
    })

    clearTimeout(timeout)
    if (!response.ok) return null

    const data = await response.json()
    return data["dist-tags"]?.latest ?? null
  } catch {
    return null
  }
}

// ============================================================================
// Update Checker
// ============================================================================

type UpdateCheckOptions = {
  /** npm package name */
  packageName: string
  /** Current installed version (from package.json) */
  currentVersion: string
  /** Display name for toast */
  pluginName: string
  /** SDK client */
  client: { tui: { showToast: (params: any) => Promise<unknown> } }
  /** Delay before check (ms). Default: 8000 */
  delay?: number
}

/**
 * Checks for updates and shows toast if newer version exists.
 *
 * Call during plugin initialization (fire and forget - MUST NOT await).
 */
export function checkForUpdates(options: UpdateCheckOptions): void {
  const { packageName, currentVersion, pluginName, client, delay = 8000 } = options

  setTimeout(async () => {
    try {
      const latest = await fetchLatestVersion(packageName)
      if (!latest || !isNewerVersion(currentVersion, latest)) return

      await client.tui.showToast({
        body: {
          title: `${pluginName}: Update Available`,
          message: `v${currentVersion} → v${latest}\nUpdate config to use @${latest}`,
          variant: "info",
          duration: 10000,
        },
      })
    } catch {
      // Fail silently - update check is non-critical
    }
  }, delay)
}
```

</implementation>

<examples>

## Usage

### Basic Usage

```typescript
import type { Plugin } from "@opencode-ai/plugin"
// Import version from package.json
import pkg from "./package.json" with { type: "json" }
import { checkForUpdates } from "./update-checker"

const plugin: Plugin = async ({ client }) => {
  // Fire and forget - MUST NOT await
  checkForUpdates({
    packageName: "my-opencode-plugin",
    currentVersion: pkg.version,
    pluginName: "My Plugin",
    client,
  })

  return {
    // ... hooks
  }
}

export default plugin
```

### With Config Toggle

Let users disable update notifications:

```typescript
import type { Plugin } from "@opencode-ai/plugin"
import pkg from "./package.json" with { type: "json" }
import { checkForUpdates } from "./update-checker"

type PluginConfig = {
  checkForUpdates?: boolean // Default: true
}

const plugin: Plugin = async ({ client }) => {
  const config = loadConfig() // Your config loading

  if (config.checkForUpdates !== false) {
    checkForUpdates({
      packageName: "my-opencode-plugin",
      currentVersion: pkg.version,
      pluginName: "My Plugin",
      client,
      delay: 10000,
    })
  }

  return { ... }
}
```

## Toast Format

```
┌─────────────────────────────────────┐
│ My Plugin: Update Available         │
│ v1.0.0 → v1.2.0                     │
│ Update config to use @1.2.0         │
└─────────────────────────────────────┘
```

The message tells users to update their config, since OpenCode manages installation:

```jsonc
// Before
{ "plugin": ["my-plugin@1.0.0"] }

// After
{ "plugin": ["my-plugin@1.2.0"] }
```

</examples>

<best_practices>

## Best Practices

| Practice                    | Reason                                |
| --------------------------- | ------------------------------------- |
| **MUST NOT await**          | Never block plugin initialization     |
| **SHOULD use 8-10s delay**  | Let TUI fully initialize              |
| **MUST fail silently**      | Network issues MUST NOT break plugin  |
| **SHOULD use `info` variant** | Updates aren't urgent               |
| **SHOULD include version numbers** | Show what's available          |
| **MAY add config toggle**   | Respect user preference               |

</best_practices>

<alternative>

## Alternative: Reading Version at Runtime

If JSON import isn't available:

```typescript
import { readFileSync } from "node:fs"
import { join, dirname } from "node:path"
import { fileURLToPath } from "node:url"

const __dirname = dirname(fileURLToPath(import.meta.url))
const pkg = JSON.parse(readFileSync(join(__dirname, "package.json"), "utf8"))
const version: string = pkg.version
```

</alternative>
