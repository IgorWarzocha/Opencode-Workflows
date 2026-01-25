# Opencode Cowork Pack

A comprehensive suite of agents and skills for autonomous "Office Coworker" tasks, featuring an integrated professional **Vault**.

## 🚀 Quick Start
Invoke the orchestrator using the slash command:
```
/cowork Create a research brief on [Topic], save the research to the vault and draft a memo.
```

## 📂 Structure
- **Manager Agent**: `CoworkOrchestrator` (Entry point). The "Chief of Staff" who manages the specialists and the **Vault**.
- **Specialist Agents**: `DocumentSpecialist`, `DataAnalyst`, `PresentationExpert`.
- **The Vault**: A structured repository (`vault/`) for professional identity, research, active projects, and long-term learning.

## 🏛 The Vault System
Borrowed from elite organizational patterns, the vault keeps your work coherent:
1. `01-Core-Identity/`: Master CVs, Bios, and Professional Standards.
2. `02-Active-Work/`: Chronological project storage (`YYYY-MM/`).
3. `03-Research-Intel/`: Market research and intelligence.
4. `05-Output-Staging/`: Verified artifacts ready for export.
5. `06-Archive/`: Historical records.

`LESSONS-LEARNED.md` lives at the root of `cowork/`.

## 🛠 Features
- **Visual Verification**: Automated layout and formatting inspection using image rendering.
- **Hierarchical Delegation**: The orchestrator breaks complex tasks into "Work Orders" for specialists.
- **Iterative Learning**: The AI evolves its style based on past lessons stored in the vault.

## 📦 Installation
To use this pack in your project:
```bash
cp -r cowork/.opencode .
cp -r cowork/vault .
```

To install agents globally:
```bash
cp cowork/.opencode/agent/* ~/.config/opencode/agent/
```
