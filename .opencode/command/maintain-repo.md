---
description: Run full repository maintenance (audit + sync)
agent: repo-maintainer
---

Perform a full maintenance cycle.

1. Run the audit:
   `!python3 .opencode/skill/repo-maintenance/scripts/audit_repo.py`

2. If successful, run the documentation sync:
   `!python3 .opencode/skill/repo-maintenance/scripts/sync_docs.py`
