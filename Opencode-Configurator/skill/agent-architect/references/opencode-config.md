# OpenCode Agent Configuration Reference

## File Locations

Agent definitions are markdown files in:
- `.opencode/agent/<name>.md` (project)
- `~/.config/opencode/agent/<name>.md` (global)

## Complete Frontmatter Schema

```yaml
---
# Core Configuration
model: "provider/model-id"           # Model override
temperature: 0.7                     # Sampling temperature
top_p: 0.9                           # Nucleus sampling
prompt: "Custom system prompt"       # Or use markdown body
description: "Agent description"     # Shown in listings, triggers agent
mode: "subagent" | "primary" | "all" # Agent availability
color: "#FF5733"                     # UI color
maxSteps: 25                         # Max tool call steps
disable: false                       # Disable agent

# Tool Access Control
tools:
  edit: true
  write: true
  bash: true
  read: true
  glob: true
  grep: true
  webfetch: true
  task: true
  skill: true

# Permissions
permission:
  edit: "ask" | "allow" | "deny"
  bash:
    "*": "allow"
    "git *": "deny"
  skill:
    "*": "allow"
    "my-skill": "deny"
  webfetch: "ask" | "allow" | "deny"
  doom_loop: "ask" | "allow" | "deny"
  external_directory: "ask" | "allow" | "deny"
---
```

## Agent Mode Types

| Mode | Description |
|------|-------------|
| `primary` | User-selectable, can be default, spawns subagents |
| `subagent` | Only callable via `task` tool by other agents |
| `all` | Both primary and subagent (default) |

## Permission System

### Permission Values

| Value | Behavior |
|-------|----------|
| `"allow"` | Automatically permit |
| `"ask"` | Prompt user for approval |
| `"deny"` | Automatically reject |

### Permission Categories

#### `edit`
Controls `edit` and `write` tools.

#### `bash`
Controls command execution. Supports wildcard patterns:

```yaml
bash:
  "*": "ask"              # Ask for everything by default
  "git *": "allow"        # Allow all git commands
  "npm *": "allow"        # Allow npm commands
  "rm *": "deny"          # Block deletion
```

#### `skill`
Controls skill access:

```yaml
skill:
  "*": "deny"             # Deny all by default
  "my-skill": "allow"     # Allow specific skill
```

#### `webfetch`
Controls web fetching. `"ask"` prompts for each URL.

#### `doom_loop`
Controls doom loop detection (agent stuck in repetitive patterns).

#### `external_directory`
Controls access to files outside working directory. Affects:
- bash commands referencing external paths
- read/edit/write for external files

## Default Permissions

If not specified, agents inherit from global config:

```yaml
permission:
  edit: "allow"
  bash: { "*": "allow" }
  skill: { "*": "allow" }
  webfetch: "allow"
  doom_loop: "ask"
  external_directory: "ask"
```

---

## Available Tools

### File Operations

| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `read` | Read file contents | `filePath`, `offset`, `limit` |
| `edit` | String replacement in files | `filePath`, `oldString`, `newString`, `replaceAll` |
| `write` | Create/overwrite files | `filePath`, `content` |

### Search & Navigation

| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `glob` | Find files by pattern | `pattern`, `path` |
| `grep` | Search file contents (regex) | `pattern`, `path`, `include` |
| `list` | List directory contents | `path` |

### Command Execution

| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `bash` | Execute shell commands | `command`, `timeout`, `workdir`, `description` |

Default timeout: 120000ms. Permissions: `bash`, `external_directory`.

### Web & External

| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `webfetch` | Fetch web content | `url`, `format` (text/markdown/html), `timeout` |
| `websearch` | Web search via Exa AI | `query`, `numResults` |
| `codesearch` | Code/SDK documentation search | `query`, `tokensNum` |

### Task Management

| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `task` | Launch subagents | `description`, `prompt`, `subagent_type`, `session_id` |
| `todowrite` | Update todo list | `todos` array |
| `todoread` | Read todo list | (none) |

### Other Tools

| Tool | Purpose | Notes |
|------|---------|-------|
| `skill` | Load skill instructions | Parameter: `name` |
| `batch` | Parallel tool execution | Experimental: `config.experimental.batch_tool` |
| `lsp` | Language Server Protocol | Experimental: `OPENCODE_EXPERIMENTAL_LSP_TOOL` |

---

## Tool Access Control

Disable specific tools for an agent:

```yaml
tools:
  bash: false      # No shell access
  webfetch: false  # No web access
  task: false      # Cannot spawn subagents
```

All tools inherit from global `config.tools` by default.

---

## Examples

### Restricted Code Review Agent

```yaml
---
description: Safe code reviewer. No shell or web access.
mode: primary
tools:
  bash: false
  webfetch: false
  write: false
permission:
  edit: "ask"
  external_directory: "deny"
---
You are a code review specialist...
```

### Research Subagent

```yaml
---
description: Web research agent for gathering information.
mode: subagent
permission:
  bash: { "*": "deny" }
  webfetch: "allow"
  edit: "deny"
---
You are a research specialist...
```

### Deployment Agent with Specific Commands

```yaml
---
description: Deployment helper. Use for "deploy to staging/prod".
mode: primary
permission:
  bash:
    "*": "deny"
    "git *": "allow"
    "npm run build": "allow"
    "npm run deploy:*": "ask"
  skill:
    "deploy-checklist": "allow"
    "*": "deny"
---
You are a deployment specialist...
```
