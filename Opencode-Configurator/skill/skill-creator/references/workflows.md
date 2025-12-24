# Workflow Patterns

## Sequential Workflows

List steps at the start of SKILL.md:

```markdown
PDF form filling:
1. Analyze form → run `analyze_form.py`
2. Map fields → edit `fields.json`
3. Validate → run `validate_fields.py`
4. Fill → run `fill_form.py`
5. Verify → run `verify_output.py`
```

## Conditional Workflows

Use decision trees:

```markdown
1. Determine type:
   - **Creating?** → See "Creation workflow"
   - **Editing?** → See "Editing workflow"

2. Creation workflow: [steps]
3. Editing workflow: [steps]
```
