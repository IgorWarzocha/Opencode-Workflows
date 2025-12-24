#!/usr/bin/env python3
"""
List available plugins from the catalog.

Reads frontmatter from all plugin .md files and outputs a quick reference.
Agent uses this to find relevant plugins, then reads the full file for details.

Usage:
    python scripts/list_plugins.py
"""

import re
from pathlib import Path

FRONTMATTER_PATTERN = re.compile(r"^---\s*\n(.*?)\n---\s*\n", re.DOTALL)


def parse_frontmatter(content: str) -> dict:
    match = FRONTMATTER_PATTERN.match(content)
    if not match:
        return {}

    frontmatter = {}
    for line in match.group(1).strip().split("\n"):
        if ":" in line:
            key, value = line.split(":", 1)
            frontmatter[key.strip()] = value.strip().strip("\"'")

    return frontmatter


def main():
    script_dir = Path(__file__).parent
    plugins_dir = script_dir.parent / "references" / "plugins"

    if not plugins_dir.exists():
        print("No plugins directory found")
        return

    plugins = []
    for plugin_file in sorted(plugins_dir.glob("*.md")):
        content = plugin_file.read_text()
        fm = parse_frontmatter(content)
        if fm.get("name"):
            plugins.append((fm["name"], fm.get("description", ""), plugin_file.name))

    # Output simple list
    for name, desc, filename in sorted(plugins, key=lambda x: x[0].lower().lstrip("@")):
        print(f"{name}: {desc}")
        print(f"  -> plugins/{filename}")
        print()


if __name__ == "__main__":
    main()
