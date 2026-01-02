# Events Reference

> Auto-generated on 2025-12-26T13:17:55.481Z
> Source: `packages/sdk/js/src/v2/gen/types.gen.ts`

<event_types>

## Event Union (35 types)

```typescript
export type Event =
  | EventInstallationUpdated
  | EventInstallationUpdateAvailable
  | EventProjectUpdated
  | EventServerInstanceDisposed
  | EventLspClientDiagnostics
  | EventLspUpdated
  | EventMessageUpdated
  | EventMessageRemoved
  | EventMessagePartUpdated
  | EventMessagePartRemoved
  | EventPermissionUpdated
  | EventPermissionReplied
  | EventFileEdited
  | EventTodoUpdated
  | EventSessionStatus
  | EventSessionIdle
  | EventSessionCompacted
  | EventTuiPromptAppend
  | EventTuiCommandExecute
  | EventTuiToastShow
  | EventMcpToolsChanged
  | EventCommandExecuted
  | EventSessionCreated
  | EventSessionUpdated
  | EventSessionDeleted
  | EventSessionDiff
  | EventSessionError
  | EventFileWatcherUpdated
  | EventVcsBranchUpdated
  | EventPtyCreated
  | EventPtyUpdated
  | EventPtyExited
  | EventPtyDeleted
  | EventServerConnected
  | EventGlobalDisposed
```

</event_types>

<quick_reference>

## Quick Reference

| Event Type | TypeScript Type |
|------------|-----------------| 
| `installation.updated` | `EventInstallationUpdated` |
| `installation.update-available` | `EventInstallationUpdateAvailable` |
| `project.updated` | `EventProjectUpdated` |
| `server.instance.disposed` | `EventServerInstanceDisposed` |
| `lsp.client.diagnostics` | `EventLspClientDiagnostics` |
| `lsp.updated` | `EventLspUpdated` |
| `message.updated` | `EventMessageUpdated` |
| `message.removed` | `EventMessageRemoved` |
| `message.part.updated` | `EventMessagePartUpdated` |
| `message.part.removed` | `EventMessagePartRemoved` |
| `permission.updated` | `EventPermissionUpdated` |
| `permission.replied` | `EventPermissionReplied` |
| `file.edited` | `EventFileEdited` |
| `todo.updated` | `EventTodoUpdated` |
| `session.status` | `EventSessionStatus` |
| `session.idle` | `EventSessionIdle` |
| `session.compacted` | `EventSessionCompacted` |
| `tui.prompt.append` | `EventTuiPromptAppend` |
| `tui.command.execute` | `EventTuiCommandExecute` |
| `tui.toast.show` | `EventTuiToastShow` |
| `mcp.tools.changed` | `EventMcpToolsChanged` |
| `command.executed` | `EventCommandExecuted` |
| `session.created` | `EventSessionCreated` |
| `session.updated` | `EventSessionUpdated` |
| `session.deleted` | `EventSessionDeleted` |
| `session.diff` | `EventSessionDiff` |
| `session.error` | `EventSessionError` |
| `file.watcher.updated` | `EventFileWatcherUpdated` |
| `vcs.branch.updated` | `EventVcsBranchUpdated` |
| `pty.created` | `EventPtyCreated` |
| `pty.updated` | `EventPtyUpdated` |
| `pty.exited` | `EventPtyExited` |
| `pty.deleted` | `EventPtyDeleted` |
| `server.connected` | `EventServerConnected` |
| `global.disposed` | `EventGlobalDisposed` |

</quick_reference>

<event_definitions>

## Events by Category

### command

#### `command.executed`

```typescript
export type EventCommandExecuted = {
  type: "command.executed"
  properties: {
    name: string
    sessionID: string
    arguments: string
    messageID: string
  }
}
```

### file

#### `file.edited`

```typescript
export type EventFileEdited = {
  type: "file.edited"
  properties: {
    file: string
  }
}
```

#### `file.watcher.updated`

```typescript
export type EventFileWatcherUpdated = {
  type: "file.watcher.updated"
  properties: {
    file: string
    event: "add" | "change" | "unlink"
  }
}
```

### global

#### `global.disposed`

```typescript
export type EventGlobalDisposed = {
  type: "global.disposed"
  properties: {
    [key: string]: unknown
  }
}
```

### installation

#### `installation.updated`

```typescript
export type EventInstallationUpdated = {
  type: "installation.updated"
  properties: {
    version: string
  }
}
```

#### `installation.update-available`

```typescript
export type EventInstallationUpdateAvailable = {
  type: "installation.update-available"
  properties: {
    version: string
  }
}
```

### lsp

#### `lsp.client.diagnostics`

```typescript
export type EventLspClientDiagnostics = {
  type: "lsp.client.diagnostics"
  properties: {
    serverID: string
    path: string
  }
}
```

#### `lsp.updated`

```typescript
export type EventLspUpdated = {
  type: "lsp.updated"
  properties: {
    [key: string]: unknown
  }
}
```

### mcp

