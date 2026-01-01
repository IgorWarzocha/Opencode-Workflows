# Workflow Patterns

<sequential>

## Sequential Workflows

List numbered steps at the start of SKILL.md:

```markdown
PDF form filling:
1. Analyze form → run `analyze_form.py`
2. Map fields → edit `fields.json`
3. Validate → run `validate_fields.py`
4. Fill → run `fill_form.py`
5. Verify → run `verify_output.py`
```

- MUST number steps in execution order
- SHOULD include tool/script references for each step
- MAY include decision points between steps

</sequential>

<conditional>

## Conditional Workflows

Use decision trees for branching logic:

```markdown
1. Determine type:
   - **Creating?** → See "Creation workflow"
   - **Editing?** → See "Editing workflow"

2. Creation workflow: [steps]
3. Editing workflow: [steps]
```

- MUST define decision criteria clearly
- SHOULD group related steps under named workflows
- MAY nest conditionals (max 2 levels)

</conditional>
