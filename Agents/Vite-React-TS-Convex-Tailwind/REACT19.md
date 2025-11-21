# REACT.md

Definition file for AI agents building modern React 19+ web apps.

Focus: function components, Hooks, concurrent features, Actions, Server Components, React Compiler.  
Assume: `react@19+`, `react-dom@19+`, JSX transform configured, bundler that understands React Server Components and directives.

---

## 0. Scope and assumptions

- Target: browser web apps using `react` and `react-dom`.
- Components: function components only. Do not create new class components.
- State: Hooks only.
- Routing / data layer / build tooling are framework responsibilities (Next.js, Remix etc.); React-level APIs described here.
- Prefer Server Components and Actions when the framework supports them.

---

## 1. Packages and entry points

**Packages**

- `react`
  - Hooks
  - Built-in components (`Fragment`, `StrictMode`, `Suspense`, `Activity`, etc.)
  - Core APIs (`createContext`, `lazy`, `memo`, `startTransition`, `cache`, `use`, etc.).
- `react-dom`
  - DOM-specific components (`<form>`, `<input>`, `<textarea>`, `<link>`, `<meta>`, `<script>`, etc.).
  - DOM APIs (`createPortal`, `flushSync`, resource preloading).
- `react-dom/client`
  - `createRoot(container)`, `hydrateRoot(container, element, options?)`.
- `react-dom/server`
  - Streaming and non-streaming render: `renderToReadableStream`, `renderToPipeableStream`, `renderToString`, `renderToStaticMarkup`, `resume`, `resumeToPipeableStream`.
- `react-dom/static`
  - Static HTML generation: `prerender`, `prerenderToNodeStream`, `resumeAndPrerender`, `resumeAndPrerenderToNodeStream`.

**Removed in React 19 (do not use)**

- `ReactDOM.render`
- `ReactDOM.hydrate`
- `ReactDOM.unmountComponentAtNode`
- `ReactDOM.findDOMNode`
- `renderToNodeStream`, `renderToStaticNodeStream` (server).

Use `createRoot`, `hydrateRoot`, `root.unmount()`, and the new `react-dom/server` and `react-dom/static` APIs instead.

---

## 2. Rules of React (for Hooks, Compiler, and RSC)

Agents must always respect these rules:

- Components and Hooks must be pure:
  - No side effects in render.
  - No mutation of props.
  - No non-deterministic output based on global state.
- React calls Components and Hooks:
  - Never call React Components or Hooks like regular functions.
  - React controls render timing, frequency, and interleaving.
- Rules of Hooks:
  - Only call Hooks at the top level of React function components or custom Hooks.
  - Never call Hooks in loops, conditions, or nested functions.
  - Maintain stable call order across renders.
- Side effects:
  - Use `useEffect`, `useLayoutEffect`, or `useInsertionEffect` for side effects.
  - Use `useEffectEvent` to isolate non-reactive logic inside effects without expanding dependency arrays.
- Data fetching and async behavior:
  - For RSC or frameworks with RSC, prefer `async` Server Components and `use` to read Promises.
  - On the client, prefer framework data primitives; use Suspense only where supported and configured.

---

## 3. Core Hooks (React 19+) overview

Only list Hooks that matter for modern React. Grouped by purpose.

### 3.1 State and reducers

- `useState(initialState)`
  - Local reactive state. Use for simple component-owned values.
- `useReducer(reducer, initialArg, init?)`
  - Use for complex state transitions or when you need explicit state machines.

### 3.2 Effects and external systems

- `useEffect(setup, deps?)`
  - Synchronise with external systems: subscriptions, event listeners, timers, non-blocking data fetches.
- `useLayoutEffect(setup, deps?)`
  - Like `useEffect`, but fires after layout and before paint. Use only when reading layout and synchronously mutating DOM.
- `useInsertionEffect(setup, deps?)`
  - For CSS-in-JS libraries inserting styles before layout. Rare in app code.

### 3.3 Effect Events (new)

- `useEffectEvent(callback)`
  - Declare an “Effect Event” function that:
    - Always sees the latest props and state.
    - Can be called from `useEffect`, `useLayoutEffect`, or `useInsertionEffect`.
    - Does not itself become a dependency.
  - Use to:
    - Avoid stale closures in effects.
    - Keep dependency arrays minimal while still reading latest values.
  - Constraints:
    - Call only inside components at top level.
    - Use the returned function only inside effects, not passed around.

### 3.4 Performance and concurrency

- `useTransition() -> [isPending, startTransition]`
  - Mark state updates as non-urgent. UI stays responsive while React prepares new UI in the background.
  - Use for navigation, large list filtering, results views, etc.
