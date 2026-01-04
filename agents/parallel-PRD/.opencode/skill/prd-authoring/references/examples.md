# PRD Examples

This file contains complete PRD examples demonstrating the quality standards and templates from SKILL.md.

<example_rest_api>

## Example 1: REST API for Task Management

```markdown
# Task Management API - PRD

## Overview
Build a RESTful API for managing tasks and projects, enabling teams to create, assign, track, and complete work items with support for due dates, priorities, and comments.

## Problem Statement
Teams currently manage tasks through spreadsheets and email, leading to:
- Lost or forgotten tasks (15% of tasks never completed)
- No visibility into project status
- Difficulty tracking who is doing what
- No audit trail of task changes

We need a centralized, reliable task management system.

## Goals
- Reduce task fall-through rate from 15% to <2% within 90 days
- Enable real-time task status visibility for all team members
- Support teams of 1-100 people
- Achieve 99.9% uptime SLA

## Non-Goals
- Time tracking functionality (Phase 2)
- Git integration (Phase 2)
- Mobile apps (Phase 2 - MVP is web-only)
- Advanced reporting/analytics (Phase 2)

## Requirements

### Functional Requirements
- [FR-1] Users MUST be able to create tasks with title, description, due date, priority (low/medium/high), and assignee
- [FR-2] Users MUST be able to update task status (todo/in_progress/done)
- [FR-3] Users MUST be able to add comments to tasks
- [FR-4] Users MUST be able to filter tasks by project, assignee, status, and priority
- [FR-5] Users MUST be able to assign tasks to other users
- [FR-6] System MUST send email notifications for task assignments and due date reminders

### Non-Functional Requirements
- [NFR-1] **Performance**: API MUST respond in <200ms at p95 for all endpoints
- [NFR-2] **Scalability**: System MUST support 10,000 concurrent users
- [NFR-3] **Reliability**: 99.9% uptime SLA (max 43 minutes downtime/month)
- [NFR-4] **Security**: All endpoints MUST require authentication except /health
- [NFR-5] **Security**: Passwords MUST be hashed with bcrypt (cost factor 12)
- [NFR-6] **Data Retention**: Deleted tasks MUST be soft-deleted for 30 days

### Technical Requirements
- [TR-1] API MUST follow REST conventions (proper HTTP verbs, status codes)
- [TR-2] All write operations MUST be idempotent where possible
- [TR-3] System MUST use PostgreSQL for data persistence
- [TR-4] System MUST use Redis for caching frequently-accessed tasks

## Proposed Architecture

### System Design

```
[Client] ←→ [Load Balancer] ←→ [API Server (Node.js)]
                                      ↓
                              [PostgreSQL Database]
                                      ↓
                              [Redis Cache Layer]
```

### Component Breakdown

**API Server (Node.js/Express)**
- Responsibilities: Request handling, authentication, business logic
- Scaling: Horizontal scaling via stateless design
- Technology: Node.js 20 LTS, Express.js

**PostgreSQL Database**
- Responsibilities: Persistent data storage
- Scaling: Read replicas for queries, primary for writes
- Technology: PostgreSQL 16

**Redis Cache**
- Responsibilities: Cache frequently-accessed tasks and user sessions
- Scaling: Redis Cluster for horizontal scaling
- Technology: Redis 7

### Data Flow

1. **Create Task Flow**
   - Client POSTs to `/api/tasks` with task data
   - API validates request (authentication, input validation)
   - API writes task to PostgreSQL
   - API caches task in Redis (TTL 5 minutes)
   - API returns 201 with created task
   - API sends email notification to assignee (async queue)

2. **Get Task Flow**
   - Client GETs `/api/tasks/:id`
   - API checks Redis cache first
   - If cache hit: return cached task (sub-1ms response)
   - If cache miss: query PostgreSQL, cache result, return task

### API Design

<code_snippets>

#### Endpoints

```typescript
// Task Endpoints

// Create task
POST /api/tasks
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Implement login",
  "description": "Add OAuth login with Google",
  "dueDate": "2024-02-15T10:00:00Z",
  "priority": "high",
  "assigneeId": "user-123"
}

Response: 201 Created
{
  "id": "task-456",
  "title": "Implement login",
  "description": "Add OAuth login with Google",
  "status": "todo",
  "dueDate": "2024-02-15T10:00:00Z",
  "priority": "high",
  "assignee": {
    "id": "user-123",
    "name": "Jane Doe",
    "email": "jane@example.com"
  },
  "createdAt": "2024-01-15T10:00:00Z",
  "updatedAt": "2024-01-15T10:00:00Z"
}

