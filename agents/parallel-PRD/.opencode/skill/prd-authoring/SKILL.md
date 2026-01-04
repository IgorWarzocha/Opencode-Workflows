---
name: prd-authoring
description: Comprehensive Product Requirement Document (PRD) authoring. Use when: creating PRDs, writing technical specifications, designing system architecture, defining product requirements, planning implementation phases, creating task lists from requirements, or generating code snippets for API designs and schemas.
---

# PRD Authoring

<overview>

This skill provides comprehensive guidance for creating high-quality Product Requirement Documents (PRDs) that include:

- Complete technical specifications
- Actionable task lists with priorities
- Relevant code snippets and examples
- Clear implementation phases
- Measurable success criteria

</overview>

<quality_standards>

## What Makes a Good PRD

A good PRD MUST be:
- **Actionable**: Each requirement can be implemented directly
- **Complete**: Covers functional, non-functional, and technical requirements
- **Specific**: Uses precise language, avoiding vague terms like "should" or "might"
- **Measurable**: Includes success metrics that can be quantified
- **Implementable**: Contains sufficient detail for engineering to build

## Required Elements

Every PRD MUST include:

1. **Problem Statement** - Clear articulation of what problem we're solving and why
2. **Goals** - Specific, measurable objectives
3. **Requirements** - Functional and non-functional requirements
4. **Architecture** - System design, components, data flow
5. **Implementation Plan** - Phased approach with milestones
6. **Task List** - Actionable next steps (see template below)
7. **Success Metrics** - Quantifiable measures of success
8. **Code Snippets** - Relevant examples (see guidelines below)

</quality_standards>

<prd_template>

## PRD Template

```markdown
# [Feature Name] - PRD

## Overview
[2-3 sentence summary]

## Problem Statement
[What problem are we solving? Why now? What's the impact of not solving it?]

## Goals
- [ ] [Primary goal 1 - specific and measurable]
- [ ] [Primary goal 2 - specific and measurable]
- [ ] [Secondary goal 3]

## Non-Goals
[What we explicitly will NOT do in this iteration - sets scope boundaries]

## Requirements

### Functional Requirements
- [FR-1] [User stories/use cases as specific requirements]
- [FR-2] [Acceptance criteria for each requirement]

### Non-Functional Requirements
- [NFR-1] **Performance**: [specific metrics, e.g., "API responds in <200ms at p95"]
- [NFR-2] **Security**: [e.g., "All data encrypted at rest and in transit"]
- [NFR-3] **Scalability**: [e.g., "System handles 10k concurrent users"]
- [NFR-4] **Reliability**: [e.g., "99.9% uptime SLA"]

### Technical Requirements
- [TR-1] [Technology stack constraints]
- [TR-2] [Integration requirements]
- [TR-3] [Data retention/compliance requirements]

## Proposed Architecture

### System Design
[High-level architecture - use text diagrams or mermaid]

```
[Component A] ←→ [Component B] ←→ [Component C]
       ↓               ↓               ↓
   [Database]    [Cache Layer]   [External API]
