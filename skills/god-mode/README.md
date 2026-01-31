# God Mode

Parallel session coordinator for GSD. Run multiple Claude Code terminals on the same project safely.

## Overview

God Mode is **not** a replacement for GSD. It's the parallel session coordination layer.

| System | Responsibility |
|--------|----------------|
| **GSD** | Plans the work (phases, plans, tasks, waves) |
| **GSD** | Executes the work (agents, commits, summaries) |
| **God Mode** | Coordinates which terminal runs which plan |
| **God Mode** | Tracks session states and prevents conflicts |

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
| `/gm-claim [plan]` | Claim a plan for this terminal |
| `/gm-release [plan]` | Release a claimed plan |
| `/gm-assign [session] [plan]` | Assign plan to another session |
| `/gm-status` | Show all active sessions and assignments |
| `/gm-sync` | Check for conflicts and merge work |
| `/gm-guard` | Verify completion (GSD verify + conflict check) |
| `/gm-restore` | Restore context for new session |

## Quick Start

### Terminal 1 (Coordinator)
```bash
/gm                    # Initialize
/gm-parallel           # See what can run in parallel
/gm-claim 01-01        # Claim first plan
```

### Terminal 2
```bash
/gm                    # Initialize (gets new session ID)
/gm-claim 01-02        # Claim second plan
```

### Terminal 3
```bash
/gm                    # Initialize
/gm-claim 01-03        # Claim third plan
```

### After All Complete
```bash
/gm-sync               # Check for conflicts
/gm-guard              # Verify everything
```

## Directory Structure

God Mode adds `.planning/parallel/` to GSD's structure:

```
.planning/
├── parallel/                    # God Mode's session tracking
│   ├── sessions.md             # Active terminal sessions
│   ├── assignments.md          # Plan → session mappings
│   └── conflicts.md            # File locks and conflicts
├── PROJECT.md                   # GSD (read by God Mode)
├── STATE.md                     # GSD (read by God Mode)
└── phases/                      # GSD (plans read by God Mode)
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

## Best Practices

1. **One plan per terminal** - Don't run multiple plans in one session
2. **Claim before working** - Always `/gm-claim` before starting
3. **Sync frequently** - Run `/gm-sync` after completing work
4. **Respect waves** - Don't skip wave order
5. **Clean exit** - Use `/gm-release` if stopping mid-work

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
