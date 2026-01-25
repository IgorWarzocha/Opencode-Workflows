---
name: excel
description: |-
  Handle spreadsheet operations (Excel/CSV) with high-fidelity modeling, financial analysis, and visual verification. Use for budget models, data dashboards, and complex formula-heavy sheets. Use proactively when zero formula errors and professional standards are required.
  
  Examples:
  - user: "Build an LBO model" -> create Excel with banking-standard formatting
  - user: "Analyze this data and create a dashboard" -> use openpyxl + artifact_tool
  - user: "Verify formulas in this spreadsheet" -> run recalc.py to check for errors
---
<instructions>
<excel_professional_suite>

<modeling_standards>
- **Zero Formula Errors**: Models MUST have zero #REF!, #DIV/0!, or #VALUE! errors.
- **Dynamic Logic**: You MUST NOT hardcode derived values. You MUST use Excel formulas for all calculations.
- **Assumptions**: You MUST place all inputs in dedicated assumption cells.
</modeling_standards>

<professional_formatting>
- **Standards**: Specify units in headers ("Revenue ($mm)"). Format zeros as "-".
- **Color Coding**: The agent SHOULD follow the project's `branding` skill for color choices. If not defined, the agent SHOULD default to professional standards (e.g., Blue for hardcoded inputs, Black for formulas).
- **Visuals**: You SHOULD use `artifact_tool` to render sheets and verify layout. **Reference**: `references/artifact_tool_spreadsheets_api.md`.
</professional_formatting>

<technical_workflows>
### 1. Data Analysis (Pandas)
- You SHOULD use **Pandas** for heavy lifting and aggregation.
- You SHOULD convert to **Openpyxl** for final professional formatting and formula insertion.

### 2. Verification Loop (MANDATORY)
Before delivery, you MUST run the audit script:
- `python scripts/recalc.py output.xlsx`
- You MUST fix all errors identified in the resulting JSON summary.
</technical_workflows>

<citation_logic>
- **Citations**: You SHOULD cite sources for hardcoded data in cell comments.
- **Best Practices**: See `references/spreadsheet.md` for guidance on cross-sheet references and complex formula construction.
</citation_logic>

</excel_professional_suite>
</instructions>
