# Distribution & Ownership Reference

<overview>
Choosing the right distribution model depends on the required ownership and customization level.
</overview>

<context>

### Distribution Models

#### 1. Registry (Source Distribution)
Source code is copied directly into the project (e.g., shadcn/ui).
- **Pros**: Full ownership, zero runtime overhead, easy customization.
- **Cons**: Manual updates, code duplication.

#### 2. NPM (Package Distribution)
Pre-built, versioned code installed as a dependency.
- **Pros**: Version management, simplified installation.
- **Cons**: Hard to customize, black-box implementation.

</context>

<rules>

### Transparency Principle
In open-source, consumers SHOULD benefit from visibility.
- You SHOULD provide source maps and readable code.
- You MUST document project structure and dependencies clearly.
- You MUST include migration guides for breaking changes.

</rules>
