---
name: route
description: "DEPRECATED: Use /build instead. The /build command includes routing analysis AND actual execution."
---

# /route is Deprecated

**This command has been replaced by `/build`.**

`/build` includes the same 5-dimension scoring framework and routing logic as `/route`, plus it actually executes the work using orchestration tools (Task, TeamCreate, SendMessage).

## Migration

| Old Command | New Command |
|-------------|-------------|
| `/route <task>` | `/build <task>` |

`/build` will analyze the task, recommend a strategy (just like `/route` did), and then execute it after your approval. If execution tools are unavailable, `/build` falls back to outputting a static prompt — exactly what `/route` used to do.

## Quick Start

```
/build <your task description>
```

That's it. `/build` handles everything `/route` did and more.
