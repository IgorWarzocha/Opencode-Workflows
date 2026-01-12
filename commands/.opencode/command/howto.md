---
description: Generate exhaustive repository guide for user assistance
---

<task>
Analyze this repository and create an AGENTS.md file for assisting users with setup, running, and troubleshooting.

This is NOT for development assistance - it's for END-USER assistance only.
</task>

<workflow>

1. **Gather Repository Context**
   - Read root package.json to identify project name and type
   - Read root README.md for basic project info
   - List root directory contents to understand structure

2. **Search Official Documentation**
   - Use web search to find official documentation resources
   - Query: "[repository name] documentation" and "[repository name] getting started"
   - Look for official docs sites, README links, llms.txt files
   - Find getting started guides and API references
   - MUST gather real URLs from web search

3. **Analyze Repository Structure**
   - List IMPORTANT directories only (ignore node_modules, .git, etc.)
   - Identify key config files, documentation, scripts
   - Focus on directories/files users interact with for setup/usage
   - Maximum 2-3 levels deep for directory exploration

4. **Explore Installation Methods**
   - Check for install scripts (install, setup, etc.)
   - Look for package manager installation docs
   - Find prerequisites and environment setup instructions
   - Identify configuration files and environment variables

5. **Identify Running/Usage Patterns**
   - Find CLI commands and entry points
   - Look for start/launch scripts
   - Check for GUI/desktop app information
   - Identify common usage patterns from documentation

6. **Document Troubleshooting Resources**
   - Find log file locations
   - Identify debug methods and flags
   - Look for common issues in docs
   - Check for configuration validation methods

7. **Create AGENTS.md**
   - Write comprehensive user assistance guide
   - Use the structure specified below
   - MUST be actionable and concise (LLM reference, not user docs)
   - Focus on practical information for helping users

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
