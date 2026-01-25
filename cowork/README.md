# Opencode Cowork Pack

A set of agents and skills for autonomous office tasks, featuring an integrated professional **Vault**.

The **Co-Work System** (`cowork/`) automates research, data, and document workflows. It handles planning and file routing while keeping work organized in a structured vault.

---

## Quick Start

1. **Copy the pack to your project**:
2. **Set up the workspace**:
   Use the **Configurator** agent to initialize:
   > "set up the cowork workspace"

3. **Run a task**:
   Issue commands to the **Orchestrator** agent:
   > /cowork "Create a research brief on [Topic], save the research to the vault and draft a memo."

Ask the Orchestrator Agent for guidance. Check out `opencode.json` for advanced settings.

---

## Features

- **Automated Workflows**: Handles complex tasks by coordinating specialized subagents.
- **Visual Verification**: Checks layouts and formatting via image rendering for PDF and PPTX.
- **Continuous Improvement**: Learns from previous sessions via `LESSONS-LEARNED.md`.
- **Organized Storage**: Every file is staged and verified before being archived in the vault.
- **Concurrent Execution**: Executes multiple operations in parallel to save time.

---

## The Vault System

A structured directory for keeping work coherent across sessions:

| Directory | Content |
|-----------|---------|
| `01-Core-Identity/` | CVs, Bios, and Professional Standards. |
| `02-Active-Work/` | Ongoing project storage (`YYYY-MM/`). |
| `03-Research-Intel/` | Research logs and market intelligence. |
| `05-Output-Staging/` | Final artifacts ready for use. |
| `06-Archive/` | Completed projects and history. |

---

## Installation

To use this pack in your project:

```bash
cp -r cowork/.opencode .
cp -r cowork/vault .
```

To install agents globally (although not recommended):

```bash
cp cowork/.opencode/agent/* ~/.config/opencode/agent/
```

---

## Included Agents

| Agent | Description |
|-------|-------------|
| `cowork-orchestrator` | Main entry point. Manages the vault and coordinates specialists. |
| `research-specialist` | Intelligence gathering and deep-dive research. |
| `data-analyst` | Data processing and Excel/CSV operations. |
| `document-specialist` | Word/PDF document creation and structure. |
| `presentation-expert` | PowerPoint presentations and visual assets. |
| `admin-assistant` | Handles coordination and repository hygiene. |
| `cowork-configurator` | Manages system configuration and workspace setup. |

---

## Technical Details

- **Browser Control**: Uses `playwriter` for web interaction and visual checks.
- **Auto-Formatting**: Uses `@franlol/opencode-md-table-formatter` for clean markdown tables.
- **Subagent Permissions**: Subagents can spawn their own sub-processes for complex tasks.
- **RFC 2119 + XML**: All markdown files use strict keywords and tags for reliable behavior.
