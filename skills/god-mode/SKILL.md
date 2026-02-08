---
name: god-mode
description: Parallel session coordinator for GSD. Run multiple Claude terminals on the same project safely. Use /gm to initialize, /gm-parallel to see parallelizable work, /gm-claim to assign plans to terminals, /gm-status to monitor, /gm-sync to merge.
---

# God Mode: Parallel Session Coordinator for GSD

Coordinate multiple Claude Code terminals working on the same GSD project simultaneously.

## Philosophy

God Mode is NOT a replacement for GSD. It's the parallel session coordination layer.

- **GSD** plans the work (phases, plans, tasks, waves)
- **GSD** executes the work (executor agents, atomic commits, summaries, state updates)
- **GSD** verifies the work (verifier agents, gap closure cycle)
- **God Mode** coordinates WHICH TERMINAL runs WHICH PLAN
- **God Mode** tracks session states and prevents conflicts
- **God Mode** is the "air traffic control" for parallel Claude sessions

**God Mode is air traffic control. GSD flies the plane.**

If you don't need parallel terminals, just use GSD directly.
Use God Mode when you want to run multiple Claude sessions simultaneously.

## Quick Start Commands

| Command | Purpose |
|---------|---------|
| `/gm` | Initialize parallel coordination for a GSD project |
| `/gm-parallel` | Show which plans can run in parallel (by wave) |
| `/gm-claim [plan]` | Register this terminal's claim on a plan |
| `/gm-phase [N]` | Analyze phase and coordinate terminal assignments |
| `/gm-status` | Show all active sessions and their assignments |
| `/gm-sync` | Check for conflicts and reconcile state |
| `/gm-guard` | Verify completion (calls GSD verify + conflict check) |
| `/gm-restore` | Restore context for new session |

## Prerequisite: GSD Project

God Mode requires a GSD project to exist. If you run `/gm` without one:

```
No GSD project found.

Run /gsd:new-project first to create a project, then use God Mode
to coordinate parallel terminals.
```

## Directory Structure

God Mode adds parallel coordination to GSD's existing structure:

```
.planning/
├── parallel/                    # God Mode's session coordination
│   ├── sessions.md             # Active terminal sessions
│   ├── assignments.md          # Which session has which plan
│   └── conflicts.md            # File conflict detection log
├── PROJECT.md                   # GSD's project file (read-only for GM)
├── ROADMAP.md                   # GSD's roadmap (read-only for GM)
├── STATE.md                     # GSD's state (read by GM, written ONLY by GSD)
└── phases/                      # GSD's phase plans
    └── 01-foundation/
        ├── 01-01-PLAN.md        # Has wave: 1 in frontmatter
        ├── 01-02-PLAN.md        # Has wave: 1 in frontmatter
        └── 01-03-PLAN.md        # Has wave: 2 in frontmatter
        # Note: Supports decimal phases like 05.1-01-PLAN.md
```

## When User Runs /gm

Initialize parallel session coordination:

1. Check for `.planning/PROJECT.md` - if missing, output error and suggest `/gsd:new-project`
2. Read `.planning/STATE.md` to understand current project state
3. Create `.planning/parallel/` directory if it doesn't exist
4. Initialize `sessions.md`, `assignments.md`, `conflicts.md`
5. Generate a unique session ID for this terminal (e.g., `gm-001`)
6. Register this session in `sessions.md`
7. Output:
   ```
   God Mode initialized for [PROJECT_NAME]
   Session ID: gm-001

   Current phase: [N] - [Phase Name]
   Plans in phase: [X]
   Parallelizable (same wave): [Y]

   Run /gm-parallel to see which plans can run simultaneously.
   Run /gm-claim [plan] to assign work to this terminal.
   ```

## Session Tracking

### sessions.md Format

