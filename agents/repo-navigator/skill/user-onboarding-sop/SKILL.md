---
name: user-onboarding-sop
description: |-
  Generate AGENTS.md for end-user assistance. Covers setup, installation, running, and troubleshooting. Use proactively when user asks for "getting started" help or during /init user workflow.

  Examples:
  - user: "/init user" → user assistance AGENTS.md with official docs
  - user: "Create getting started guide" → installation + setup + troubleshooting
  - user: "Document how to use this repo" → user-focused AGENTS.md
  - user: "Help users run this software" → setup, prerequisites, usage patterns
---

# User Onboarding SOP

This SOP COMPLEMENTS the `/init user` command by providing end-user assistance mapping for AGENTS.md files.

**CRITICAL**: This is for END-USER assistance ONLY.

<workflow>
## Phase 1: Resource Discovery
1. **Official Docs**: The agent MUST use web search for real documentation URLs. Identify Getting Started, API Ref, and Troubleshooting links.
2. **Setup**: Identify Prerequisites, Installation commands, and Environment Variables.
3. **Usage**: Identify CLI entry points, primary commands, and common usage patterns.

## Phase 2: AGENTS.md Composition
Target a relaxed output length of ~100 lines. Focus on helping the agent assist the end-user with installation and operation.

### 1. Resources & Documentation
- List verified documentation URLs (MUST NOT invent).
- Link to troubleshooting and community guides.

### 2. Setup & Installation
- Document prerequisites and copy-pasteable install commands.
- Focus heavily on what the user needs to get the software running in their environment.

### 3. Usage & Running
- Document primary launch commands and CLI flags.
- Map key directory structure (ONLY files/dirs users interact with for setup/usage).
</workflow>

<instructions>
- The agent MUST use web search to find actual documentation URLs.
- Output length of ~100 lines is STRONGLY RECOMMENDED.
- The agent MUST NOT include coding patterns, internal conventions, or development instructions.
- The agent MUST use RFC 2119 keywords (MUST, SHOULD, STRONGLY RECOMMENDED).
- The agent MUST focus on practical info for assisting users (Setup, Usage, Troubleshooting).
- The agent MUST NOT repeat environment metadata or standard tool instructions.
</instructions>
