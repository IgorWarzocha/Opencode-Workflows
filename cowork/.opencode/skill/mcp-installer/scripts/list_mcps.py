#!/usr/bin/env python3
"""
List all MCP server documentation in the references/mcps/ directory.
Usage: python3 list_mcps.py
"""

import os
import re
from pathlib import Path
from typing import List, Dict


def extract_frontmatter(content: str) -> Dict[str, str]:
    """Extract YAML frontmatter from markdown file."""
    # Match YAML frontmatter between --- delimiters
    match = re.search(r"^---\n(.*?)\n---", content, re.DOTALL)
    if not match:
        return {}

    frontmatter = {}
    for line in match.group(1).split("\n"):
        # Skip empty lines and comments
        line = line.strip()
        if not line or line.startswith("#"):
            continue

        if ":" in line:
            key, value = line.split(":", 1)
            key = key.strip()
            value = value.strip()

            # Clean up array values like [tag1, tag2]
            if value.startswith("[") and value.endswith("]"):
                value = value[1:-1]

            frontmatter[key] = value

    return frontmatter


def list_mcps() -> List[Dict[str, str]]:
    """Scan references/mcps/ directory and extract MCP info."""
    mcps_dir = Path(__file__).parent.parent / "references" / "mcps"

    if not mcps_dir.exists():
        return []

    mcps = []
    for md_file in mcps_dir.glob("*.md"):
        content = md_file.read_text()
        frontmatter = extract_frontmatter(content)

        mcp_info = {
            "name": frontmatter.get("name", md_file.stem),
            "file": str(md_file),
            "url": frontmatter.get("url", "N/A"),
            "type": frontmatter.get("type", "unknown"),
            "auth": frontmatter.get("auth", "none"),
            "description": frontmatter.get("description", ""),
            "tags": frontmatter.get("tags", ""),
        }
        mcps.append(mcp_info)

    return sorted(mcps, key=lambda x: x["name"])


def main():
    mcps = list_mcps()

    if not mcps:
        print("No MCP servers documented yet.")
        print("\nTo add a new MCP server, create a markdown file in:")
        print(f"  {Path(__file__).parent.parent / 'references' / 'mcps' / '<name>.md'}")
        return

    print(f"Found {len(mcps)} documented MCP server(s):\n")

    for mcp in mcps:
        print(f"📦 {mcp['name']}")
        print(f"   Type: {mcp['type']}")
        print(f"   Auth: {mcp['auth']}")
        if mcp["url"] != "N/A":
            print(f"   URL: {mcp['url']}")
        if mcp["tags"]:
            print(f"   Tags: {mcp['tags']}")
        if mcp["description"]:
            print(f"   Desc: {mcp['description']}")
        print()


if __name__ == "__main__":
    main()
