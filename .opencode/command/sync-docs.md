---
description: Report repository inventory and guide doc updates
agent: repo-maintainer
---

Run the inventory report:

`!python3 .opencode/skill/repo-maintenance/scripts/sync_docs.py`

Then run `git diff origin/master` to see what changed and determine if README or other docs need updating.