- `useDeferredValue(value)`
  - Keep a “lagging” version of a value. Use when expensive derived UI should update later than immediate inputs.
- `useMemo(factory, deps)`
  - Compute expensive derived values. In React 19, often unnecessary when React Compiler is enabled, but still useful:
    - For referential equality guarantees (e.g. dependency arrays, context values).
    - When compiler is not enabled or cannot optimise the code.
- `useCallback(fn, deps)`
  - Memoise callbacks passed to children, especially when those children rely on referential equality.
- `useSyncExternalStore(subscribe, getSnapshot, getServerSnapshot?)`
  - For connecting React to external stores (e.g. Zustand, custom stores) in a concurrent-safe way.

### 3.5 References and imperative handles

- `useRef(initialValue)`
  - Mutable container that survives re-renders. Use for:
    - DOM refs (`<div ref={ref}>`).
    - Instance-like mutable values that must not trigger renders.
- `useImperativeHandle(ref, createHandle, deps?)`
  - Customise the instance exposed via `ref` when using `forwardRef`.

### 3.6 Identity / misc

- `useId()`
  - Generate stable IDs across server and client. In React 19, IDs use underscore (`_`) separator to be URL and CSS friendly.
- `useDebugValue(value, formatFn?)`
  - Improve DevTools display for custom Hooks.

---

## 4. New state and Actions APIs

Modern React 19+ introduces built-in primitives for Actions and optimistic UI.

### 4.1 Actions, Forms, and `useActionState`

**Concept**

- An “Action” is an async function that mutates server or local state and is wired directly to UI events or `<form>` submissions.
- Frameworks map Actions to endpoints or Server Functions; React gives local APIs to track their state.

**`useActionState(action, initialState, permalink? )`**

- Replaces most ad-hoc “submit + loading + error” handlers.
- Signature (conceptual):

    const [state, dispatchAction, isPending] = useActionState(action, initialState);

- Usage pattern:
  - `state`: latest result or status object returned from `action`.
  - `dispatchAction(formDataOrArgs)`: call inside `<form action={dispatchAction}>` or manually from event handlers.
  - `isPending`: whether the last call is still in flight.
- Recommended pattern:
  - Create a reducer-like `action` that receives current state and form data or args.
  - Return next state (for UI) or throw errors to be handled by error boundaries or frameworks.

### 4.2 `useOptimistic` for optimistic UI

- Signature (conceptual):

    const [optimisticState, addOptimisticUpdate] = useOptimistic(
      sourceState,
      optimisticReducer
    );

- Use for:
  - Showing optimistic results (e.g. optimistic list insertion, toggling like buttons) while async work runs.
- Pattern:
  - `sourceState`: actual state (e.g. from props, server data, or `useActionState`).
  - `optimisticReducer(currentOptimistic, payload)`: returns next optimistic state.
  - Call `addOptimisticUpdate(payload)` right before you trigger an async Action.

### 4.3 `useFormStatus` (react-dom)

- Hook to inspect the status of the closest parent `<form>` using Actions.
- Only valid inside components rendered within a `<form>`.
- Gives access to:
  - `pending`: whether the form is currently submitting.
  - `data`: last submitted `FormData` (framework dependent).
  - `method` / `action` etc. (where supported).
- Use to:
  - Disable submit buttons.
  - Show “Saving…” / progress indicators.
  - Reflect submission state on a per-form basis.

---

## 5. Data fetching and Suspense with `use` and cache

### 5.1 `use(promiseOrResource)`

- React 19 `use` lets you read:
  - A `Promise` (data fetching, async computation).
  - A context value (in some advanced patterns).
- Behavior:
  - If the Promise is pending:
    - The component will suspend.
    - React will show the nearest `<Suspense fallback>` until it resolves.
  - If it resolves:
    - `use` returns the value.
  - If it rejects:
    - The nearest error boundary handles the error.
- Patterns:
  - Server Components:
    - Call `await fetch(...)` directly in an async Server Component.
    - Or wrap data fetchers with `cache` and call them with `await`.
  - Client Components:
    - Typically let your framework or data library (TanStack Query, etc.) handle fetching.
    - Use `use` only if your environment explicitly supports Suspense-based data fetching on the client.

### 5.2 `cache(fn)` (Server Components)

- `cache(fn)` memoises the result of `fn(...args)` per “render lifetime” on the server.
- Only valid in React Server Components or server-side environment.
- Typical pattern:

    import { cache } from 'react';

    const fetchUser = cache(async (id) => {
      const res = await fetch(`https://api/app/users/${id}`);
      if (!res.ok) throw new Error('Failed');
      return res.json();
    });

    async function UserProfile({ id }) {
      const user = await fetchUser(id);
      return <div>{user.name}</div>;
    }