// Get task
GET /api/tasks/:id
Response: 200 OK (task object)

// Update task
PATCH /api/tasks/:id
Body: { status: "in_progress" }
Response: 200 OK (updated task)

// List tasks
GET /api/tasks?assignee=user-123&status=todo&priority=high
Response: 200 OK
{
  "tasks": [...],
  "total": 42,
  "page": 1,
  "pageSize": 20
}

// Add comment
POST /api/tasks/:id/comments
Body: { "content": "This is blocked on design review" }
Response: 201 Created
```

#### Data Schemas

```typescript
// Database schema

// Tasks table
interface Task {
  id: string; // UUID
  title: string; // varchar(255), NOT NULL
  description: string; // text
  status: 'todo' | 'in_progress' | 'done'; // enum, DEFAULT 'todo'
  priority: 'low' | 'medium' | 'high'; // enum, DEFAULT 'medium'
  dueDate: Date | null; // timestamp
  assigneeId: string | null; // UUID FK → users.id
  projectId: string; // UUID FK → projects.id, NOT NULL
  createdAt: Date; // timestamp, DEFAULT NOW()
  updatedAt: Date; // timestamp, DEFAULT NOW()
  deletedAt: Date | null; // timestamp, for soft delete
}

// Comments table
interface Comment {
  id: string; // UUID
  taskId: string; // UUID FK → tasks.id, NOT NULL
  authorId: string; // UUID FK → users.id, NOT NULL
  content: string; // text, NOT NULL
  createdAt: Date; // timestamp, DEFAULT NOW()
}