```markdown
# Parallel Sessions
**Updated:** [timestamp]

## Active Sessions

| Session ID | Terminal | Plan | Status | Started | Last Ping |
|------------|----------|------|--------|---------|-----------|
| gm-001 | Terminal 1 | 01-01 | in_progress | 2024-01-15 10:00 | 2024-01-15 10:30 |
| gm-002 | Terminal 2 | 01-02 | blocked | 2024-01-15 10:05 | 2024-01-15 10:25 |
| gm-003 | Terminal 3 | - | idle | 2024-01-15 10:10 | 2024-01-15 10:35 |

## Completed Sessions

| Session ID | Plan | Completed | Duration |
|------------|------|-----------|----------|
| gm-003 | 01-03 | 2024-01-15 10:20 | 20m |
```

### assignments.md Format

```markdown
# Plan Assignments
**Updated:** [timestamp]

## Current Phase: 01 - Foundation

| Plan | Wave | Assigned To | Status |
|------|------|-------------|--------|
| 01-01 | 1 | gm-001 | in_progress |
| 01-02 | 1 | gm-002 | in_progress |
| 01-03 | 2 | - | waiting (wave 1 incomplete) |
| 01-04 | 2 | - | waiting (wave 1 incomplete) |

## Assignment Rules
- Wave 1 plans can start immediately
- Wave 2+ plans wait for previous wave completion
- One plan per session at a time
```

### conflicts.md Format

```markdown
# Conflict Detection Log
**Updated:** [timestamp]

## File Locks

| File | Locked By | Since | Plan |
|------|-----------|-------|------|
| src/api/auth.ts | gm-001 | 2024-01-15 10:15 | 01-01 |
| src/db/schema.ts | gm-002 | 2024-01-15 10:20 | 01-02 |

## Detected Conflicts

None currently.

## Resolved Conflicts

| File | Sessions | Resolution | Date |
|------|----------|------------|------|
```

## Wave-Based Parallelism

God Mode reads the `wave` field from GSD's PLAN.md frontmatter:

```yaml
---
phase: 01
plan: 01
title: Database Schema
wave: 1
---
```

**Wave Rules:**
- Plans in the same wave can run in parallel
- Higher waves wait for all lower waves to complete
- Wave 1 plans can start immediately
- Wave 2 plans wait for all wave 1 plans to complete

## Execution Rules

### The Delegation Principle

God Mode NEVER executes plan tasks. The workflow is:

1. **GM coordinates** → claim plan, lock files, register session
2. **GSD executes** → user runs `/gsd:execute-phase` which spawns executor agents
3. **GM tracks** → update assignments, release locks, check for conflicts

### Before Claiming a Plan
1. Read `assignments.md` - is the plan already claimed?
2. Read `sessions.md` - is this session already working on something?
3. Check wave prerequisites - are earlier waves complete?

### After Claiming a Plan (GM does this)
1. Update `assignments.md` with session assignment
2. Update `sessions.md` with status change
3. Lock files that will be modified (in `conflicts.md`)
4. Tell user to run `/gsd:execute-phase` for actual execution

### After GSD Completes a Plan (GM does this)
1. Update `assignments.md` status to complete
2. Update `sessions.md` with completion
3. Release file locks
4. Run `/gm-sync` to check for conflicts
5. If all wave plans complete, notify that next wave can start

### On Any Error or Blocker
1. Update session status to "blocked"
2. Release file locks if abandoning
3. Notify other sessions via `conflicts.md`
4. User can debug, retry via GSD, or release the plan

## STATE.md Concurrency

**Problem:** Multiple sessions running GSD executors write to STATE.md simultaneously via `gsd-tools.js`. Without coordination, one session's writes overwrite another's.

**Solution: Coordinator pattern**

Designate the first session (gm-001) or the `/gm-phase` terminal as the state coordinator:

1. **Executor sessions** run plans and create SUMMARY.md files (GSD does this)
2. **After each plan completes**, the session updates only GM tracking files (`assignments.md`, `sessions.md`)
3. **The coordinator** runs `/gm-sync` to reconcile STATE.md from disk:
   - Counts SUMMARY.md files to determine actual progress
   - Runs `gsd-tools.js state update-progress` to recalculate
   - This is idempotent — safe to run multiple times

**If STATE.md gets out of sync:**
```
/gm-sync will detect and fix:

Expected completed plans (from SUMMARY.md files): 3
STATE.md reports: 2

Running: gsd-tools.js state update-progress
STATE.md reconciled.
```

