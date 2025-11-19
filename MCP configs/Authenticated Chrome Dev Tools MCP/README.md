# Chrome DevTools MCP - Persistent Session Wrapper

This wrapper script allows the **Chrome DevTools MCP** server to connect to your **authenticated Chromium/Chrome session** without requiring you to close your browser or lose your work.

Normally Chromium blocks Google account login in automated browsers, and concurrent sessions can interfere with existing Chrome processes, potentially closing background windows. This wrapper creates a temporary "shadow profile" that clones your cookies, sessions, and login data so the AI agent can work with your logged-in context.

**⚠️ Security Warning**: This enables agentic AI to access all your browser's data including logged-in accounts, cookies, and session information. Use with extreme caution.

## Environment & Compatibility

This script was specifically designed and tested on **Omarchy Arch Linux** running **Chromium** with **Google Account Sync/Login enabled**.

- **OS**: Omarchy Arch Linux
- **Browser**: Chromium (Built with Google API keys/Sync support)
- **Profile Path**: `~/.config/chromium/Default`

While built for this specific setup, it is easily adaptable to standard Arch, Ubuntu, or other distributions using Google Chrome or Brave.

## Features

- **Zero Configuration**: Automatically detects if your browser is open or closed.
- **Non-Destructive**: Never kills your existing browser windows or PWAs.
- **Authenticated Access**: Clones Cookies, Local Storage, and Sessions to let the AI agent "see" what you see (e.g., logged into GitHub, LinkedIn, local tools).
- **Background Execution**: The debugging browser runs in the background and persists even if the tool crashes.
- **Session Snapshot**: Creates a one-time snapshot of your session data - changes made in the shadow browser are not synced back to your main profile.

## Installation

1.  **Copy the script** from this repository:
    The `chrome-devtools-mcp-debug` script is already included in this directory.

2.  **Make it executable**:
    ```bash
    chmod +x chrome-devtools-mcp-debug
    ```

2.  **Make it executable**:
    ```bash
    chmod +x chrome-devtools-mcp-debug
    ```

3.  **Verify the configuration**:
    Open the script and check the variables at the top. The defaults are set for **Chromium**:
    ```bash
    CHROME_BIN=/usr/bin/chromium
    REAL_PROFILE_DIR="$HOME/.config/chromium"
    ```
    _If you are using Google Chrome stable on standard Linux:_
    ```bash
    CHROME_BIN=/usr/bin/google-chrome-stable
    REAL_PROFILE_DIR="$HOME/.config/google-chrome"
    ```

## Usage with OpenCode

To use this with [OpenCode](https://opencode.ai), you need to configure your `opencode.json` file to use this wrapper instead of the default command.

1.  Place the `chrome-devtools-mcp-debug` script in your project root.
2.  Edit (or create) your `opencode.json`:

```json
{
  "mcp": {
    "chrome-devtools": {
      "type": "local",
      "command": ["./chrome-devtools-mcp-debug"]
    }
  },
  "$schema": "https://opencode.ai/config.json"
}
```

3.  **Restart OpenCode** or reload your configuration.

## How it Works

1.  **Check Port**: Checks if `127.0.0.1:9222` (remote debugging) is already open. If so, it connects immediately.
2.  **Check Process**: If the port is closed, it checks if Chromium is running.
3.  **Shadow Copy (If Running)**:
    - If Chromium is running, it copies `Cookies`, `Sessions`, `Login Data` (Google Auth), and `Local Storage` to a temporary directory (`/tmp/chromium-mcp-shadow-$USER`).
    - Launches a **new** Chromium instance pointing to this shadow profile.
4.  **Direct Launch (If Stopped)**:
    - If Chromium is not running, it launches your main profile directly with remote debugging enabled.
5.  **Connect**: Finally, it starts the official `chrome-devtools-mcp` server connected to this debugging instance.

## Troubleshooting

- **"Port 9222 is closed"**: The script will attempt to launch a new instance. If it fails, ensure you have `chromium` installed and accessible at `/usr/bin/chromium`.
- **Missing Data**: If the AI doesn't see you logged in, ensure you are using the `Default` profile. If you use a specific profile (e.g., "Profile 1"), edit `SOURCE_PROFILE` in the script.