- Guidelines:
  - Call `cache` at module scope, not inside components.
  - Use for data fetches or expensive pure computations that can be reused within the same request / streaming render.

### 5.3 `cacheSignal()` (Server Components)

- `cacheSignal()` returns an `AbortSignal` tied to the lifetime of the cached computation.
- Typical pattern:

    import { cache, cacheSignal } from 'react';

    const dedupedFetch = cache((url) =>
      fetch(url, { signal: cacheSignal() })
    );

- Use to:
  - Cancel in-flight requests when a render is aborted or finishes.
  - Avoid wasted work in long-running or expensive tasks.
- In client components, `cacheSignal()` currently returns `null` and should not be relied upon.

---

## 6. Built-in components (modern)

Only list components that carry new semantics:

### 6.1 `<Suspense>`

- Wraps children that may suspend (`use`, `lazy`, data libraries).
- Shows `fallback` while suspended.
- Supports nested Suspense boundaries for granular loading states.

### 6.2 `<Activity>`

- `<Activity mode="visible" | "hidden">` wraps an “activity” area of the UI.
- `mode="visible"`:
  - Renders children normally.
- `mode="hidden"`:
  - Hides children using `display: "none"`.
  - Preserves state.
  - Destroys Effects and subscriptions while hidden.
  - Continues to re-render children at lower priority when props change.
- Use cases:
  - Tabs, sidebars, panels that should keep their state when hidden.
  - Pre-rendering likely-next screens in the background.
  - Reducing side effects and performance impact of hidden UIs.

### 6.3 `<StrictMode>`

- Development-only tree wrapper that:
  - Intentionally double-invokes certain lifecycle paths to surface side-effect bugs.
  - Integrates with React Compiler and new lint rules for purity.

### 6.4 `<Profiler>`, `<Fragment>`, experimental `<ViewTransition>`

- `<Fragment>`: structural grouping without extra DOM.
- `<Profiler>`: measure rendering performance around a subtree.
- `<ViewTransition>` (canary/experimental): coordinate browser View Transitions; only use where explicitly supported by environment.

---

## 7. React DOM APIs (web-specific)

### 7.1 Rendering

- `createRoot(container, options?)`:
  - Creates a concurrent root.
  - Use `root.render(<App />)` to render.
- `hydrateRoot(container, element, options?)`:
  - Hydrate server-rendered HTML.

### 7.2 Portals and sync flush

- `createPortal(children, domNode)`:
  - Render `children` into a different part of the DOM (modals, tooltips).
- `flushSync(callback)`:
  - Force React to flush state updates synchronously (rare).
  - Use only for interop with imperative libraries that need DOM to be updated immediately.

### 7.3 Resource preloading APIs

Use to hint to the browser about future resources:

- `prefetchDNS(domain)`
  - Resolve DNS early.
- `preconnect(url)`
  - Open TCP/TLS connection early.
- `preload(href, options)`
  - Preload assets (stylesheets, fonts, images, scripts).
- `preloadModule(src, options)`
  - Preload JS modules.
- `preinit(href, options)`
- `preinitModule(src, options)`
  - Pre-init scripts or styles so they execute / apply early.

Prefer framework-level abstractions; use these directly mainly in custom frameworks or performance-sensitive shells.

---

## 8. React Server Components and Server Functions

### 8.1 Server vs Client components

- Server Component:
  - Runs only on the server.
  - Can be `async` and directly `await` data fetches.
  - Cannot use client-only Hooks (`useState`, `useEffect` etc.).
  - Output is serialized and streamed to the client as data, not JS.
- Client Component:
  - Runs in the browser.
  - Uses `useState`, `useEffect`, DOM APIs, browser-only APIs.
  - Must be explicitly marked with the `'use client'` directive at the top of the file.

### 8.2 Directives

- `'use client'`:
  - At top of file.
  - Marks the file (and its exports) as client components.
- `'use server'`:
  - Marks a function or a module as containing Server Functions / Actions.
  - Rules:
    - Directive must be at the start of file or at the top of an async function body.
    - Only server code can contain `'use server'` (no browser-only APIs).
    - Arguments and return values must be serializable.
  - Usage patterns:
    - Server Functions passed to Client Components as props.
    - Server Functions used as `<form action={myServerFunction}>` targets.
    - Imported directly into Client Components (framework bridges calls to server).

### 8.3 Server Functions and Actions