## Cross-Session Conflict Detection

When `/gm-sync` runs:

1. **Git status check:**
   - Any uncommitted changes?
   - Any merge conflicts?

2. **Branching strategy check:**
   - Read `branching_strategy` from `.planning/config.json`
   - Adapt conflict detection to match (same branch vs feature branches)

3. **File lock check:**
   - Any files locked by multiple sessions?
   - Any files modified outside of locks?

4. **STATE.md consistency check:**
   - Does plan counter match SUMMARY.md count on disk?
   - Reconcile if needed

5. **Plan state check:**
   - Any plans marked complete but SUMMARY.md missing?
   - Any sessions that went silent (stale ping)?

6. **Resolution suggestions:**
   ```
   Conflict detected in src/api/routes.ts

   - Session gm-001 modified lines 50-75
   - Session gm-002 modified lines 60-90

   Options:
   1. Merge manually (git merge)
   2. Keep gm-001's changes (git checkout --ours)
   3. Keep gm-002's changes (git checkout --theirs)
   ```

## Integration with GSD

| God Mode | GSD Integration |
|----------|-----------------|
| `/gm` | Reads `.planning/PROJECT.md`, `.planning/STATE.md` |
| `/gm-parallel` | Reads `wave` from PLAN.md frontmatter |
| `/gm-claim` | Registers claim, then user runs `/gsd:execute-phase` |
| `/gm-phase` | Analyzes plans, coordinates terminals, delegates to `/gsd:execute-phase` |
| `/gm-guard` | Calls `/gsd:verify-work` + parallel conflict check + gap closure routing |
| `/gm-sync` | Reconciles STATE.md, checks GSD branching strategy, detects conflicts |
| `/gm-restore` | Reads GSD's STATE.md + parallel sessions.md |

**What God Mode owns:**
- `.planning/parallel/` directory and all files in it
- Session IDs and lifecycle
- Plan-to-session assignments
- File lock tracking
- Cross-session conflict detection

**What GSD owns (God Mode must NOT touch directly):**
- Plan execution (executor agents, task commits)
- STATE.md writes (via gsd-tools.js)
- SUMMARY.md creation
- VERIFICATION.md creation
- ROADMAP.md updates
- Checkpoint protocol
- Gap closure cycle

## Best Practices

1. **One plan per terminal** - Don't run multiple plans in one session
2. **Claim before working** - Always run `/gm-claim` before starting
3. **Let GSD execute** - Run `/gsd:execute-phase` after claiming, not plan tasks directly
4. **Sync frequently** - Run `/gm-sync` after completing work
5. **Respect waves** - Don't skip wave order even if technically possible
6. **Designate a coordinator** - One terminal handles `/gm-sync` and STATE.md reconciliation
7. **Clean exit** - If stopping, release claims with `/gm-release`

## Typical Parallel Workflow

```
Terminal 1 (Coordinator):
  /gm                          # Initialize
  /gm-phase 2                  # Analyze phase, get terminal assignments
  /gm-claim 02-01              # Claim first plan
  /gsd:execute-phase 2         # GSD executes the plan

Terminal 2:
  /gm                          # Initialize (gets gm-002)
  /gm-claim 02-02              # Claim second plan
  /gsd:execute-phase 2         # GSD executes the plan

Terminal 3:
  /gm                          # Initialize (gets gm-003)
  /gm-claim 02-03              # Claim third plan
  /gsd:execute-phase 2         # GSD executes the plan

After all complete:
  Terminal 1: /gm-sync         # Reconcile state, check conflicts
  Terminal 1: /gm-guard        # Verify via GSD + parallel checks
```

## Migration from Old God Mode

If you have an existing `.gm/` directory from the old God Mode:

```
Detected legacy .gm/ directory.

God Mode now integrates with GSD instead of standalone operation.

To migrate:
1. Run /gsd:new-project to create a GSD project
2. Copy relevant decisions from .gm/decisions.md to project docs
3. Delete .gm/ directory
4. Run /gm to initialize the new parallel coordination
```
