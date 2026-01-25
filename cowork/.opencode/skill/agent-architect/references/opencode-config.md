# OpenCode Agent Configuration Reference

<file_locations>

Agent definitions are markdown files in:
- `.opencode/agent/<name>.md` (project)
- `~/.config/opencode/agent/<name>.md` (global)

</file_locations>

<frontmatter_schema>

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

</frontmatter_schema>

<agent_modes>

| Mode | Description |
|------|-------------|
| `primary` | User-selectable, can be default, spawns subagents |
| `subagent` | Only callable via `task` tool by other agents |
| `all` | Both primary and subagent (default) |

</agent_modes>

<permissions>

## Permission Values

| Value | Behavior |
|-------|----------|
| `"allow"` | Automatically permit |
| `"ask"` | Prompt user for approval |
| `"deny"` | Automatically reject |

## Permission Categories

### `edit`
Controls `edit` and `write` tools.

### `bash`
Controls command execution. Supports wildcard patterns:

```yaml
bash:
  "*": "ask"              # Ask for everything by default
  "git *": "allow"        # Allow all git commands
  "npm *": "allow"        # Allow npm commands
  "rm *": "deny"          # Block deletion
```

### `skill`
Controls skill access:

```yaml
skill:
  "*": "deny"             # Deny all by default
  "my-skill": "allow"     # Allow specific skill
```

### `webfetch`
Controls web fetching. `"ask"` prompts for each URL.

### `doom_loop`
Controls doom loop detection (agent stuck in repetitive patterns).

### `external_directory`
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

</permissions>

<available_tools>

## File Operations

| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `read` | Read file contents | `filePath`, `offset`, `limit` |
| `edit` | String replacement in files | `filePath`, `oldString`, `newString`, `replaceAll` |
| `write` | Create/overwrite files | `filePath`, `content` |

## Search & Navigation

| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `glob` | Find files by pattern | `pattern`, `path` |
| `grep` | Search file contents (regex) | `pattern`, `path`, `include` |
| `list` | List directory contents | `path` |

## Command Execution

| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `bash` | Execute shell commands | `command`, `timeout`, `workdir`, `description` |

Default timeout: 120000ms. Permissions: `bash`, `external_directory`.

## Web & External

| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `webfetch` | Fetch web content | `url`, `format` (text/markdown/html), `timeout` |
| `websearch` | Web search via Exa AI | `query`, `numResults` |
| `codesearch` | Code/SDK documentation search | `query`, `tokensNum` |

## Task Management

| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `task` | Launch subagents | `description`, `prompt`, `subagent_type`, `session_id` |
| `todowrite` | Update todo list | `todos` array |
| `todoread` | Read todo list | (none) |

## Other Tools

| Tool | Purpose | Notes |
|------|---------|-------|
| `skill` | Load skill instructions | Parameter: `name` |
| `batch` | Parallel tool execution | Experimental: `config.experimental.batch_tool` |
| `lsp` | Language Server Protocol | Experimental: `OPENCODE_EXPERIMENTAL_LSP_TOOL` |

</available_tools>

<tool_access_control>

Disable specific tools for an agent:

```yaml
tools:
  bash: false      # No shell access
  webfetch: false  # No web access
  task: false      # Cannot spawn subagents
```

All tools inherit from global `config.tools` by default.

</tool_access_control>

<examples>

## Restricted Code Review Agent (Primary)

```yaml
---
description: Safe code reviewer.
mode: primary
permission:
  edit: "ask"
  bash: "deny"
  write: "deny"
  external_directory: "deny"
---
You are a code review specialist...
```

## Research Agent (Subagent)

```yaml
---
description: |-
  Web research agent. Use when user says "research topic", "find info".
  
  Examples:
  - user: "research" -> search web
mode: subagent
permission:
  skill:
    "*": "deny"
    "web-research": "allow"
---
You are a research specialist...
```

## Deployment Agent (Standard/Undefined)

```yaml
---
description: Deployment helper.
permission:
  skill:
    "*": "deny"
    "deploy-checklist": "allow"
---
You are a deployment specialist...
```

</examples>
