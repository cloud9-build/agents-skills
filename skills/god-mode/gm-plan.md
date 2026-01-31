---
name: gm-plan
description: DEPRECATED - God Mode no longer handles planning. Redirects to GSD's /gsd:plan-phase command.
---

# /gm-plan: Deprecated

## Notice

**This command has been deprecated.**

God Mode is now the parallel session coordinator for GSD, not a standalone planning system.

## What Changed

- **Old behavior:** God Mode created its own `.gm/plan.md` with phases and tasks
- **New behavior:** GSD handles all planning; God Mode coordinates parallel execution

## Use Instead

For planning, use GSD commands:

| Need | Command |
|------|---------|
| Plan a phase | `/gsd:plan-phase` |
| Create a roadmap | `/gsd:new-project` |
| Add a phase | `/gsd:add-phase` |

## For Parallel Execution

After GSD creates plans, use God Mode for parallel coordination:

```
/gm              # Initialize parallel coordination
/gm-parallel     # See which plans can run in parallel
/gm-claim [plan] # Claim a plan for this terminal
/gm-phase [N]    # Execute a phase with coordination
```

## Migration

If you were using `/gm-plan`:

1. Run `/gsd:new-project` to create a GSD project
2. Run `/gsd:plan-phase` to plan phases
3. Run `/gm` to initialize parallel coordination
4. Run `/gm-parallel` to see parallelizable work

## Why This Change?

God Mode and GSD had overlapping functionality:
- Both created plans
- Both tracked progress
- Both had execution logic

Now they have clear responsibilities:
- **GSD:** Planning, execution, verification
- **God Mode:** Multi-terminal coordination

This eliminates duplication and confusion.
