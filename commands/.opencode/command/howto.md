---
description: Create wiki-style AGENTS.md
---

<objective>
Analyze this repository and create an EXHAUSTIVE AGENTS.md file for assisting users with setup, running, and troubleshooting. This is for user assistance, NOT development.
</objective>

<workflow>

1. **Research** - Use web search to find official documentation:
   - Search for "[repository name] documentation"
   - Look for official docs sites, README links, llms.txt files
   - Find getting started guides and API references

2. **Analyze** - Deep-dive into repository structure, configs, scripts, and docs

3. **Generate** - Create exhaustive AGENTS.md covering all user-facing functionality

</workflow>

<instructions>

## Required Sections

### Repository Overview
- Software type and purpose
- Main technologies used
- Installation methods

### Official Documentation Resources
- Documentation URLs found via web search
- llms.txt locations if available
- Getting started guides and API/reference docs

### Key Directory Structure
List important directories/files with descriptions:
- `dir/` - purpose (e.g., "Main source code", "Configuration files")
- `file` - purpose (e.g., "Main entry point", "Configuration file")

Focus on directories/files users interact with for setup/usage.

### Setup & Installation
- Prerequisites
- Installation commands
- Configuration steps
- Environment variables

### Running & Usage
- Start/launch commands
- Common usage patterns
- CLI commands and flags
- GUI access methods

### Troubleshooting
- Common issues and solutions
- Log locations
- Debug methods
- Configuration validation

### Key Files for Reference
- README locations
- Config file examples
- Documentation files
- Script files

</instructions>

<rules>

## Output Format

- MUST name the file exactly `AGENTS.md` - no variations (NOT `repo-AGENTS.md`, NOT `USER-AGENTS.md`, NOT `AGENTS-guide.md`)
- MUST place in repository root
- MUST use RFC 2119 keywords (MUST, SHOULD, MAY) and XML tags for structure
- Keep it exhaustive but scannable

## Content Requirements

- MUST be exhaustive; cover all user-facing functionality
- MUST use XML tags to structure sections (`<instructions>`, `<workflow>`, `<rules>`, etc.)
- MUST use RFC keywords for requirements and recommendations
- SHOULD focus on actionable information for helping users
- MUST NOT include development-focused content

</rules>
