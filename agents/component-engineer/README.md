# Component Engineer Package

A comprehensive Opencode package based on the formal specification for modern React components. It provides agents, commands, and skills for building and reviewing high-quality UI artifacts.

## Architecture

### 1. Agent: `component-engineer`
A rigorous architect strictly limited to the `component-engineering` skill. It handles complex refactoring, a11y audits, and spec-compliant creation.

### 2. Commands
- `/component-review [file]`: Detailed audit against a11y, composition, and styling pillars.
- `/component-create [name] [intent]`: Spec-driven generation of new components/blocks.

### 3. Skill: `component-engineering`
A deep knowledge base divided into specialized references:
- **[accessibility.md](.opencode/skill/component-engineering/references/accessibility.md)**: Semantic HTML, focus management, ARIA.
- **[composition.md](.opencode/skill/component-engineering/references/composition.md)**: Slot patterns, polymorphism, compound components.
- **[styling.md](.opencode/skill/component-engineering/references/styling.md)**: Data attributes, design tokens, Tailwind.
- **[taxonomy.md](.opencode/skill/component-engineering/references/taxonomy.md)**: Artifact classification (Primitive, Component, Block, etc.).
- **[distribution.md](.opencode/skill/component-engineering/references/distribution.md)**: Registry vs NPM and source ownership.

## Installation

Copy to your global `~/.config/opencode/` directory or your working folder.

## Key Principles
- **Semantic HTML First**: Never use a `div` when a `button` is needed.
- **asChild (Slot Pattern)**: Composable APIs that eliminate wrapper hell.
- **Data-Driven Styling**: Use `data-state` and `data-slot` for clean, stable CSS hooks.
- **Artifact Taxonomy**: Clear classification flow for every UI element.