```

### Component Breakdown
- **Component A**: [Responsibility, technology choice, scaling approach]
- **Component B**: [Responsibility, technology choice, scaling approach]
- **Component C**: [Responsibility, technology choice, scaling approach]

### Data Flow
1. [Step-by-step description of how data moves through the system]
2. [Include error handling, retries, fallbacks]
3. [Describe async/sync boundaries]

### API Design (if applicable)
[Include endpoint specifications, request/response schemas]

## Technical Considerations

### Technology Choices
| Technology | Justification | Alternatives Considered |
|------------|---------------|-------------------------|
| [Tech 1]   | [Why this choice] | [Alternative 1, Alternative 2] |
| [Tech 2]   | [Why this choice] | [Alternative 1, Alternative 2] |

### Trade-offs Analyzed
| Option | Pros | Cons | Decision |
|--------|------|------|----------|
| [Option A] | ... | ... | ✅/❌ |
| [Option B] | ... | ... | ✅/❌ |

### Risks and Mitigations
| Risk | Impact | Probability | Mitigation Strategy |
|------|--------|-------------|---------------------|
| [Risk 1] | High/Med/Low | High/Med/Low | [How to address] |
| [Risk 2] | High/Med/Low | High/Med/Low | [How to address] |

## Implementation Strategy

### Phase 1: Foundation
- [ ] [Task 1.1]
- [ ] [Task 1.2]
- [ ] [Task 1.3]

**Definition of Done**: [Specific criteria for phase completion]

### Phase 2: Core Features
- [ ] [Task 2.1]
- [ ] [Task 2.2]
- [ ] [Task 2.3]

**Definition of Done**: [Specific criteria for phase completion]

### Phase 3: Polish & Launch
- [ ] [Task 3.1]
- [ ] [Task 3.2]
- [ ] [Task 3.3]

**Definition of Done**: [Specific criteria for phase completion]

## Task Breakdown

<task_list_template>
### High Priority (P0) - Blockers for launch
- [ ] **[TASK-1]**: [Actionable task title]
  - Complexity: [Simple/Medium/Complex]
  - Dependencies: [Task IDs or components that must exist first]
  - Parallelizable: [Yes/No - if Yes, specify which tasks can run simultaneously]
  - Testing: [Required/Recommended/None - specify type: unit, integration, e2e]
  - Acceptance criteria: [Specific, testable criteria]

### Medium Priority (P1) - Important but not blocking
- [ ] **[TASK-2]**: [Actionable task title]
  - Complexity: [Simple/Medium/Complex]
  - Dependencies: [Task IDs or components that must exist first]
  - Parallelizable: [Yes/No - if Yes, specify which tasks can run simultaneously]
  - Testing: [Required/Recommended/None - specify type: unit, integration, e2e]
  - Acceptance criteria: [Specific, testable criteria]

### Low Priority (P2) - Nice to have
- [ ] **[TASK-3]**: [Actionable task title]
  - Complexity: [Simple/Medium/Complex]
  - Dependencies: [Task IDs or components that must exist first]
  - Parallelizable: [Yes/No - if Yes, specify which tasks can run simultaneously]
  - Testing: [Required/Recommended/None - specify type: unit, integration, e2e]
  - Acceptance criteria: [Specific, testable criteria]
</task_list_template>

<parallelization_guidance>

### Task Parallelization

Mark tasks as **Parallelizable: Yes** when:
- Task is independent of other in-progress tasks
- Multiple developers/subagents can work on different aspects simultaneously
- Task can be split into independent sub-tasks

**Examples:**

✅ **Parallelizable**
- "Design REST API endpoints" and "Design database schema" - can be done simultaneously with coordination
- "Write frontend user profile component" and "Write frontend settings component" - independent components
- "Set up CI/CD pipeline" and "Set up monitoring infrastructure" - separate infrastructure tasks

❌ **Not Parallelizable**
- "Implement authentication" - blocks on "Design database schema" (dependency)
- "Write API tests" - requires API endpoints to exist first (dependency)

**Format for parallelizable tasks:**
```markdown
- Parallelizable: Yes - Can run concurrently with [TASK-X], [TASK-Y]
```

</parallelization_guidance>

<complexity_guidance>

### Task Complexity Levels

**Simple**
- Well-defined scope
- No unknown unknowns
- Follows established patterns
- Single system/component
- Example: "Add email validation to registration form"

**Medium**
- Some research or investigation needed
- Multiple components to integrate
- Requires decision-making
- Some ambiguity to resolve
- Example: "Implement OAuth 2.0 login with Google and GitHub"

**Complex**
- Significant architectural decisions
- Cross-system dependencies
- High ambiguity or research required
- Performance or security concerns
- Requires prototyping or spikes
- Example: "Design and implement real-time notification system with WebSocket scaling"

</complexity_guidance>

<testing_guidance>

### Testing Requirements

Each task MUST specify testing needs:

**Required** - Critical functionality, MUST have tests before merging
- User authentication/authorization
- Payment processing
- Data persistence operations
- External API integrations

**Recommended** - Should have tests but not blocking
- UI components
- Business logic validation
- Edge case handling
- Error scenarios

**None** - Tests not applicable
- Configuration changes
- Documentation updates
- Infrastructure setup
- Design/mockup tasks

**Test Types:**
- `unit` - Individual functions/components in isolation
- `integration` - Multiple components working together
- `e2e` - Full user flows from start to finish
- `performance` - Load testing, benchmarks
- `security` - Penetration testing, vulnerability scans

</testing_guidance>

## Success Metrics
- [Metric 1]: [Current value] → [Target value]
- [Metric 2]: [Current value] → [Target value]
- [Metric 3]: [Current value] → [Target value]

## Open Questions
- [Q1] [Question that needs resolution]
  - Options: [Option A, Option B, Option C]
  - Decision owner: [Who will decide]

## Appendices

### Code Snippets
[Include relevant code examples - see guidelines below]

### Data Schemas
[Include database schemas, type definitions, etc.]

### Mockups
[Links to UI mockups or wireframes]
```

</prd_template>

<code_snippet_guidelines>

## When to Include Code Snippets

PRDs SHOULD include code snippets when they clarify technical details. Use for:

### 1. API Design
**Include when**: Defining endpoints, request/response formats

