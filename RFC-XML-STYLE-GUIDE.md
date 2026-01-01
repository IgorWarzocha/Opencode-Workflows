# RFC + XML Style Guide Research

This document consolidates research on RFC 2119 keywords and XML tag usage for restructuring Opencode Workflows documentation. It will serve as the authoritative reference for the overhaul.

---

## Part 1: RFC 2119 Requirement Level Keywords

### Source
**RFC 2119**: "Key words for use in RFCs to Indicate Requirement Levels" (March 1997, BCP 14)  
Updated by RFC 8174.

### Boilerplate Statement

Every document using these keywords SHOULD include this statement near the beginning:

> The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119.

### Keyword Definitions

| Keyword | Synonyms | Meaning |
|---------|----------|---------|
| **MUST** | REQUIRED, SHALL | Absolute requirement. No exceptions. |
| **MUST NOT** | SHALL NOT | Absolute prohibition. No exceptions. |
| **SHOULD** | RECOMMENDED | Strong preference, but valid reasons may exist to deviate. Full implications MUST be understood before deviating. |
| **SHOULD NOT** | NOT RECOMMENDED | Strong preference against, but behavior MAY be acceptable in particular circumstances. Weigh carefully. |
| **MAY** | OPTIONAL | Truly optional. Implementations MUST interoperate whether or not the option is present. |

### Detailed Semantics

#### MUST / REQUIRED / SHALL
- **Definition**: The item is an absolute requirement of the specification.
- **When to use**: For behaviors essential to interoperability or safety.
- **Example**: "Agents MUST include a `description` field in frontmatter."

#### MUST NOT / SHALL NOT
- **Definition**: The item is an absolute prohibition of the specification.
- **When to use**: For behaviors that would cause harm or break compatibility.
- **Example**: "Commands MUST NOT execute shell commands without user approval."

#### SHOULD / RECOMMENDED
- **Definition**: Valid reasons MAY exist to ignore this requirement in particular circumstances.
- **When to use**: For best practices where exceptions are sometimes justified.
- **Caveat**: The full implications MUST be understood and carefully weighed before choosing a different course.
- **Example**: "Skills SHOULD keep SKILL.md under 500 lines."

#### SHOULD NOT / NOT RECOMMENDED
- **Definition**: Valid reasons MAY exist where the behavior is acceptable or useful.
- **When to use**: For practices that are generally discouraged but not forbidden.
- **Caveat**: The full implications SHOULD be understood before implementing.
- **Example**: "Agents SHOULD NOT use first person in system prompts."

#### MAY / OPTIONAL
- **Definition**: The item is truly optional.
- **When to use**: For features that some implementations will include and others will not.
- **Interoperability**: An implementation without the option MUST still work with one that has it.
- **Example**: "Commands MAY specify a custom model via the `model` frontmatter field."

### Usage Guidelines (from RFC 2119)

<guidelines>
1. **Use sparingly**: These imperatives MUST only be used where actually required for interoperation or to limit harmful behavior.

2. **Don't force methods**: Keywords MUST NOT be used to impose a particular method when it's not required for interoperability.

3. **Security implications**: Authors SHOULD elaborate on security implications of not following MUST/SHOULD requirements.

4. **Capitalization**: Keywords are typically CAPITALIZED to signal RFC 2119 meaning.
</guidelines>

### Strength Hierarchy

```
MUST > SHOULD > MAY
  │       │       │
  │       │       └── "You can if you want"
  │       └────────── "You should, unless you have good reason not to"
  └────────────────── "You have to, no exceptions"
```

### Non-Normative Alternatives

When you want to use similar words WITHOUT RFC 2119 meaning, use lowercase or alternatives:

| Normative (RFC 2119) | Non-Normative Alternative |
|---------------------|---------------------------|
| MUST | need to, have to, will |
| SHOULD | ought to, is expected to, is preferable |
| MAY | can, might, is allowed to |

---

## Part 2: XML Tags for LLM Prompts

### Source
- Claude/Anthropic official documentation
- W3C XML 1.0/1.1 specifications
- Industry best practices

### Why Use XML Tags?

<benefits>
1. **Clarity**: Clearly separate different parts of prompts and documents.
2. **Accuracy**: Reduce errors from misinterpreting sections.
3. **Flexibility**: Easily find, add, remove, or modify parts without rewriting.
4. **Parseability**: Post-processing can extract specific sections programmatically.
5. **Model-Agnostic**: XML structure works across all LLM providers.
</benefits>

