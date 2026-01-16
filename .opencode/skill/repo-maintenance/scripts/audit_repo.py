#!/usr/bin/env python3
"""
Repository Audit Script

Validates:
1. YAML frontmatter parsing
2. Agent description patterns (primary: 3 words, others: comprehensive with examples)
3. Command description patterns (concise, 3-5 words)
4. Skill description patterns (comprehensive with "Use for/when" + examples)
5. RFC+XML compliance in markdown files
6. Mode enum validation
"""
import re
import sys
from pathlib import Path


def walk_all(root):
    """Walk directory tree including hidden folders."""
    for item in root.iterdir():
        yield item
        if item.is_dir() and '.git' not in str(item):
            yield from walk_all(item)


def parse_frontmatter(content):
    """Extract YAML frontmatter from markdown content."""
    match = re.match(r'^---\n(.*?)\n---', content, re.DOTALL)
    if not match:
        return None, "Missing or malformed YAML frontmatter (no --- delimiters)"
    
    yaml_text = match.group(1)
    return {'_raw': yaml_text}, None


def get_field(parsed, field):
    """Get a field from parsed YAML using regex."""
    if parsed is None or '_raw' not in parsed:
        return None
    
    raw = parsed['_raw']
    
    # Handle multi-line (|-) values
    # match field followed by |- then capture all indented lines
    multiline_match = re.search(rf'^{field}:\s*\|-.*?\n((?:(?:[ \t]+.*\n?)|(?:\n))*)', raw, re.MULTILINE)
    if multiline_match:
        lines = multiline_match.group(1).split('\n')
        # Strip common leading whitespace
        if lines:
            non_empty_lines = [line for line in lines if line.strip()]
            if not non_empty_lines:
                return ""
            min_indent = min(len(line) - len(line.lstrip()) for line in non_empty_lines)
            cleaned = '\n'.join(line[min_indent:] if line.strip() else line for line in lines)
            return cleaned.strip()
    
    # Handle single-line values
    match = re.search(rf'^{field}:\s*(.+)$', raw, re.MULTILINE)
    if match:
        value = match.group(1).strip()
        # Remove quotes if present
        if value.startswith(('"', "'")) and value.endswith(value[0]):
            value = value[1:-1]
        return value
    
    return None


def count_words(text):
    """Count words in a string, handling punctuation."""
    if not text:
        return 0
    # Get first line only for word count (descriptions may have examples on subsequent lines)
    first_line = text.split('\n')[0] if '\n' in text else text
    # Remove common punctuation
    cleaned = re.sub(r'[.,!?;:]', '', first_line)
    return len(cleaned.split())


def has_xml_tags(content):
    """Check if content has XML tags (excluding code blocks)."""
    # Remove code blocks first
    no_code = re.sub(r'```.*?```', '', content, flags=re.DOTALL)
    no_inline = re.sub(r'`[^`]+`', '', no_code)
    
    # Look for XML-style tags (common ones used in prompts)
    expected_tags = ['role', 'instructions', 'workflow', 'constraints', 'examples', 
                     'context', 'reference', 'rules', 'guidelines', 'format',
                     'core_approach', 'overview', 'checklist', 'best_practices']
    
    for tag in expected_tags:
        if re.search(rf'<{tag}[^>]*>.*?</{tag}>', no_inline, re.DOTALL | re.IGNORECASE):
            return True
    
    return False


def has_rfc_keywords(content):
    """Check if content uses RFC 2119 keywords (uppercase)."""
    # Remove code blocks
    no_code = re.sub(r'```.*?```', '', content, flags=re.DOTALL)
    
    rfc_keywords = ['MUST', 'MUST NOT', 'SHALL', 'SHALL NOT', 'SHOULD', 
                    'SHOULD NOT', 'REQUIRED', 'RECOMMENDED', 'MAY', 'OPTIONAL']
    
    for keyword in rfc_keywords:
        # Must be uppercase and word-bounded
        if re.search(rf'\b{keyword}\b', no_code):
            return True
    return False