- Server Function:
  - An async function marked with `'use server'`.
  - Called from Client Components or forms.
  - Runs on the server, can access databases, secrets, file system.
- Data flow:
  - Client passes serializable args.
  - React serializes call, sends to server, runs function, serializes result.
- Best practices:
  - Keep Server Functions small and composable.
  - Validate inputs server-side.
  - Avoid returning huge payloads; paginate / slice data.
  - Handle errors with server-side try/catch and meaningful messages or typed errors your client can interpret.

---

## 9. React Compiler (optional but important)

React Compiler is an opt-in build-time tool that automatically memoises components and hooks.

### 9.1 What it does

- Analyses component and Hook code at build time.
- Automatically:
  - Tracks reactive dependencies.
  - Skips recomputation when inputs did not change.
  - Reduces the need for manual `useMemo`, `useCallback`, and `React.memo`.
- Integrates with:
  - Babel plugin (`babel-plugin-react-compiler`).
  - Tooling like Next.js, Nx, Expo, Vite, etc. via their configs.

### 9.2 Writing compiler-friendly code

Agents should:

- Keep components pure:
  - Avoid reading/writing globals in render.
  - Do not mutate props, state, or context.
- Keep dependencies explicit:
  - Derive values from props, state, and context, not random globals.
- Keep Hook usage static:
  - No conditional Hook calls.
  - No dynamic Hook arrays or indexing.
- Avoid sneaky side-effects:
  - No `fetch` in render on the client.
  - No `localStorage`, `document`, or `window` access in render.
- Use directives when needed:
  - `"use memo"`: force compiler to memoise even when uncertain.
  - `"use no memo"`: opt out of memoisation in a function or block.

### 9.3 ESLint integration

- Use the official `eslint-plugin-react-hooks` with the new rules:
  - `rules-of-hooks`
  - `exhaustive-deps`
  - Additional rules for:
    - purity
    - refs
    - immutability
    - static-components
    - compiler gating
- For an agent:
  - Assume code must pass these rules; avoid patterns that would trigger them.

---

## 10. Patterns and conventions for agents

### 10.1 Component design

- Prefer many small components over large ones.
- Lift state up only when multiple components need it.
- Use controlled components for inputs where you need React state; otherwise uncontrolled with refs is fine.
- Keep client components minimal:
  - Heavy data logic in Server Components or server Actions.
  - Minimal state and effects in Client Components.

### 10.2 Context and external state

- Use `createContext` / `useContext` for:
  - Cross-cutting concerns (theme, auth, routing state).
  - Not for arbitrary data passing; prefer props.
- For global state with external stores:
  - Use `useSyncExternalStore` or library-specific Hooks.
  - Keep store updates immutable.

### 10.3 Error handling and boundaries

- Use Error Boundaries (class or framework-provided) around:
  - Suspense trees with `use`.
  - Server Functions that may reject.
  - Complex interactive UIs.
- For async errors in Actions:
  - Throw from the Action and let framework error routes / boundaries handle them.
  - Or return structured error objects and handle in UI.

### 10.4 Accessibility and semantics

- Always prefer semantic HTML elements (`button`, `a`, `form`, `label`) with proper attributes.
- Keep keyboard interactions explicit:
  - `onClick` plus `onKeyDown` where appropriate.
- Ensure labels and IDs match, using `useId` or explicit IDs.

---

## 11. Legacy and discouraged APIs

Agents should avoid introducing new code using these:

- `Component`, `PureComponent`, `createClass`, mixins.
- Legacy context API (`childContextTypes`).
- `ReactDOM.render`, `ReactDOM.hydrate`, `ReactDOM.unmountComponentAtNode`, `ReactDOM.findDOMNode`.
- `UNSAFE_*` lifecycle methods.
- Direct DOM mutations outside refs or effect interop code.
- New manual memoisation patterns that fight the Compiler unless strictly necessary.

---

## 12. Minimal agent checklist

When generating or modifying React 19+ code, always:

1. Use function components with Hooks only.
2. Respect the Rules of Hooks and purity.
3. Prefer:
   - Actions (`useActionState`, `useFormStatus`) for mutations.
   - `useOptimistic` for optimistic updates.
   - `useEffectEvent` to avoid stale closures in effects.
4. Use `use` and `cache` only in server-side or framework-supported Suspense data flows.
5. Use `<Activity>` instead of manual show/hide logic when you need to preserve state and avoid side effects in hidden UI.
6. Target `createRoot` / `hydrateRoot` for mounting.
7. Generate compiler-friendly code; avoid patterns that break React Compiler.
8. Do not introduce new legacy APIs or class components.