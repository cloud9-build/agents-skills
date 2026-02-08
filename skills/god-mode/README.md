# God Mode

Parallel session coordinator for GSD. Run multiple Claude Code terminals on the same project safely.

## Overview

God Mode is **not** a replacement for GSD. It's the parallel session coordination layer.

**God Mode is air traffic control. GSD flies the plane.**

| System | Responsibility |
|--------|----------------|
| **GSD** | Plans the work (phases, plans, tasks, waves) |
| **GSD** | Executes the work (executor agents, atomic commits, summaries, state updates) |
| **GSD** | Verifies the work (verifier agents, gap closure cycle) |
| **God Mode** | Coordinates which terminal runs which plan |
| **God Mode** | Tracks session states and prevents conflicts |
| **God Mode** | Reconciles state after parallel execution |

If you don't need parallel terminals, just use GSD directly.
Use God Mode when you want to run multiple Claude sessions simultaneously.

## Prerequisites

God Mode requires a GSD project:

```bash
# First, create a GSD project
/gsd:new-project

# Then initialize God Mode
/gm
```

## Commands

| Command | Description |
|---------|-------------|
| `/gm` | Initialize parallel coordination |
| `/gm-parallel` | Show which plans can run in parallel (by wave) |
| `/gm-claim [plan]` | Register this terminal's claim on a plan |
| `/gm-phase [N]` | Analyze phase and coordinate terminal assignments |
| `/gm-release [plan]` | Release a claimed plan |
| `/gm-assign [session] [plan]` | Assign plan to another session |
| `/gm-status` | Show all active sessions and assignments |
| `/gm-sync` | Check for conflicts, reconcile STATE.md |
| `/gm-guard` | Verify completion (GSD verify + conflict check + gap routing) |
| `/gm-restore` | Restore context for new session |

## Quick Start

### Terminal 1 (Coordinator)
```bash
/gm                           # Initialize
/gm-phase 1                   # Analyze phase, get terminal assignments
/gm-claim 01-01               # Claim first plan
/gsd:execute-phase 1           # GSD executes the plan
```

### Terminal 2
```bash
/gm                           # Initialize (gets new session ID)
/gm-claim 01-02               # Claim second plan
/gsd:execute-phase 1           # GSD executes the plan
```

### Terminal 3
```bash
/gm                           # Initialize
/gm-claim 01-03               # Claim third plan
/gsd:execute-phase 1           # GSD executes the plan
```

### After All Complete
```bash
/gm-sync                      # Reconcile state, check conflicts
/gm-guard                     # Verify via GSD + parallel checks
```

## Key Principle: Delegation

God Mode NEVER executes plan tasks directly. The workflow is always:

1. **GM coordinates** — claim plan, lock files, register session
2. **GSD executes** — user runs `/gsd:execute-phase` which spawns executor agents
3. **GM reconciles** — sync state, check conflicts, verify completion

## Directory Structure

God Mode adds `.planning/parallel/` to GSD's structure:

```
.planning/
├── parallel/                    # God Mode's session tracking
│   ├── sessions.md             # Active terminal sessions
│   ├── assignments.md          # Plan → session mappings
│   └── conflicts.md            # File locks and conflicts
├── PROJECT.md                   # GSD (read-only for GM)
├── STATE.md                     # GSD (read by GM, written only by GSD)
└── phases/                      # GSD (plans read by GM)
```

## Wave-Based Parallelism

God Mode reads the `wave` field from GSD's PLAN.md frontmatter:

```yaml
---
phase: 01
plan: 02
title: User Authentication
wave: 1
---
```

- Plans in **same wave** can run in parallel
- Higher waves wait for lower waves to complete
- Wave 1 starts immediately; Wave 2 waits for Wave 1

## STATE.md Concurrency

Multiple sessions running GSD executors can cause STATE.md write conflicts. Solution:

1. Designate one terminal as coordinator
2. Executor sessions create SUMMARY.md files (GSD handles this)
3. Coordinator runs `/gm-sync` to reconcile STATE.md from disk
4. `gsd-tools.js state update-progress` recalculates from SUMMARY.md count

## Best Practices

1. **One plan per terminal** — Don't run multiple plans in one session
2. **Claim before working** — Always `/gm-claim` before starting
3. **Let GSD execute** — Run `/gsd:execute-phase` after claiming
4. **Sync frequently** — Run `/gm-sync` after completing work
5. **Designate a coordinator** — One terminal handles sync and state reconciliation
6. **Respect waves** — Don't skip wave order
7. **Clean exit** — Use `/gm-release` if stopping mid-work

## Migration from Standalone God Mode

If you have an old `.gm/` directory:

```
God Mode now integrates with GSD instead of standalone operation.

To migrate:
1. Run /gsd:new-project to create a GSD project
2. Copy relevant decisions from .gm/decisions.md
3. Delete .gm/ directory
4. Run /gm to initialize the new parallel coordination
```