```typescript
// POST /api/users
interface CreateUserRequest {
  email: string;
  password: string; // Hashed with bcrypt
  name: string;
}

interface CreateUserResponse {
  id: string;
  email: string;
  createdAt: Date;
}
```

### 2. Data Schemas
**Include when**: Defining database models, type definitions

```typescript
// User schema
interface User {
  id: string; // UUID
  email: string; // Unique, indexed
  passwordHash: string; // bcrypt
  createdAt: Date;
  updatedAt: Date;
}

// Indexes
db.users.createIndex({ email: 1 }, { unique: true });
```

### 3. Configuration Examples
**Include when**: Defining feature flags, environment variables

```bash
# Environment variables
DATABASE_URL=postgresql://...
JWT_SECRET=your-secret-key
RATE_LIMIT_ENABLED=true
RATE_LIMIT_REQUESTS_PER_MINUTE=100
```

### 4. Algorithm Examples
**Include when**: Explaining complex logic

```typescript
// Rate limiting algorithm
function rateLimit(userId: string): boolean {
  const requests = redis.get(`ratelimit:${userId}`) || 0;
  if (requests >= LIMIT) {
    return false; // Rate limited
  }
  redis.incr(`ratelimit:${userId}`);
  redis.expire(`ratelimit:${userId}`, 60);
  return true; // Allowed
}
```

### 5. Integration Examples
**Include when**: Showing how components interact

```typescript
// Example: Service A calling Service B
const response = await fetch('http://service-b/api/process', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ data: payload })
});
```

### What NOT to Include

❌ **Full implementation code** - PRDs are for requirements, not implementation
❌ **Business logic details** - Save for actual development
❌ **Boilerplate code** - Unless it's configuration

✅ **DO include**: Interfaces, schemas, examples of architecture
✅ **DO include**: Configuration, API contracts, data models

</code_snippet_guidelines>

<task_list_guidelines>

## Creating Actionable Task Lists

Tasks in PRDs MUST be:

### Specific
❌ "Implement user authentication"
✅ "Implement OAuth 2.0 login with Google and GitHub providers"

### Testable
❌ "Make it fast"
✅ "API response time <200ms at p95 under 1000 RPS"

### Atomic
❌ "Build the entire checkout flow"
✅ "Build cart summary endpoint" (one of many tasks)

### Testable
Each task MUST specify testing requirements (Required/Recommended/None)

## Task Template (AI-Agent Optimized)

```markdown
- [ ] **[TASK-ID]** [Actionable title]
  - **Complexity**: [Simple/Medium/Complex]
  - **Dependencies**: [Task IDs or components that must exist first]
  - **Parallelizable**: [Yes/No - if Yes, specify which tasks]
  - **Testing**: [Required/Recommended/None - specify type: unit, integration, e2e]
  - **Acceptance Criteria**:
    - [ ] [Criterion 1 - must be testable]
    - [ ] [Criterion 2 - must be testable]
```

</task_list_guidelines>

<anti_patterns>

## Common PRD Anti-Patterns

### Vague Language
❌ "The system should be scalable"
✅ "System must handle 10,000 concurrent users with <500ms response time"

### Missing Acceptance Criteria
❌ "Implement search functionality"
✅ "Implement full-text search with filters, returning results in <100ms, supporting 100+ concurrent searches"

### No Success Metrics
❌ "Improve user engagement"
✅ "Increase daily active users from 1,000 to 2,000 within 90 days"

### Infinite Scope
❌ "Build the best e-commerce platform"
✅ "Build MVP with product catalog, cart, and checkout (payments via Stripe)"

### Missing Technical Details
❌ "Use a database"
✅ "Use PostgreSQL for relational data, Redis for caching, with proper indexing on email and product_id"

### No Risk Assessment
❌ [No risk section]
✅ [Include risks table with mitigations]

</anti_patterns>

<workflow>

## PRD Authoring Workflow

1. **Understand the Problem**
   - Interview stakeholders if needed
   - Identify pain points with current solution
   - Quantify the opportunity

2. **Draft Requirements**
   - Start with user stories
   - Convert to functional requirements (FR-1, FR-2, etc.)
   - Add non-functional requirements (NFR-1, NFR-2, etc.)

3. **Design Architecture**
   - Create system diagram
   - Define components and their responsibilities
   - Map data flow between components

4. **Add Technical Details**
   - Choose technologies with justification
   - Document trade-offs
   - Include relevant code snippets

5. **Create Task Breakdown**
   - Break into phases
   - Create specific, actionable tasks
   - Identify dependencies

6. **Define Success**
   - Set measurable metrics
   - Define baseline and target

7. **Review and Refine**
   - Check against quality standards
   - Ensure no anti-patterns
   - Validate with stakeholders

</workflow>

<examples>

See `references/examples.md` for complete PRD examples.

</examples>