### Core XML Syntax Rules

| Rule | Description | Example |
|------|-------------|---------|
| Case Sensitive | Tags MUST match case exactly | `<Tag>` ≠ `<tag>` |
| Must Close | All elements MUST have closing tags | `<tag>content</tag>` |
| Proper Nesting | Tags MUST close in LIFO order | `<a><b></b></a>` ✓ |
| Reserved Characters | `<`, `>`, `&` MUST be escaped | `&lt;`, `&gt;`, `&amp;` |
| Attributes | Use quotes for attribute values | `<tag attr="value">` |

### Empty Element Syntax

```xml
<!-- Both valid -->
<empty></empty>
<empty/>
```

### Recommended Tags for LLM Prompts

<tag_catalog>

#### Structural Tags
| Tag | Purpose | When to Use |
|-----|---------|-------------|
| `<instructions>` | Core behavioral rules | Always—primary directive section |
| `<context>` | Background information | When agent needs domain knowledge |
| `<constraints>` | Limitations and boundaries | For safety/scope restrictions |
| `<workflow>` | Step-by-step process | For multi-step procedures |

#### Content Tags
| Tag | Purpose | When to Use |
|-----|---------|-------------|
| `<examples>` | Container for demonstrations | For few-shot learning |
| `<example>` | Single demonstration | Inside `<examples>` |
| `<input>` | Example input | Inside `<example>` |
| `<output>` | Expected output | Inside `<example>` |

#### Reasoning Tags
| Tag | Purpose | When to Use |
|-----|---------|-------------|
| `<thinking>` | Chain-of-thought reasoning | For complex analysis tasks |
| `<analysis>` | Structured examination | For breaking down problems |
| `<findings>` | Discovered issues/insights | For review/audit tasks |
| `<recommendations>` | Actionable suggestions | For advisory outputs |

#### Data Tags
| Tag | Purpose | When to Use |
|-----|---------|-------------|
| `<data>` | Raw data to process | For data analysis tasks |
| `<code>` | Code snippets | For programming context |
| `<document>` | Long-form text | For document analysis |
| `<reference>` | Cited material | For grounded responses |

#### Control Tags
| Tag | Purpose | When to Use |
|-----|---------|-------------|
| `<format>` | Output format specification | For structured outputs |
| `<formatting_example>` | Template to follow | For format demonstration |
| `<guidelines>` | Soft rules and preferences | For style guidance |
| `<rules>` | Hard rules and requirements | For strict constraints |

</tag_catalog>

### XML Tag Best Practices

<best_practices>

#### 1. Consistency
- Use the same tag names throughout your prompts
- Reference tags explicitly in instructions: "Using the data in `<context>` tags..."

#### 2. Nesting
- Use nested tags for hierarchical content
- Keep nesting depth reasonable (3-4 levels max)

```xml
<examples>
  <example>
    <input>User request</input>
    <output>Expected response</output>
  </example>
</examples>
```

#### 3. Naming Conventions
- Use lowercase with hyphens: `<my-tag>` or underscores: `<my_tag>`
- Make names self-descriptive
- Avoid abbreviations unless universally understood

#### 4. Combining Techniques
- Pair XML with RFC keywords: `<instructions>The agent MUST...</instructions>`
- Use with multishot prompting: wrap examples in `<examples>`
- Use with chain-of-thought: wrap reasoning in `<thinking>`

</best_practices>

### Before/After Comparison

<comparison>

#### Without XML Tags (Problematic)
```
You're a code reviewer. Analyze this code for bugs.
Focus on security issues. Here's an example of good 
feedback: "The null check is missing on line 5."
Use this data: [code here]. Be concise.
```
**Problems**: Boundaries unclear, example mixed with instructions, data ambiguous.

#### With XML Tags (Clear)
```xml
<role>You are a senior code reviewer specializing in security.</role>

<instructions>
1. Analyze the code in <code> tags for security vulnerabilities
2. Report issues in <findings> tags
3. Provide fixes in <recommendations> tags
</instructions>

<code>
[code here]
</code>

<examples>
  <example>
    <input>Unchecked user input</input>
    <output><findings>SQL injection vulnerability at line 5</findings></output>
  </example>
</examples>

<format>Be concise. Use bullet points.</format>
```

</comparison>

---

## Part 3: Combined RFC + XML Structure for Opencode Files

### Proposed Document Template

