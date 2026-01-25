---
name: writing
description: |-
  Handle structured co-authoring of professional documentation. Use for proposals, technical specs, and RFCs. Use proactively when a collaborative drafting process (Gathering -> Refinement -> Testing) is needed.
  
  Examples:
  - user: "Draft a technical RFC for the new API" -> follow Stage 1 context gathering
  - user: "Refine the introduction of this proposal" -> use iterative surgical edits
  - user: "Test if this document is clear for readers" -> run reader testing workflow
---
<instructions>
<professional_coauthoring_workflow>

<stage_1_context_gathering>
1. Ask for meta-context (type, audience, impact, constraints).
2. Encourage a context dump (background, discussions, stakeholders).
3. Ask 5-10 clarifying questions to close the gap.
</stage_1_context_gathering>

<stage_2_refinement_structure>
1. Create initial document structure with placeholders.
2. For each section:
   - Ask clarifying questions.
   - Brainstorm 5-20 options.
   - Curation (User selects/combines).
   - Draft the section using surgical edits.
   - Iteratively refine based on feedback.
</stage_2_refinement_structure>

<stage_3_reader_testing>
1. Predict reader questions.
2. Invoke sub-agents (Reader Claude) with just the doc and questions.
3. Check for ambiguity, false assumptions, or contradictions.
4. Report findings and fix gaps.
</stage_3_reader_testing>

<guidance_tips>
- **Tone**: Direct and procedural.
- **Artifacts**: Use `create_file` for sections, `str_replace` for edits.
- **Quality over Speed**: Each iteration MUST make meaningful improvements.
</guidance_tips>

</professional_coauthoring_workflow>
</instructions>
