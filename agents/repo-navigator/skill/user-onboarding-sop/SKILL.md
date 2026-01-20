---
name: user-onboarding-sop
description: |-
  Generate AGENTS.md for end-user assistance. Covers setup, installation, running, and troubleshooting. This is for END-USER help, NOT developer/contributor docs. Use for /init user workflow.
  
  Examples:
  - user: "/init user" → user assistance AGENTS.md with official docs
  - user: "Create getting started guide" → installation + setup + troubleshooting
  - user: "Document how to use this repo" → user-focused AGENTS.md
  - user: "Help users run this software" → setup, prerequisites, usage patterns
---

# User Onboarding SOP

Standard operating procedure for generating AGENTS.md files optimized for END-USER assistance.

**CRITICAL**: This is NOT for development assistance - it's for END-USER assistance only.

<workflow>

## Phase 1: Gather Repository Context

1. Read root `package.json` to identify project name and type
2. Read root `README.md` for basic project info
3. List root directory contents to understand structure

## Phase 2: Search Official Documentation

**MANDATORY**: You MUST use web search to find real documentation URLs.

- Query: "[repository name] documentation" and "[repository name] getting started"
- Look for official docs sites, README links, llms.txt files
- Find getting started guides and API references
- MUST gather real URLs from web search - do NOT invent URLs

## Phase 3: Analyze Repository Structure

- List IMPORTANT directories only (ignore node_modules, .git, etc.)
- Identify key config files, documentation, scripts
- Focus on directories/files users interact with for setup/usage
- Maximum 2-3 levels deep for directory exploration

## Phase 4: Explore Installation Methods

- Check for install scripts (install, setup, etc.)
- Look for package manager installation docs
- Find prerequisites and environment setup instructions
- Identify configuration files and environment variables

## Phase 5: Identify Running/Usage Patterns

- Find CLI commands and entry points
- Look for start/launch scripts
- Check for GUI/desktop app information
- Identify common usage patterns from documentation

## Phase 6: Document Troubleshooting Resources

- Find log file locations
- Identify debug methods and flags
- Look for common issues in docs
- Check for configuration validation methods

## Phase 7: Create AGENTS.md

Write comprehensive user assistance guide using the structure below.
MUST be actionable and concise (LLM reference, not user docs).
Focus on practical information for helping users.

</workflow>

<output_structure>

## Repository Overview

- Software type and purpose (1 line)
- Main technologies used (tech stack)
- Installation methods available

## Official Documentation Resources

- Primary documentation URLs (from web search)
- Getting started guides
- CLI/reference documentation
- Troubleshooting guides
- Community resources (Discord, issues, etc.)

## Key Directory Structure

List only IMPORTANT directories with brief descriptions:

- `dir/` - purpose (e.g., "Main source code", "Configuration files")
- `file` - purpose (e.g., "Main entry point", "Installation script")

Focus on what users interact with for setup/usage.

## Setup & Installation

- Prerequisites (what users need before installing)
- Installation commands (all available methods)
- Configuration steps (initial setup)
- Environment variables (important ones)

## Running & Usage

- Start/launch commands
- Common usage patterns
- CLI commands and flags
- GUI access methods (if applicable)

## Troubleshooting

- Common issues and solutions
- Log locations
- Debug methods and flags
- Configuration validation

## Key Files for Reference

List files containing important information:

- README locations
- Config file examples
- Documentation files
- Script files

</output_structure>

<instructions>

- MUST use web search to find actual documentation URLs
- MUST keep content concise and actionable
- MUST focus on END-USER assistance, not development
- SHOULD verify claims with tools before stating them
- SHOULD use parallel tool calls when gathering information
- MUST NOT include internal development workflows
- MUST NOT include contributor/development instructions
- MUST NOT invent or guess documentation URLs

</instructions>

<quality_checklist>

- [ ] Web search performed for official docs
- [ ] All documentation URLs are real and verified
- [ ] Directory structure focuses on user-facing files
- [ ] Installation commands are accurate
- [ ] Troubleshooting section includes log locations
- [ ] Content is concise (LLM reference, not user docs)
- [ ] No development/contributing instructions included

</quality_checklist>
