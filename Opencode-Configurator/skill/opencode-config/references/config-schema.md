# OpenCode Config Schema Reference

Complete `opencode.json` / `opencode.jsonc` options.

## Top-Level Options

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  
  // Model Configuration
  "model": "provider/model-id",
  "small_model": "provider/model-id",
  "provider": {},
  "disabled_providers": ["openai", "gemini"],
  
  // UI & Updates
  "theme": "opencode",
  "autoupdate": true,
  "tui": { "scroll_speed": 3 },
  "keybinds": {},
  
  // Sharing
  "share": "manual",  // "manual" | "auto" | "disabled"
  
  // Tools & Permissions
  "tools": {},
  "permission": {},
  
  // Agents & Commands
  "agent": {},
  "command": {},
  
  // Instructions & MCP
  "instructions": [],
  "mcp": {},
  
  // Formatters
  "formatter": {}
}
```

## Model Configuration

### model / small_model

```jsonc
{
  "model": "anthropic/claude-sonnet-4-20250514",
  "small_model": "anthropic/claude-3-5-haiku-20241022"
}
```

Format: `provider/model-id`. Run `opencode models` to list available models.

### provider

Configure custom providers or override settings:

```jsonc
{
  "provider": {
    "anthropic": {
      "models": {},
      "options": {
        "apiKey": "{env:ANTHROPIC_API_KEY}"
      }
    }
  }
}
```

### disabled_providers

Prevent providers from loading even if credentials exist:

```jsonc
{
  "disabled_providers": ["openai", "gemini"]
}
```

## Tools Configuration

Enable/disable tools globally:

```jsonc
{
  "tools": {
    "bash": true,
    "edit": true,
    "write": true,
    "read": true,
    "glob": true,
    "grep": true,
    "list": true,
    "patch": true,
    "webfetch": true,
    "todowrite": true,
    "todoread": true,
    "skill": true
  }
}
```

Wildcards supported for MCP tools:

```jsonc
{
  "tools": {
    "mymcp_*": false
  }
}
```

## Permissions

### Simple Permissions

```jsonc
{
  "permission": {
    "edit": "allow",      // "allow" | "ask" | "deny"
    "webfetch": "ask"
  }
}
```

### Pattern-Based Bash Permissions

```jsonc
{
  "permission": {
    "bash": {
      "*": "allow",           // Default for all
      "rm *": "ask",          // Ask before delete
      "rm -rf *": "deny",     // Block recursive delete
      "sudo *": "deny",       // Block sudo
      "git push": "ask",      // Ask before push
      "npm run *": "allow"    // Allow npm scripts
    }
  }
}
```

### Skill Permissions

```jsonc
{
  "permission": {
    "skill": {
      "*": "allow",
      "dangerous-*": "deny",
      "experimental-*": "ask"
    }
  }
}
```

## Agent Configuration

Define agents in config:

```jsonc
{
  "agent": {
    "my-agent": {
      "description": "What triggers this agent",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-20250514",
      "prompt": "System prompt or {file:./prompt.txt}",
      "temperature": 0.3,
      "maxSteps": 25,
      "disable": false,
      "tools": {
        "bash": false
      },
      "permission": {
        "edit": "ask"
      }
    }
  }
}
```

## Commands

Custom slash commands:

```jsonc
{
  "command": {
    "test": {
      "template": "Run tests and show failures. $ARGUMENTS",
      "description": "Run test suite",
      "agent": "build",
      "model": "anthropic/claude-sonnet-4-20250514"
    }
  }
}
```

Use `$ARGUMENTS` for user input after command.

## Instructions

Include additional instruction files:

```jsonc
{
  "instructions": [
    "CONTRIBUTING.md",
    "docs/guidelines.md",
    ".cursor/rules/*.md",
    "packages/*/AGENTS.md"
  ]
}
```

Supports glob patterns.

## Formatters

Configure code formatters:

```jsonc
{
  "formatter": {
    "prettier": {
      "disabled": true
    },
    "custom": {
      "command": ["npx", "prettier", "--write", "$FILE"],
      "environment": { "NODE_ENV": "development" },
      "extensions": [".js", ".ts", ".jsx", ".tsx"]
    }
  }
}
```

## MCP Servers

Configure Model Context Protocol servers:

```jsonc
{
  "mcp": {
    "my-server": {
      "command": "npx",
      "args": ["-y", "@my/mcp-server"],
      "env": {}
    }
  }
}
```

## Variable Substitution

### Environment Variables

```jsonc
{
  "model": "{env:OPENCODE_MODEL}",
  "provider": {
    "openai": {
      "options": {
        "apiKey": "{env:OPENAI_API_KEY}"
      }
    }
  }
}
```

### File Contents

```jsonc
{
  "agent": {
    "custom": {
      "prompt": "{file:./prompts/custom.txt}"
    }
  },
  "provider": {
    "anthropic": {
      "options": {
        "apiKey": "{file:~/.secrets/anthropic-key}"
      }
    }
  }
}
```

## TUI Options

```jsonc
{
  "tui": {
    "scroll_speed": 3
  }
}
```

## Sharing Options

```jsonc
{
  "share": "manual"  // "manual" | "auto" | "disabled"
}
```

- `manual` - Share via `/share` command (default)
- `auto` - Auto-share new conversations
- `disabled` - No sharing