def validate_agent(file_path, content, parsed):
    """Validate an agent file per agent-architect skill patterns."""
    issues = []
    warnings = []
    
    description = get_field(parsed, 'description')
    mode = get_field(parsed, 'mode')
    
    if not description:
        issues.append("Missing 'description' field")
        return issues, warnings
    
    is_primary = mode == 'primary'
    
    if is_primary:
        # Primary agents: PRECISELY 3 words
        word_count = count_words(description)
        if word_count != 3:
            desc_preview = description[:50] + "..." if len(description) > 50 else description
            issues.append(
                f"Primary agent description MUST be exactly 3 words, got {word_count}: \"{desc_preview}\""
            )
    else:
        # Non-primary agents: need comprehensive description
        # Pattern: [Role/Action]. Use when [triggers]. Examples: - user: "trigger" → action
        
        # Check for literal block scalar usage if multiline
        if '\n' in description and '|-' not in parsed.get('_raw', ''):
            warnings.append("Multiline description SHOULD use '|-' literal block scalar")

        desc_lower = description.lower()
        
        has_use_when = 'use when' in desc_lower or 'use for' in desc_lower
        has_examples = '→' in description or '->' in description or 'example' in desc_lower
        
        # Count examples (user: "..." → pattern)
        example_count = len(re.findall(r'user:\s*["\'].+?["\']\s*(?:→|->)', description, re.IGNORECASE))
        
        if not has_use_when:
            warnings.append(
                "Non-primary agent SHOULD include 'Use when...' trigger contexts"
            )
        
        if example_count < 2:
            warnings.append(
                f"Non-primary agent SHOULD include trigger examples (user: \"...\" → action) (found {example_count})"
            )
    
    # Mode validation
    if mode and mode not in {'primary', 'all', 'subagent'}:
        issues.append(f"Invalid mode '{mode}'. Allowed: primary, all, subagent")
    
    # RFC+XML compliance
    body = content.split('---', 2)[-1] if content.count('---') >= 2 else content
    
    if not has_xml_tags(body):
        warnings.append("Missing XML tags (expected: <role>, <instructions>, <workflow>, etc.)")
    
    if not has_rfc_keywords(body):
        warnings.append("Missing RFC 2119 keywords (expected: MUST, SHOULD, MAY, etc.)")
    
    return issues, warnings


def validate_command(file_path, content, parsed):
    """Validate a command file per command-creator skill patterns."""
    issues = []
    warnings = []
    
    description = get_field(parsed, 'description')
    
    if not description:
        issues.append("Missing 'description' field")
        return issues, warnings
    
    # Check for literal block scalar usage if multiline
    if '\n' in description and '|-' not in parsed.get('_raw', ''):
        warnings.append("Multiline description SHOULD use '|-' literal block scalar")

    # Commands: concise descriptions (3-5 words, shown in /help)
    word_count = count_words(description)
    if word_count > 7:
        warnings.append(
            f"Command description SHOULD be concise (3-5 words), got {word_count}"
        )
    
    return issues, warnings


def validate_skill(file_path, content, parsed):
    """Validate a skill file per skill-creator patterns."""
    issues = []
    warnings = []
    
    name = get_field(parsed, 'name')
    description = get_field(parsed, 'description')
    
    if not name:
        issues.append("Missing 'name' field")
    
    if not description:
        issues.append("Missing 'description' field")
        return issues, warnings
    
    # Check for literal block scalar usage if multiline
    if '\n' in description and '|-' not in parsed.get('_raw', ''):
        issues.append("Skill description MUST use '|-' literal block scalar for multiline content")

    # Skills need comprehensive descriptions per skill-creator:
    # - Action verb/capabilities
    # - "Use for [specific cases]" or "Use proactively when [contexts]"
    # - 3-5 examples in format: user: "..." → action
    
    desc_lower = description.lower()
    
    has_use_clause = ('use for' in desc_lower or 'use when' in desc_lower or 
                      'use proactively' in desc_lower)
    
    # Count examples (user: "..." → pattern)
    example_count = len(re.findall(r'user:\s*.+?\s*(?:→|->)', description, re.IGNORECASE))
    # print(f"DEBUG: {file_path} example_count={example_count}")
    
    if not has_use_clause:
        warnings.append(
            "Skill description SHOULD include 'Use for...' or 'Use proactively when...' triggers"
        )
    
    if example_count < 2:
        warnings.append(
            f"Skill description SHOULD include 3-5 examples (found {example_count})"
        )
    
    # Check directory name matches name field
    dir_name = file_path.parent.name
    if name and name != dir_name:
        warnings.append(
            f"Skill name '{name}' doesn't match directory name '{dir_name}'"
        )
    
    # RFC+XML compliance for skill body
    body = content.split('---', 2)[-1] if content.count('---') >= 2 else content
    
    if not has_xml_tags(body):
        warnings.append("Missing XML tags in body")
    
    return issues, warnings



