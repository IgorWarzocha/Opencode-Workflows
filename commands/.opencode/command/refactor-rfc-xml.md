---
description: Apply RFC 2119 + XML standards
---

Refactor all markdown files in the specified folder into RFC 2119 + XML compliant format.

<folder_path>$1</folder_path>

<style_guide>
@RFC-XML-STYLE-GUIDE.md
</style_guide>

<workflow>
1. List all `.md` files in the folder (non-recursive unless folder is small).

2. For each file, analyze and refactor:
   - Read the file content
   - Identify sections that map to XML tags (instructions, workflows, examples, etc.)
   - Identify requirement-level language that should use RFC keywords
   - Note the file type (agent, skill, command, or general documentation)
   - Apply the transformation rules below
   - Write the refactored file back to the same path

3. Report summary of changes made to each file.
</workflow>

<transformation_rules>

## Apply XML Tags
- Wrap logical sections in appropriate tags from the style guide
- Use consistent tag naming throughout
- Nest tags for hierarchical content (max 3-4 levels)
- MUST NOT break existing YAML frontmatter

## Apply RFC 2119 Keywords
- Convert "must/have to/need to" → MUST (if truly required)
- Convert "should/ought to" → SHOULD (if strongly recommended)
- Convert "can/may/might" → MAY (if truly optional)
- Convert "must not/cannot" → MUST NOT (if prohibited)
- Convert "should not" → SHOULD NOT (if discouraged)
- Use lowercase for non-normative casual language

## NO RFC Boilerplate
MUST NOT add any RFC 2119 preamble or boilerplate text. Models already know what RFC keywords mean. Adding a preamble wastes tokens and clutters the file.

## Preserve
- YAML frontmatter exactly as-is
- Code blocks and their content
- Existing links and references
- The file's original intent and meaning

</transformation_rules>

<critical_non_goal>
## RFC/XML is for STRUCTURE, not COMMUNICATION

The RFC 2119 keywords and XML tags are for structuring agent prompts, 
skill definitions, and internal documentation ONLY.

NEVER modify files such that agents would:
- Speak to users using RFC keywords ("You MUST provide a file path")
- Output XML tags in their responses to users
- Adopt a formal/robotic communication style

The refactored files should make agents BEHAVE correctly, not SPEAK formally.

✓ CORRECT (internal instruction): "The agent MUST verify file exists before editing"
✗ WRONG (user-facing output): "I MUST inform you that the file does not exist"

✓ CORRECT (internal structure): "<workflow>1. Check permissions 2. Edit file</workflow>"
✗ WRONG (user-facing output): "<response>File has been edited</response>"
</critical_non_goal>

<quality_checklist>
- [ ] XML is well-formed (proper nesting, all tags closed)
- [ ] RFC keywords used appropriately (not overused)
- [ ] Frontmatter preserved in all files
- [ ] Files remain readable and clear
- [ ] Tags enhance structure, don't obscure content
- [ ] NO RFC/XML leakage into agent communication style
- [ ] Agents still speak naturally to users
</quality_checklist>
