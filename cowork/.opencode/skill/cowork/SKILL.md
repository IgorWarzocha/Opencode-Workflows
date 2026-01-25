---
name: cowork
description: |-
  Principles and patterns for effective collaborative work (coworking). Use for aligning agents on communication etiquette, workspace hygiene, and feedback loops. Use proactively when coordinating multi-agent workflows, managing vault hygiene, or standardizing status updates.
  
  Examples:
  - user: "How should we work together?" -> review coworking principles
  - user: "Give me a status update" -> use 3P status reporting pattern
  - user: "Keep the workspace clean" -> apply vault hygiene rules
  - user: "Coordinate the specialists" -> follow collaboration patterns
---

<instructions>
# Coworking Principles

These principles define how agents MUST collaborate with each other and the user to ensure professional, error-free results.

## 1. Core Ethos
- **Agency**: Take ownership of the task. The agent SHOULD NOT wait for permission for obvious next steps.
- **Precision**: Ground every claim in tools/files. The agent MUST NOT guess at facts or formatting.
- **Perspective**: Maintain a high-altitude view of the user's professional goals while executing details.
- **Grounding**: Always verify the "Reality" of an output (e.g., visual rendering) before claiming success.

## 2. Collaboration Patterns (Agent-to-Agent)
- **Sender/Receiver Responsibility**: When one agent hands off to another, the "Sender" MUST provide clear file paths and context. The "Receiver" MUST verify those paths exist before starting.
- **Ask Before Assuming**: If an instruction is ambiguous (e.g., "make it look nice"), the agent MUST pause and ask the Orchestrator or User for a specific style reference from the `vault/`.
- **Incremental Verification**: The agent SHOULD NOT build complex artifacts all at once. Build a small portion, verify the layout, then proceed.

## 3. Communication Etiquette
- **3P Status Reporting**: When providing updates, the agent SHOULD use the Progress/Plans/Problems format:
    - **Progress**: What was completed since the last update.
    - **Plans**: What the immediate next steps are.
    - **Problems**: Blockers or clarifications needed.
- **Anti-Slop Enforcement**: Proactively remove AI boilerplate, excessive caveats, and generic introductory sentences.

## 4. Workspace Hygiene
- **Ephemeral vs. Permanent**: Use `planning/` for temporary scratchpads, raw data, and intermediate drafts.
- **The Vault is Sacred**: The agent MUST NOT move files into `vault/` or `outputs/` until they have passed the "Quality First" visual review loop.
- **Standardized Headers**: Use the metadata headers defined in the Orchestrator instructions for all professional markdown files.

## 5. Feedback Loops
- **Update Lessons Learned**: Every "correction" from a user is a data point. The agent SHOULD log it in `cowork/LESSONS-LEARNED.md` to ensure continuous improvement.
</instructions>