```xml
<preamble>
The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", 
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this 
document are to be interpreted as described in RFC 2119.
</preamble>

<role>
You are [expert persona]. Your objective is [goal].
</role>

<instructions>
- Agents MUST [absolute requirement]
- Agents SHOULD [strong recommendation]
- Agents MAY [optional behavior]
- Agents MUST NOT [absolute prohibition]
</instructions>

<workflow>
1. First, [step]
2. Then, [step]
3. Finally, [step]
</workflow>

<constraints>
- MUST NOT exceed [limit]
- SHOULD NOT [discouraged behavior]
</constraints>

<examples>
<example>
<input>[user request]</input>
<output>[expected response]</output>
</example>
</examples>

<format>
Output MUST be formatted as [structure].
</format>
```

### Applying to Opencode File Types

#### Agents (`.md` in `.opencode/agent/`)
```yaml
---
description: [trigger description]. Use when [contexts].
mode: primary | subagent | all
---
```
```xml
<role>
You are [persona]. You specialize in [domain].
</role>

<instructions>
- You MUST [requirement]
- You SHOULD [recommendation]
- You MAY [option]
- You MUST NOT [prohibition]
</instructions>

<workflow>
[numbered steps]
</workflow>
```

#### Skills (`SKILL.md`)
```yaml
---
name: skill-name
description: [comprehensive trigger description]
---
```
```xml
<overview>
Brief description of capability.
</overview>

<workflow>
<phase name="understand">
[steps]
</phase>
<phase name="execute">
[steps]
</phase>
</workflow>

<rules>
- Skill MUST [requirement]
- Skill SHOULD [recommendation]
</rules>
```

#### Commands (`.md` in `.opencode/command/`)
```yaml
---
description: [what command does]
agent: build | plan
---
```
```xml
<instructions>
1. [Step with RFC keywords]
2. The agent MUST [requirement]
3. The agent SHOULD [recommendation]
</instructions>
```

---

## Part 4: Migration Checklist

<checklist>

### For Each File
- [ ] Add RFC 2119 boilerplate if using keywords
- [ ] Wrap major sections in appropriate XML tags
- [ ] Convert vague language to RFC keywords where appropriate
- [ ] Ensure XML is well-formed (proper nesting, closing tags)
- [ ] Test readability—tags SHOULD enhance, not obscure

### Keyword Audit
- [ ] Replace "must" (lowercase) with "MUST" where it's truly required
- [ ] Replace "should" with "SHOULD" for strong recommendations
- [ ] Replace "can/may" with "MAY" for optional items
- [ ] Use non-normative alternatives for casual usage

### Tag Audit
- [ ] Consistent tag naming across all files
- [ ] Tags referenced in instructions match actual tag names
- [ ] Nesting is logical and not too deep
- [ ] Empty tags use self-closing syntax

</checklist>

---

## Part 5: Quick Reference Card

### RFC 2119 At a Glance

| Level | Keywords | Meaning |
|-------|----------|---------|
| Mandatory | MUST, REQUIRED, SHALL | Absolute requirement |
| Forbidden | MUST NOT, SHALL NOT | Absolute prohibition |
| Recommended | SHOULD, RECOMMENDED | Strong preference, exceptions allowed |
| Discouraged | SHOULD NOT, NOT RECOMMENDED | Generally avoid, exceptions allowed |
| Optional | MAY, OPTIONAL | Truly optional |

### Common XML Tags

```xml
<role>         <!-- Agent identity -->
<instructions> <!-- Core directives -->
<context>      <!-- Background info -->
<workflow>     <!-- Step-by-step process -->
<constraints>  <!-- Limitations -->
<examples>     <!-- Few-shot demos -->
<example>      <!-- Single demo -->
<input>        <!-- Example input -->
<output>       <!-- Expected output -->
<thinking>     <!-- Chain of thought -->
<findings>     <!-- Analysis results -->
<recommendations> <!-- Action items -->
<format>       <!-- Output structure -->
<rules>        <!-- Hard requirements -->
<guidelines>   <!-- Soft preferences -->
```

---

## Sources

1. RFC 2119 - https://www.rfc-editor.org/rfc/rfc2119
2. RFC 8174 (Update) - https://www.rfc-editor.org/rfc/rfc8174
3. Claude XML Documentation - https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/use-xml-tags
4. W3C XML 1.0 Specification - https://w3.org/TR/2008/REC-xml-20081126
5. OASIS Keyword Guidelines - https://www.oasis-open.org/policies-guidelines/keyword-guidelines/
