# Repo Navigator Pack

Repository documentation specialist that generates AGENTS.md files for AI agent navigation or end-user assistance. The init command replaces the built-in /init and supercharges it.

## Contents

- `agent/repo-navigator.md` – Primary agent (3-word description per primary agent rules)
- `command/init.md` – Unified command with argument routing for 3 modes (basic/full/user)
- `skill/agent-navigation-sop/` – AI navigation workflow (build/test, conventions, routing)
- `skill/user-onboarding-sop/` – User assistance workflow (setup, install, troubleshoot)
- `skill/skill-creator/` – Bundled for creating custom skills during workflows

<img width="1024" height="559" alt="image" src="https://github.com/user-attachments/assets/32ccccb6-bc7a-428a-b1ff-c8e83bd5084c" />

## Usage

Drop into your project or global `~/.config/opencode/` folder. Select the `repo-navigator` agent and run:

| Command | Workflow |
|---------|----------|
| `/init` | Basic: High-density AI navigation AGENTS.md (~50 lines) |
| `/init full` | Full: AI navigation AGENTS.md + skill recommendations |
| `/init user` | User assistance: setup, installation, troubleshooting |

## Workflow Architecture

```
/init [arg]
    │
    ├── Mandatory: Assess repository complexity
    │
    ├── $1 = (empty) ──► Load agent-navigation-sop
    │                    ├── CREATE/ENHANCE/PRESERVE mode detection
    │                    └── Generate high-density AGENTS.md (~50 lines)
    │
    ├── $1 = "full" ────► Load agent-navigation-sop
    │                    ├── CREATE/ENHANCE/PRESERVE mode detection
    │                    ├── Generate high-density AGENTS.md (~50 lines)
    │                    └── Recommend skills, offer to create with skill-creator
    │
    └── $1 = "user" ───► Load user-onboarding-sop
                          ├── Web search for official documentation
                          ├── Analyze installation/usage patterns
                          └── Generate user-focused AGENTS.md (~100 lines)
```

## Key Features

### Mode Detection (AI Navigation)
The init command intelligently handles existing AGENTS.md:

- **CREATE**: No AGENTS.md or empty file → full creative freedom
- **ENHANCE**: Exists but <50 lines, appears auto-generated → restructure freely
- **PRESERVE**: >50 lines or human authorship detected → Edit tool only, touch only outdated facts

**Philosophy**: ENHANCEMENT over REPLACEMENT. Human-crafted content is sacred unless explicitly told otherwise.

### Mandatory Complexity Check
Before any workflow, the agent MUST assess:
- Top-level directory count
- Monorepo patterns (packages/, workspaces/)
- Dependency counts
- Language detection

Complex repos trigger the `explore` subagent for thorough analysis.

### Skill-Based SOPs
Workflows are encapsulated in skills for:
- Reusability across different commands
- Clear separation of concerns
- Easier maintenance and updates

### High-Density Output
All workflows prioritize concise, actionable documentation:
- **AI navigation**: ~50 lines, focused on technical facts and task routing
- **User assistance**: ~100 lines, focused on setup and troubleshooting
- **Excludes**: Environment boilerplate, generic navigation, redundant information

## Installation

### Project-specific
```bash
cp -r agents/repo-navigator/* your-project/.opencode/
```

### Global (all projects)
```bash
cp -r agents/repo-navigator/* ~/.config/opencode/
```

## Agent Permissions

The agent whitelists exactly 3 skills:
```yaml
permission:
  skill:
    "*": "deny"
    "agent-navigation-sop": "allow"
    "user-onboarding-sop": "allow"
    "skill-creator": "allow"
```
