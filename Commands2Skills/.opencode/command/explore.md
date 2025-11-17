---
description: Explore repository structure in organized way to understand key files, patterns, and architecture
---

## Arguments
- $ARGUMENTS contains the user-provided argument or is empty
- If empty, determine appropriate action from context

**CRITICAL. Always execute these exact steps**

Steps
1. **Main directory structure analysis**:
   - Use `ls -la` to see all files and folders
   - Identify configuration files (package.json, requirements.txt, etc.)
   - Find documentation files (README.md, CLAUDE.md, etc.)

2. **Key folder mapping**:
   - Use `find . -type d -name "*name*"` to find important directories
   - Check typical folders: src/, lib/, components/, tests/, docs/, .config/
   - Identify hidden folders (.git, .vscode, .claude, etc.)

3. **Configuration files analysis**:
   - Read package.json (for Node.js projects)
   - Check requirements.txt/pyproject.toml (for Python projects)
   - Find build/CI configuration files

4. **Project pattern identification**:
   - Look for main entry files (index.js, main.py, etc.)
   - Find test files and folders
   - Check module/dependency structure

5. **Architecture summary**:
   - Describe technology and frameworks used
   - Identify main design patterns
   - Highlight key areas for further exploration

**Usage patterns**
- **First exploration**: Full analysis of new repository
- **Quick overview**: Only main structure and configuration files
- **Deep analysis**: Detailed mapping of selected folders

Output: Organized repository structure report with key insights