// Indexes
CREATE INDEX idx_tasks_assignee ON tasks(assigneeId) WHERE deletedAt IS NULL;
CREATE INDEX idx_tasks_project ON tasks(projectId) WHERE deletedAt IS NULL;
CREATE INDEX idx_tasks_status ON tasks(status) WHERE deletedAt IS NULL;
CREATE INDEX idx_comments_task ON comments(taskId);
```

#### Configuration

```bash
# Environment variables
DATABASE_URL=postgresql://user:pass@localhost:5432/taskdb
REDIS_URL=redis://localhost:6379
JWT_SECRET=prod-secret-key-change-me
JWT_EXPIRES_IN=24h
SMTP_HOST=smtp.sendgrid.net
SMTP_API_KEY=SG.xxx
```

</code_snippets>

## Technical Considerations

### Technology Choices

| Technology | Justification | Alternatives Considered |
|------------|---------------|-------------------------|
| Node.js/Express | Team expertise, great async I/O, fast development | Python/FastAPI (considered), Go (too complex for team) |
| PostgreSQL | ACID compliance, complex queries, JSON support | MySQL (considered), MongoDB (lacks transaction support) |
| Redis | Sub-millisecond reads, mature ecosystem | Memcached (no persistence), In-memory cache (built-in, slower) |
| JWT | Stateless auth, widely supported | Sessions (requires session store) |

### Trade-offs Analyzed

| Option | Pros | Cons | Decision |
|--------|------|------|----------|
| SQL vs NoSQL | SQL: ACID, complex queries; NoSQL: Flexible schema | NoSQL lacks transaction support for task+comment atomicity | ✅ SQL (PostgreSQL) |
| REST vs GraphQL | REST: Simple, cacheable; GraphQL: Flexible queries | GraphQL adds complexity, overkill for CRUD API | ✅ REST |
| Monolith vs Microservices | Monolith: Simple deploy; Microservices: Scalable | Microservices add operational complexity | ✅ Monolith (can extract services later) |

### Risks and Mitigations

| Risk | Impact | Probability | Mitigation Strategy |
|------|--------|-------------|---------------------|
| Database becomes bottleneck | High | Medium | Add Redis cache, implement read replicas, database connection pooling |
| Cache stampede (thundering herd) | High | Low | Implement request coalescing, use cache locks |
| Authentication service down | High | Low | Use stateless JWT (no session store), implement retry with exponential backoff |
| Email delivery delays | Medium | Medium | Use message queue (SQS/Redis Queue) for async sending |
| SQL injection | Critical | Low | Use parameterized queries (ORM), input validation, rate limiting |

## Implementation Strategy

### Phase 1: Foundation
- [ ] **TASK-1**: Set up project structure and development environment
  - Complexity: Simple
  - Dependencies: None
  - Parallelizable: Yes - Can run concurrently with infrastructure setup (TASK-8 early stages)
  - Testing: Recommended - integration tests for CI/CD pipeline
  - Acceptance criteria: Repo created, CI/CD pipeline working, local dev setup documented

- [ ] **TASK-2**: Design and implement database schema with migrations
  - Complexity: Medium
  - Dependencies: TASK-1
  - Parallelizable: Yes - Schema design can begin during TASK-1, coordinate on final structure
  - Testing: Required - integration tests for migrations, schema validation
  - Acceptance criteria: Migration scripts tested, schema matches API design

- [ ] **TASK-3**: Implement authentication endpoints (register, login, logout)
  - Complexity: Medium
  - Dependencies: TASK-2
  - Parallelizable: No - Requires database schema to be finalized
  - Testing: Required - unit tests for password hashing, integration tests for auth flow
  - Acceptance criteria: JWT tokens work, password hashing with bcrypt, tests pass

**Definition of Done**: Authentication system functional, database schema finalized, API framework ready

### Phase 2: Core CRUD
- [ ] **TASK-4**: Implement task CRUD endpoints (create, read, update, delete)
  - Complexity: Medium
  - Dependencies: TASK-3
  - Parallelizable: Yes - Can split into subtasks (create, read, update, delete) worked in parallel
  - Testing: Required - unit tests for each endpoint, integration tests for full CRUD flow
  - Acceptance criteria: All endpoints working, integration tests pass, p95 <200ms

- [ ] **TASK-5**: Implement task filtering and pagination
  - Complexity: Medium
  - Dependencies: TASK-4
  - Parallelizable: Yes - Can work on filtering logic separately from pagination logic
  - Testing: Required - integration tests for various filter combinations, edge cases
  - Acceptance criteria: Query builder supports all filter combinations, performance validated

- [ ] **TASK-6**: Implement comment system
  - Complexity: Simple
  - Dependencies: TASK-4
  - Parallelizable: Yes - Independent from TASK-5, can run concurrently
  - Testing: Required - unit tests for comment operations, integration tests with tasks
  - Acceptance criteria: Comments CRUD works, notification system integrated

**Definition of Done**: Task and comment management fully functional with caching

### Phase 3: Polish & Launch
- [ ] **TASK-7**: Implement email notifications (assignment, due date reminders)
  - Complexity: Medium
  - Dependencies: TASK-6
  - Parallelizable: No - Depends on comment system for assignment notifications
  - Testing: Required - integration tests with email queue, e2e tests for notification delivery
  - Acceptance criteria: Emails sent reliably via queue system, templates tested

- [ ] **TASK-8**: Add rate limiting and abuse prevention
  - Complexity: Simple
  - Dependencies: TASK-4
  - Parallelizable: Yes - Independent task, can run with other P2 tasks
  - Testing: Required - integration tests for rate limit enforcement, edge cases
  - Acceptance criteria: Rate limits enforced (100 req/min per user), abuse alerts working

- [ ] **TASK-9**: Performance testing and optimization
  - Complexity: Complex
  - Dependencies: All tasks
  - Parallelizable: Yes - Can split into database optimization, caching strategy, query tuning
  - Testing: Required - performance tests, load tests, benchmarking
  - Acceptance criteria: p95 <200ms at 1000 RPS, load test report generated

- [ ] **TASK-10**: Security audit and penetration testing
  - Complexity: Complex
  - Dependencies: All tasks
  - Parallelizable: Yes - Can run in parallel with TASK-9
  - Testing: Required - security tests, vulnerability scans, penetration testing
  - Acceptance criteria: No critical vulnerabilities found, fixes deployed for any issues

**Definition of Done**: Production-ready API with monitoring, logging, and security measures

## Task Breakdown

### High Priority (P0) - Blockers for launch
- [ ] **TASK-1**: Project setup and dev environment
  - Complexity: Simple
  - Dependencies: None
  - Parallelizable: Yes - Can run simultaneously with infrastructure setup
  - Testing: Recommended - integration tests for CI/CD pipeline
  - Acceptance criteria: Repo exists, README documents local setup, CI/CD pipeline deploys to staging

- [ ] **TASK-2**: Database schema and migrations
  - Complexity: Medium
  - Dependencies: TASK-1
  - Parallelizable: Yes - Schema design can begin during TASK-1, coordinate on final structure
  - Testing: Required - integration tests for migrations, schema validation
  - Acceptance criteria: `migrations/` folder has up/down scripts, tests verify schema

- [ ] **TASK-3**: Authentication system
  - Complexity: Medium
  - Dependencies: TASK-2
  - Parallelizable: No - Requires database schema to be finalized
  - Testing: Required - unit tests for password hashing, integration tests for auth flow
  - Acceptance criteria: POST /auth/register and /auth/login work, returns valid JWT

- [ ] **TASK-4**: Task CRUD endpoints
  - Complexity: Medium
  - Dependencies: TASK-3
  - Parallelizable: Yes - Can split into subtasks (create, read, update, delete) worked in parallel
  - Testing: Required - unit tests for each endpoint, integration tests for CRUD flow
  - Acceptance criteria: POST/GET/PATCH/DELETE /api/tasks work with valid data

### Medium Priority (P1) - Important but not blocking
- [ ] **TASK-5**: Filtering and pagination
  - Complexity: Medium
  - Dependencies: TASK-4
  - Parallelizable: Yes - Can work on filtering logic separately from pagination logic
  - Testing: Required - integration tests for various filter combinations
  - Acceptance criteria: Query string parameters work, pagination metadata correct

- [ ] **TASK-6**: Comment system
  - Complexity: Simple
  - Dependencies: TASK-4
  - Parallelizable: Yes - Independent from TASK-5, can run concurrently
  - Testing: Required - unit tests for comment operations, integration tests with tasks
  - Acceptance criteria: Comments can be added to tasks, returned with task details

- [ ] **TASK-7**: Email notifications
  - Complexity: Medium
  - Dependencies: TASK-6
  - Parallelizable: No - Depends on comment system for assignment notifications
  - Testing: Required - integration tests with email queue, e2e tests for delivery
  - Acceptance criteria: Emails sent on assignment and due date, queue system working

### Low Priority (P2) - Nice to have
- [ ] **TASK-8**: Rate limiting
  - Complexity: Simple
  - Dependencies: TASK-4
  - Parallelizable: Yes - Independent task, can run with other P2 tasks
  - Testing: Required - integration tests for rate limit enforcement
  - Acceptance criteria: 429 responses after limit, headers show rate limit info

- [ ] **TASK-9**: Performance optimization
  - Complexity: Complex
  - Dependencies: All tasks
  - Parallelizable: Yes - Can split into database optimization, caching strategy, query tuning
  - Testing: Required - performance tests, load tests, benchmarks
  - Acceptance criteria: Redis caching implemented, benchmarks show improvement

## Success Metrics
- **Task completion rate**: 85% → 98% within 90 days (measure: tasks marked as "done" / tasks created)
- **API response time**: p95 <200ms (measure: API gateway metrics)
- **System uptime**: 99.9% (measure: monitoring service uptime)
- **User adoption**: 50 team members using the system within 30 days (measure: user count in DB)

## Open Questions
- **Q1**: Should we support task dependencies (task B blocks task A)?
  - Options: (a) Yes, add in Phase 1, (b) Defer to Phase 2, (c) Not needed
  - Decision needed by: 2024-01-20
  - Owner: Product Manager
  - **Decision**: Defer to Phase 2 (focus on core CRUD first)

- **Q2**: Real-time updates for task status changes?
  - Options: (a) WebSocket push, (b) Polling, (c) No real-time needed
  - Decision needed by: 2024-01-20
  - Owner: Tech Lead
  - **Decision**: Defer to Phase 2 (Phase 1 uses polling every 30s)

## Appendices

### Monitoring Setup
```typescript
// Metrics to track
const metrics = {
  // Request metrics
  'api.request.count': Counter for all API requests,
  'api.request.duration': Histogram for response times,
  'api.request.errors': Counter for 4xx/5xx responses,

  // Business metrics
  'tasks.created': Counter for tasks created,
  'tasks.completed': Counter for tasks marked done,
  'users.active': Gauge for active users (last 24h),

  // Infrastructure metrics
  'db.connections': Gauge for PostgreSQL pool usage,
  'cache.hit_rate': Gauge for Redis cache effectiveness,
};

// Alerting rules
- Alert if api.request.duration p95 >200ms for 5 minutes
- Alert if api.request.errors >5% for 5 minutes
- Alert if tasks.created = 0 for 1 hour (indicates issue)
```
```

</example_rest_api>

---

**Quality Checklist Applied:**
- ✅ Specific, measurable goals
- ✅ Functional and non-functional requirements numbered
- ✅ System design diagram
- ✅ Data flow with steps
- ✅ Code snippets (API endpoints, schemas, config)
- ✅ Technology choices justified
- ✅ Trade-offs analyzed
- ✅ Risk mitigation table
- ✅ Phased implementation with tasks
- ✅ Tasks include complexity, parallelization, and testing requirements
- ✅ Success metrics with baselines and targets
- ✅ Open questions with options and owners
