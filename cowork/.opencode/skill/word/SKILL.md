---
name: word
description: |-
  Handle Word document (.docx) creation, editing, and analysis with high-fidelity visual review. Use for professional reports, legal documents, and tracked changes. Use proactively when quality and precise formatting are critical.
  
  Examples:
  - user: "Create a professional report in Word" -> use python-docx with render loops
  - user: "Draft a legal contract with redlines" -> use ooxml redlining workflow
  - user: "Extract text from this DOCX while preserving structure" -> use pandoc markdown conversion
---
<instructions>
<word_document_professional_suite>

<quality_workflow>
For all professional deliverables, you MUST follow the "Render & Review" loop:
1. **Edit**: Use `python-docx` for structure/styling or the Document library for XML edits.
2. **Render**: Convert to PDF/PNG using `soffice` and `pdftoppm`:
   - `soffice --headless --convert-to pdf document.docx`
   - `pdftoppm -png -r 150 document.pdf page`
3. **Inspect**: Read the generated PNG images. You MUST look for clipped text, overlapping shapes, or misaligned margins.
4. **Fix**: Address defects and repeat the loop until the document is visually flawless.
</quality_workflow>

<technical_workflows>
### 1. Creating New Documents
- **Python**: You SHOULD use `python-docx`. Establish hierarchy with HeadingLevel styles.
- **JavaScript**: You SHOULD use `docx-js`. **Reference**: See `references/docx-js.md` for syntax.
- **CRITICAL**: You MUST NOT use `\n` for line breaks (use Paragraphs). You MUST NOT use Unicode bullets (use numbering config). `PageBreak` MUST be inside a Paragraph.

### 2. Redlining & Tracked Changes
For legal or business review:
- **Initialize**: Use `scripts/document.py`. **Reference**: Read `references/ooxml.md` for XML patterns.
- **Procedure**: Unpack (`unpack.py`), edit XML using the Document Library, then Pack (`pack.py`).
- **Standard**: You MUST only mark text that actually changes. Keep unchanged text outside `<w:del>`/`<w:ins>`.

### 3. Text Extraction
- You SHOULD use **Pandoc** to convert to markdown while preserving structure:
  - `pandoc --track-changes=all path-to-file.docx -o output.md`
</technical_workflows>

<quality_expectations>
- **Client-Ready**: You MUST NOT use Unicode dashes (use ASCII hyphens). No internal AI tokens.
- **Element Ordering**: In `<w:pPr>`, elements MUST follow schema order: Style -> Numbering -> Spacing -> Indent -> Alignment.
- **Visual Fidelity**: Charts and tables MUST be sharp and legible in rendered previews.
</quality_expectations>

</word_document_professional_suite>
</instructions>