def audit_file(file_path, file_type):
    """Audit a single file."""
    issues = []
    warnings = []
    
    try:
        content = file_path.read_text(encoding='utf-8')
    except Exception as e:
        return [f"Error reading file: {e}"], []
    
    # Parse frontmatter
    parsed, parse_error = parse_frontmatter(content)
    if parse_error:
        issues.append(parse_error)
        return issues, warnings
    
    # Type-specific validation
    if file_type == 'agent':
        type_issues, type_warnings = validate_agent(file_path, content, parsed)
    elif file_type == 'command':
        type_issues, type_warnings = validate_command(file_path, content, parsed)
    elif file_type == 'skill':
        type_issues, type_warnings = validate_skill(file_path, content, parsed)
    else:
        type_issues, type_warnings = [], []
    
    issues.extend(type_issues)
    warnings.extend(type_warnings)
    
    return issues, warnings


def classify_file(path_str):
    """Classify a file as agent, command, skill, or None."""
    if '.opencode/agent/' in path_str and path_str.endswith('.md'):
        return 'agent'
    elif '.opencode/command/' in path_str and path_str.endswith('.md'):
        return 'command'
    elif '/skill/' in path_str and path_str.endswith('SKILL.md'):
        return 'skill'
    return None


def get_skill_hint(path_str):
    """Determine the relevant skill hint based on the path."""
    if '.opencode/agent/' in path_str:
        return "Hint: Load 'agent-architect' skill before fixing."
    elif '.opencode/command/' in path_str:
        return "Hint: Load 'command-creator' skill before fixing."
    elif '/skill/' in path_str:
        return "Hint: Load 'skill-creator' skill before fixing."
    return None


def main():
    root = Path('.')
    report = {'errors': {}, 'warnings': {}}
    stats = {'agents': 0, 'commands': 0, 'skills': 0, 'errors': 0, 'warnings': 0}
    
    # Structural check
    if not (root / '.opencode').exists():
        report['errors']['ROOT'] = ["Missing root .opencode/ directory"]
        stats['errors'] += 1
    
    # Scan all files
    for path in walk_all(root):
        if not path.is_file():
            continue
        
        path_str = str(path)
        
        # Skip non-relevant paths
        if '.git/' in path_str or 'node_modules/' in path_str:
            continue
        
        file_type = classify_file(path_str)
        if not file_type:
            continue
        
        # Count by type
        if file_type == 'agent':
            stats['agents'] += 1
        elif file_type == 'command':
            stats['commands'] += 1
        elif file_type == 'skill':
            stats['skills'] += 1
        
        # Audit the file
        issues, warnings = audit_file(path, file_type)
        
        if issues:
            report['errors'][path_str] = issues
            stats['errors'] += len(issues)
        
        if warnings:
            report['warnings'][path_str] = warnings
            stats['warnings'] += len(warnings)
    
    # Print report
    print("=" * 60)
    print("REPOSITORY AUDIT REPORT")
    print("=" * 60)
    print(f"\nScanned: {stats['agents']} agents, {stats['commands']} commands, {stats['skills']} skills")
    
    if report['errors']:
        print(f"\n❌ ERRORS ({stats['errors']}):")
        print("-" * 40)
        for path, issues in sorted(report['errors'].items()):
            print(f"\n{path}:")
            hint = get_skill_hint(path)
            if hint:
                print(f"  💡 {hint}")
            for issue in issues:
                print(f"  ✗ {issue}")
    
    if report['warnings']:
        print(f"\n⚠️  WARNINGS ({stats['warnings']}):")
        print("-" * 40)
        for path, warnings_list in sorted(report['warnings'].items()):
            print(f"\n{path}:")
            hint = get_skill_hint(path)
            if hint:
                print(f"  💡 {hint}")
            for warning in warnings_list:
                print(f"  ⚠ {warning}")
    
    print("\n" + "=" * 60)
    
    if report['errors']:
        print(f"FAILED: {stats['errors']} error(s) found")
        sys.exit(1)
    elif report['warnings']:
        print(f"PASSED with {stats['warnings']} warning(s)")
        sys.exit(0)
    else:
        print("PASSED: No issues found")
        sys.exit(0)


if __name__ == "__main__":
    main()
