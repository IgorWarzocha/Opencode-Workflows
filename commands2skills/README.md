# Opencode Commands Template

> [!NOTE]
> **Partially Deprecated**: OpenCode now supports [Skills](https://opencode.ai/docs/skills/) natively, which provide a more powerful way to extend agent capabilities. This template remains useful if you want agents to discover and execute your `/commands` agentically via a COMMANDS.md index file. For new projects, consider using Skills instead.

A universal template for creating Opencode-based projects with structured commands, tool integration, and automated documentation maintenance.

## Architecture Overview

This template demonstrates how to build command-based projects using Opencode with:

- **Structured Commands**: Workflow templates in `.opencode/command/` with YAML frontmatter
- **Tool Integration**: Commands serving as interfaces to external utilities (JavaScript, Python, CLI tools)
- **Documentation System**: Automated maintenance via the `commands-md-updater` agent
- **Template Structure**: Ready-to-copy architecture for new projects

## Opencode Compatibility

These commands follow the exact same rules and patterns as Opencode's built-in `/commands`. For comprehensive documentation on command structure and behavior, see the [Opencode Commands Documentation](https://opencode.ai/docs/commands).

## Command Integration Pattern

### 4-Part Architecture:

1. **Command File** (`.opencode/command/*.md`)
   - Defines workflow, usage patterns, and error handling
   - Contains arguments section and step-by-step execution
   - Example: `calculate.md` provides structured interface to calculations

2. **External Tool** (`calculate.js`)
   - Handles the actual execution logic safely
   - CLI integration with proper argument parsing
   - Example: JavaScript calculator with mathematical functions

3. **CLI Invocation**
   - Simple command-line interface integration
   - `node calculate.js "$EXPRESSION"` template
   - Handles errors and outputs formatted results

4. **Structured Output**
   - Contextual information and help systems
   - Clear formatting with explanatory details
   - Consistent presentation across different tool types

## Tool Integration

Commands can integrate with any external tools or services:

- **Script files**: JavaScript, Python, Bash, or any executable scripts
- **Bash tools**: System utilities, package managers, development tools
- **API endpoints**: Any curlable REST APIs or webhooks
- **Natural language workflows**: Pure LLM-driven processes without external tools

The `calculate.js` example demonstrates how commands can serve as structured interfaces to external utilities.

## Available Commands

### `/explore` - Repository Analysis
- **Purpose**: Explore repository structure, key files, and architectural patterns
- **Arguments**: Context-based scope determination (quick, deep, folder-specific)
- **Output**: Organized repository structure report with insights

### `/calculate` - Mathematical Operations
- **Purpose**: Perform arithmetic calculations and mathematical functions
- **Arguments**: Mathematical expressions or context-based determination
- **Output**: Formatted results with contextual information
- **Tool**: `calculate.js` - JavaScript calculator with error handling

## Template Usage

### For New Projects:

1. **Copy this entire folder structure** to your new project
2. **Create your own `opencode.json`** based on `example-opencode.json`:
   ```json
   {
     "$schema": "https://opencode.ai/config.json",
     "instructions": [
       "AGENTS.md",
       "COMMANDS.md"
     ]
   }
   ```
3. **Modify commands** in `.opencode/command/` to match your project needs
4. **Create corresponding tools** (JavaScript, Python, etc.) as needed
5. **Use the `commands-md-updater` agent** to maintain template structure

### Adding New Commands:

1. Create command file in `.opencode/command/`
2. Follow the established structure:
   - YAML description
   - Arguments section
   - Step-by-step workflow
3. Create supporting tool if needed
4. Use `commands-md-updater` agent to update documentation

## Template Maintenance

The `commands-md-updater` agent maintains Commands2Skills template structure:

### COMMANDS.md
- Lists all available commands with descriptions
- Provides usage instructions for LLMs
- Maintains consistent formatting and structure

### Template Consistency
- Ensures template structure remains accurate
- Synchronizes documentation with available commands
- Maintains proper formatting for template distribution

## File Structure

```
project/
├── COMMANDS.md              # Command index and usage guide
├── example-opencode.json   # Example Opencode configuration
├── calculate.js            # Example tool integration
└── .opencode/
    ├── command/
    │   ├── explore.md       # Repository exploration
    │   └── calculate.md     # Mathematical calculations
    └── agent/
        └── commands-md-updater.md  # Template maintenance
```

## Model Compatibility

Commands.md is injected at the beginning of the session, so models need strong context management and instruction following capabilities.

### Future Enhancement

Currently Opencode only supports context injection at session start. A potential future enhancement would be if Opencode adds the ability to inject context into every user prompt. This would allow COMMANDS.md to be included in every prompt, not just at the start of the session, significantly improving command reliability and reducing context management requirements for models.

*Please let me know if you test this template on different models.*

### Tested Models

| Model | Performance | Behavior |
|-------|-------------|----------|
| GPT-5.1 | Excellent | Reliable execution of all command patterns |
| GPT-5.1 Codex | Excellent | Strong performance for code-related commands |
| GLM-4.6 | Limited | Erratic behavior with agentic instruction following |

### Model Requirements

For optimal performance, models should excel at:
- **Context Management**: Maintaining COMMANDS.md throughout the session
- **Instruction Following**: Precise execution of multi-step workflows
- **Agentic Capabilities**: Understanding when and how to use available commands

## Benefits of This Template

- **Universal Architecture**: Works for any type of command-based project
- **Tool Integration**: Clear pattern for external utility integration
- **Documentation Automation**: Self-maintaining documentation system
- **Scalable Structure**: Easy to add new commands and tools
- **Template-Ready**: Copy-and-paste architecture for new projects
- **LLM-Friendly**: Clear instructions and structured workflows

This template provides a solid foundation for building sophisticated command-based projects with Opencode, demonstrating best practices for command organization, tool integration, and documentation maintenance.