#### `mcp.tools.changed`

```typescript
export type EventMcpToolsChanged = {
  type: "mcp.tools.changed"
  properties: {
    server: string
  }
}
```

### message

#### `message.updated`

```typescript
export type EventMessageUpdated = {
  type: "message.updated"
  properties: {
    info: Message
  }
}
```

#### `message.removed`

```typescript
export type EventMessageRemoved = {
  type: "message.removed"
  properties: {
    sessionID: string
    messageID: string
  }
}
```

#### `message.part.updated`

```typescript
export type EventMessagePartUpdated = {
  type: "message.part.updated"
  properties: {
    part: Part
    delta?: string
  }
}
```

#### `message.part.removed`

```typescript
export type EventMessagePartRemoved = {
  type: "message.part.removed"
  properties: {
    sessionID: string
    messageID: string
    partID: string
  }
}
```

### permission

#### `permission.updated`

```typescript
export type EventPermissionUpdated = {
  type: "permission.updated"
  properties: Permission
}
```

#### `permission.replied`

```typescript
export type EventPermissionReplied = {
  type: "permission.replied"
  properties: {
    sessionID: string
    permissionID: string
    response: string
  }
}
```

### project

#### `project.updated`

```typescript
export type EventProjectUpdated = {
  type: "project.updated"
  properties: Project
}
```

### pty

#### `pty.created`

```typescript
export type EventPtyCreated = {
  type: "pty.created"
  properties: {
    info: Pty
  }
}
```

#### `pty.updated`

```typescript
export type EventPtyUpdated = {
  type: "pty.updated"
  properties: {
    info: Pty
  }
}
```

#### `pty.exited`

```typescript
export type EventPtyExited = {
  type: "pty.exited"
  properties: {
    id: string
    exitCode: number
  }
}
```

#### `pty.deleted`

```typescript
export type EventPtyDeleted = {
  type: "pty.deleted"
  properties: {
    id: string
  }
}
```

### server

#### `server.instance.disposed`

```typescript
export type EventServerInstanceDisposed = {
  type: "server.instance.disposed"
  properties: {
    directory: string
  }
}
```

#### `server.connected`

```typescript
export type EventServerConnected = {
  type: "server.connected"
  properties: {
    [key: string]: unknown
  }
}
```

### session

#### `session.status`

```typescript
export type EventSessionStatus = {
  type: "session.status"
  properties: {
    sessionID: string
    status: SessionStatus
  }
}
```

#### `session.idle`

```typescript
export type EventSessionIdle = {
  type: "session.idle"
  properties: {
    sessionID: string
  }
}
```

#### `session.compacted`

```typescript
export type EventSessionCompacted = {
  type: "session.compacted"
  properties: {
    sessionID: string
  }
}
```

#### `session.created`

```typescript
export type EventSessionCreated = {
  type: "session.created"
  properties: {
    info: Session
  }
}
```

#### `session.updated`

```typescript
export type EventSessionUpdated = {
  type: "session.updated"
  properties: {
    info: Session
  }
}
```

#### `session.deleted`

```typescript
export type EventSessionDeleted = {
  type: "session.deleted"
  properties: {
    info: Session
  }
}
```

#### `session.diff`

```typescript
export type EventSessionDiff = {
  type: "session.diff"
  properties: {
    sessionID: string
    diff: Array<FileDiff>
  }
}
```

#### `session.error`

```typescript
export type EventSessionError = {
  type: "session.error"
  properties: {
    sessionID?: string
    error?: ProviderAuthError | UnknownError | MessageOutputLengthError | MessageAbortedError | ApiError
  }
}
```

### todo

#### `todo.updated`

```typescript
export type EventTodoUpdated = {
  type: "todo.updated"
  properties: {
    sessionID: string
    todos: Array<Todo>
  }
}
```

### tui

#### `tui.prompt.append`

```typescript
export type EventTuiPromptAppend = {
  type: "tui.prompt.append"
  properties: {
    text: string
  }
}
```

#### `tui.command.execute`

```typescript
export type EventTuiCommandExecute = {
  type: "tui.command.execute"
  properties: {
    command:
      | "session.list"
      | "session.new"
      | "session.share"
      | "session.interrupt"
      | "session.compact"
      | "session.page.up"
      | "session.page.down"
      | "session.half.page.up"
      | "session.half.page.down"
      | "session.first"
      | "session.last"
      | "prompt.clear"
      | "prompt.submit"
      | "agent.cycle"
      | string
  }
}
```

#### `tui.toast.show`

```typescript
export type EventTuiToastShow = {
  type: "tui.toast.show"
  properties: {
    title?: string
    message: string
    variant: "info" | "success" | "warning" | "error"
    /**
     * Duration in milliseconds
     */
    duration?: number
  }
}
```

### vcs

#### `vcs.branch.updated`

```typescript
export type EventVcsBranchUpdated = {
  type: "vcs.branch.updated"
  properties: {
    branch?: string
  }
}
```

</event_definitions>
