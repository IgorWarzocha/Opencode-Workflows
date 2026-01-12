#!/usr/bin/env python3
import re
import subprocess
from pathlib import Path


def get_frontmatter_field(content, field):
    """Extract a field from YAML frontmatter."""
    match = re.search(rf'^{field}:\s*(.+)$', content, re.MULTILINE)
    if match:
        value = match.group(1).strip()
        # Handle quoted strings
        if value.startswith(('"', "'")):
            value = value[1:-1] if value.endswith(value[0]) else value[1:]
        # Handle multiline (|-) by just returning first line
        if value == '|-':
            lines = content.split('\n')
            for i, line in enumerate(lines):
                if line.strip().startswith(f'{field}:'):
                    if i + 1 < len(lines):
                        return lines[i + 1].strip()
        return value
    return None


def walk_all(root):
    """Walk directory tree including hidden folders."""
    for item in root.iterdir():
        yield item
        if item.is_dir():
            yield from walk_all(item)


def scan_resources():
    """Scan for agents, commands, and skills in the repo."""
    root = Path('.')
    agents = []
    commands = []
    skills = []

    for path in walk_all(root):
        if not path.is_file():
            continue

        path_str = str(path)

        # Skip common non-relevant paths
        if '.git/' in path_str or 'node_modules/' in path_str:
            continue

        # Agents: .opencode/agent/*.md
        if path.suffix == '.md' and '/agent/' in path_str and '.opencode/agent' in path_str:
            content = path.read_text(encoding='utf-8', errors='ignore')
            desc = get_frontmatter_field(content, 'description') or 'No description'
            agents.append({'path': path_str, 'name': path.stem, 'desc': desc})

        # Commands: .opencode/command/*.md
        elif path.suffix == '.md' and '/command/' in path_str and '.opencode/command' in path_str:
            content = path.read_text(encoding='utf-8', errors='ignore')
            desc = get_frontmatter_field(content, 'description') or 'No description'
            commands.append({'path': path_str, 'name': path.stem, 'desc': desc})

        # Skills: */skill/*/SKILL.md or .opencode/skill/*/SKILL.md
        elif path.name == 'SKILL.md' and '/skill/' in path_str:
            content = path.read_text(encoding='utf-8', errors='ignore')
            name = get_frontmatter_field(content, 'name') or path.parent.name
            desc = get_frontmatter_field(content, 'description') or 'No description'
            # Truncate long descriptions
            if len(desc) > 80:
                desc = desc[:77] + '...'
            skills.append({'path': path_str, 'name': name, 'desc': desc})

    return agents, commands, skills


def get_git_diff_files():
    """Get files changed vs origin/master with their status."""
    files = {'added': [], 'modified': [], 'deleted': []}
    try:
        # Get diff with status indicators
        result = subprocess.run(
            ['git', 'diff', '--name-status', 'origin/master...HEAD'],
            capture_output=True, text=True, timeout=10
        )
        if result.returncode == 0 and result.stdout.strip():
            for line in result.stdout.strip().split('\n'):
                if '\t' in line:
                    status, filepath = line.split('\t', 1)
                    if status.startswith('A'):
                        files['added'].append(filepath)
                    elif status.startswith('M'):
                        files['modified'].append(filepath)
                    elif status.startswith('D'):
                        files['deleted'].append(filepath)

        # Also check for untracked files (new, not yet committed)
        result = subprocess.run(
            ['git', 'status', '--porcelain'],
            capture_output=True, text=True, timeout=10
        )
        if result.returncode == 0 and result.stdout.strip():
            for line in result.stdout.strip().split('\n'):
                if line.startswith('??'):
                    filepath = line[3:].strip()
                    if filepath not in files['added']:
                        files['added'].append(filepath)
                elif line.startswith('A ') or line.startswith('A'):
                    filepath = line[2:].strip() if line[1] == ' ' else line[1:].strip()
                    if filepath not in files['added']:
                        files['added'].append(filepath)

    except Exception:
        pass
    return files


