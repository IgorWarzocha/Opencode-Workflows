---
description: Explore repository structure to understand key files, patterns, and architecture
---

<arguments>
$ARGUMENTS contains optional scope: "quick", "deep", or a specific folder path.
If empty, perform a standard exploration.
</arguments>

<workflow>

1. **Analyze main directory structure**
   - Run `ls -la` to see all files and folders
   - Identify configuration files (package.json, requirements.txt, etc.)
   - Find documentation files (README.md, AGENTS.md, etc.)

2. **Map key folders**
   - Check typical directories: src/, lib/, components/, tests/, docs/
   - Identify hidden folders: .git/, .vscode/, .opencode/
   - Use `find . -type d -name "*pattern*"` for specific searches

3. **Analyze configuration**
   - Read package.json for Node.js projects
   - Check requirements.txt/pyproject.toml for Python
   - Find build and CI configuration

4. **Identify patterns**
   - Locate main entry files (index.js, main.py, etc.)
   - Find test files and structure
   - Map module/dependency relationships

5. **Summarize architecture**
   - Describe technologies and frameworks
   - Identify design patterns
   - Highlight areas for deeper exploration

</workflow>

<scope_options>

| Scope | Behavior |
|-------|----------|
| quick | Main structure and config files only |
| deep | Detailed mapping of all folders |
| `path/` | Focus exploration on specific directory |

</scope_options>
