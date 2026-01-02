---
description: Create an OpenCode plugin from a description
---

<instructions>

Load the `create-opencode-plugin` skill and use it to create a plugin based on the user's requirements.

## User's Plugin Idea

$ARGUMENTS

## Procedure

1. MUST follow the skill's procedure exactly - start with Step 1 (verify SDK reference)
2. MUST validate feasibility before implementing
3. SHOULD guide the user through design decisions if the idea is ambiguous
4. Create the plugin file in the correct location:
   - **Project plugins**: `.opencode/plugin/<plugin-name>/index.ts`
   - **Global plugins**: `~/.config/opencode/plugin/<plugin-name>/index.ts`
   
   The plugin file MUST be inside a subdirectory named after the plugin.
5. Provide testing instructions when complete

</instructions>
