# CODING.md - Development Guidelines

<overview>
Core Principles for Clean, Maintainable Code Architecture. Universal development guidelines applicable to any project. Focus on DRY principles, maintainable architecture, and type safety.
</overview>

<instructions>

## Core Development Principles

**DRY PRINCIPLE**: Pattern recognition is key - if you see similar code twice, abstract it immediately. Create reusable components, shared utilities, and unified interfaces.

Apply these principles naturally:

- **DRY First**: Check if something similar exists to extend/reuse before writing new code
- **Single Purpose**: Each component/function SHOULD do ONE thing well
- **Compose, Don't Inherit**: Build complex things from simple, reusable pieces
- **KISS**: Simple solutions beat clever ones - readable code > smart code
- **Fail Fast**: Throw errors clearly rather than hiding problems with defensive code
- **Extract Early**: See a pattern emerging? Pull it into a shared utility immediately
- **Occam's Razor**: Simplest explanation is usually correct - avoid over-engineering
- **Pareto Principle**: 80% of results come from 20% of effort - focus on high-impact features

</instructions>

<rules>

## Code Quality

- **File Headers**: Every file MUST start with 2-3 sentence comment explaining what it does
- **Strategic Comments**: Comment major sections and complex logic, not every line
- **NO Logging**: MUST NOT use console.log, console.error, or any logging - trust TypeScript and DevTools
- **Progressive Cleanup**: When editing files, replace `any` types with proper interfaces and delete console statements - technical debt decreases over time
- **Real Features**: Build actual functionality - MUST NOT create fake implementations that pretend to be dynamic but return hardcoded results
- **Error Prevention**: Catch problems before they happen, not just handle them
- **Systems Thinking**: Consider how changes affect the bigger picture
- **Zero Technical Debt**: No quick hacks that compromise system integrity

## File Size & Modularity

- **Small Files**: Files SHOULD NOT exceed 200 lines; files over 300 lines MUST be split
- **Single Responsibility**: Each file MUST have one clear purpose - if you need "and" to describe it, split it
- **Function Length**: Functions SHOULD NOT exceed 40 lines; extract helpers for complex logic
- **Early Extraction**: When a file approaches 150 lines, proactively identify extraction candidates

## Barrel Exports

- **Index Files**: Every module directory MUST have an `index.ts` barrel file
- **Public API**: Barrel files MUST explicitly export only the public interface - internal helpers stay private
- **Import Paths**: Consumers MUST import from barrel files, not deep paths (e.g., `import { Thing } from './module'` not `'./module/thing'`)
- **Re-export Pattern**: Use `export { ComponentName } from './ComponentName'` - SHOULD NOT use `export *` to keep API explicit
- **Flat Imports**: Barrel exports enable refactoring internals without breaking consumers

## Core Development Rules

1. **Domain Separation** - Organize code by business domain, not technical layers
2. **Configuration Management** - Store configuration in persistent storage; MUST NOT use hardcoded values
3. **Specialized Modules** - Create focused modules for specific business logic
4. **Structured Data Validation** - MUST validate all external data with proper schemas
5. **Pattern Recognition** - Extract common patterns into reusable utilities early
6. **Function Relationships** - Consider how different functions interact and consolidate when patterns emerge
7. **Clean Organization** - Maintain clear directory structure and avoid code sprawl

</rules>

<workflow>

## Development Tool Best Practices

1. **Read First**: MUST understand existing code before making changes - read files and understand context fully
2. **Search Smart**: Use appropriate search tools for file patterns and content discovery
3. **Batch Operations**: Group related operations when possible for better performance
4. **Edit Precisely**: SHOULD make targeted changes rather than broad rewrites when possible
5. **Plan Complex Tasks**: Break down multi-step operations into manageable pieces
6. **Schema Work**: MUST review existing data structures and schemas before modifications

## Integration Best Practices

- **Data Flow**: Design clear data flow patterns (input → validation → processing → output)
- **Service Communication**: Use well-defined APIs for service-to-service communication
- **Frontend Integration**: Optimize queries and data fetching for performance
- **Error Propagation**: Design consistent error handling across all layers
- **Testing Strategy**: SHOULD implement comprehensive testing at unit, integration, and system levels

</workflow>

<guidelines>

## Type Safety Patterns (Modern Approach)

- **Trust Inference**: Let your type system infer types rather than explicitly typing everything
- **Return Types Sparingly**: Only add explicit return types when they add value or prevent errors
- **Inference > Explicit**: Modern type systems are smarter than manual type annotations
- **Structured Data**: Use strict schemas for API boundaries, flexible types for internal logic
- **Type Safety First**: Prefer typed languages and SHOULD avoid `any` types when possible
- **End-to-End Types**: Leverage type safety across your entire stack when available
- **Validation**: Use runtime validation for external data and API boundaries

## Project Documentation

Essential documentation files to maintain:

- `README.md` - Project overview, setup instructions, and getting started guide
- `CHANGELOG.md` - Version history and breaking changes
- `CONTRIBUTING.md` - Development workflow, coding standards, and contribution guidelines
- `ARCHITECTURE.md` - System design, directory structure, and technical decisions
- `API.md` - API documentation and endpoint specifications

</guidelines>

<architecture>

## Modular Architecture

Modules MUST be self-contained units with clear boundaries:

```
feature/
├── index.ts          # Barrel - public API (REQUIRED)
├── types.ts          # Shared types for this module
├── FeatureMain.tsx   # Primary component/logic
├── useFeature.ts     # Hooks (if React)
└── helpers/          # Internal utilities
    ├── index.ts      # Barrel for helpers
    └── validate.ts
```

- **Module Boundaries**: Each feature MUST be importable via single barrel entry
- **Dependency Direction**: Modules SHOULD depend on abstractions, not concrete implementations
- **Circular Prevention**: Modules MUST NOT have circular dependencies - extract shared code to common module
- **Colocation**: Keep related code together - tests, types, and helpers alongside implementation

## System Design Patterns

- **Database-First Design**: Store configuration and business logic in persistent storage
- **Service Separation**: Isolate different concerns into separate services when appropriate
- **API-First Development**: Design clear interfaces between system components
- **Real-time Capabilities**: Leverage real-time features when user experience benefits

## Common Architecture Patterns

- **Pipeline Processing**: Chain operations in logical sequences (input → process → output)
- **Event-Driven Systems**: Use events for loose coupling between components
- **Caching Strategies**: Implement appropriate caching for performance optimization
- **Error Handling**: Design robust error handling and recovery mechanisms
- **Scalability Planning**: Consider horizontal and vertical scaling from the start

</architecture>