def classify_resource(filepath):
    """Classify a file as agent, command, skill, or other."""
    if '.opencode/agent/' in filepath and filepath.endswith('.md'):
        return 'agent'
    elif '.opencode/command/' in filepath and filepath.endswith('.md'):
        return 'command'
    elif '/skill/' in filepath and filepath.endswith('SKILL.md'):
        return 'skill'
    return None


def get_parent_readme(filepath):
    """Get the parent directory that should have a README."""
    path = Path(filepath)
    # For agents in agents/<category>/.opencode/agent/, the category needs README
    if 'agents/' in filepath:
        parts = filepath.split('/')
        if 'agents' in parts:
            idx = parts.index('agents')
            if idx + 1 < len(parts):
                category_dir = '/'.join(parts[:idx + 2])
                return category_dir
    return None


def report_inventory(agents, commands, skills):
    """Print inventory report with actionable suggestions."""
    print("Repository Inventory Report")
    print("=" * 50)
    print(f"Agents:   {len(agents)}")
    print(f"Commands: {len(commands)}")
    print(f"Skills:   {len(skills)}")

    # Analyze git diff
    diff_files = get_git_diff_files()
    new_agents = [f for f in diff_files['added'] if classify_resource(f) == 'agent']
    new_commands = [f for f in diff_files['added'] if classify_resource(f) == 'command']
    new_skills = [f for f in diff_files['added'] if classify_resource(f) == 'skill']

    has_new_resources = new_agents or new_commands or new_skills

    if has_new_resources:
        print("\n" + "-" * 50)
        print("NEW RESOURCES DETECTED")
        print("-" * 50)

        if new_agents:
            print(f"\n🆕 New agents ({len(new_agents)}):")
            for f in new_agents:
                print(f"  + {f}")

        if new_commands:
            print(f"\n🆕 New commands ({len(new_commands)}):")
            for f in new_commands:
                print(f"  + {f}")

        if new_skills:
            print(f"\n🆕 New skills ({len(new_skills)}):")
            for f in new_skills:
                print(f"  + {f}")

        # Check which parent directories need READMEs
        readme_needed = set()
        for f in new_agents + new_commands + new_skills:
            parent = get_parent_readme(f)
            if parent:
                readme_path = Path(parent) / 'README.md'
                if not readme_path.exists():
                    readme_needed.add(parent)

        print("\n" + "-" * 50)
        print("DOCUMENTATION ACTIONS REQUIRED")
        print("-" * 50)

        if readme_needed:
            print("\n📄 These directories need a README.md:")
            for d in sorted(readme_needed):
                print(f"  → {d}/README.md")

        if new_agents or new_commands or new_skills:
            print("\n📝 Main README.md may need updating to reflect:")
            if new_agents:
                print(f"  - {len(new_agents)} new agent(s)")
            if new_commands:
                print(f"  - {len(new_commands)} new command(s)")
            if new_skills:
                print(f"  - {len(new_skills)} new skill(s)")

    # Show other changed docs
    all_changed = diff_files['added'] + diff_files['modified']
    doc_changes = [f for f in all_changed if f.endswith('.md') and classify_resource(f) is None]
    if doc_changes:
        print(f"\n📋 Other documentation changes ({len(doc_changes)}):")
        for f in doc_changes[:5]:
            print(f"  - {f}")
        if len(doc_changes) > 5:
            print(f"  ... and {len(doc_changes) - 5} more")

    print("\n" + "=" * 50)
    if has_new_resources:
        print("ACTION: Update documentation for new resources listed above.")
    else:
        print("No new agents/commands/skills detected. Documentation likely up to date.")
    print("Run `git diff origin/master` for full change details.")


def main():
    agents, commands, skills = scan_resources()
    report_inventory(agents, commands, skills)


if __name__ == "__main__":
    main()
