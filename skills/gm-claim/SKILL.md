---
name: gm-claim
description: Claim a GSD plan for this terminal. Updates assignments.md, registers file locks, then delegates execution to GSD via /gsd:execute-phase.
---

# /gm-claim [plan]: Claim a Plan

## Trigger
User runs `/gm-claim 01-02` or `/gm-claim 01-02-PLAN`.

## Arguments
- `[plan]` — Plan ID to claim (e.g., `01-02` or `01-02-PLAN`, supports decimal phases like `05.1-01`)
- `--force` — Override existing claim (use with caution)
- `--resume` — Resume previously claimed work

## Purpose
Assign a specific plan to this terminal session. God Mode handles the coordination — GSD handles the execution.

## Core Rule

**God Mode is air traffic control. GSD flies the plane.**

`/gm-claim` coordinates (session registration, plan assignment, file locks) then tells the user to run GSD's execution command. It does NOT execute plan tasks directly.

## Process

### Step 1: Verify Prerequisites
1. Check God Mode initialized (`.planning/parallel/` exists)
2. Read `sessions.md` - does this session exist?
3. Read `assignments.md` - is this session already working on something?

If session doesn't exist:
```
Session not registered. Initializing...
Assigned Session ID: gm-004

Continuing with claim...
```

If already working on a plan:
```
This terminal is already working on 01-01-PLAN.

Options:
1. Complete current plan first
2. Release current plan: /gm-release 01-01
3. Force switch (may lose progress): /gm-claim 01-02 --force
```

### Step 2: Check Plan Availability
1. Read `.planning/phases/[phase]/[id]-PLAN.md` (supports decimal phases like `05.1-01-PLAN.md`)
2. Verify plan exists
3. Check `assignments.md` for existing claims
4. Check wave prerequisites

**If plan doesn't exist:**
```
Plan 01-05 not found.

Available plans in Phase 01:
- 01-01-PLAN: Database Schema (claimed by gm-001)
- 01-02-PLAN: User Auth (available)
- 01-03-PLAN: API Routes (available)

Run /gm-parallel to see full breakdown.
```

**If already claimed:**
```
01-02-PLAN is already claimed by Session gm-002.

Options:
1. Choose different plan: /gm-parallel
2. Take over (if session stale): /gm-claim 01-02 --force

Session gm-002 status: Active (last ping 5m ago)
```

**If wave not ready:**
```
01-04-PLAN is in Wave 2.

Wave 1 is still in progress:
- 01-01-PLAN: in_progress (gm-001)
- 01-02-PLAN: in_progress (gm-002)

Wait for Wave 1 to complete before claiming Wave 2 plans.
```

### Step 3: Register the Claim
1. Update `assignments.md`:
   ```markdown
   | 01-02 | 1 | gm-004 | claimed | [timestamp] |
   ```

2. Update `sessions.md`:
   ```markdown
   | gm-004 | Terminal 4 | 01-02 | claimed | [now] | [now] |
   ```

3. Lock files (from plan's expected file changes):
   ```markdown
   ## File Locks
   | src/auth/login.ts | gm-004 | [now] | 01-02 |
   | src/auth/register.ts | gm-004 | [now] | 01-02 |
   ```

### Step 4: Hand Off to GSD

**Do NOT execute the plan directly.** Output the claim confirmation and instruct:

```
Claimed 01-02-PLAN: User Authentication

Session: gm-004
Wave: 1
Files locked:
  - src/auth/login.ts
  - src/auth/register.ts

Run GSD to execute:

  /gsd:execute-phase [phase-number]

GSD handles the full execution pipeline (executor agents, atomic
commits, checkpoints, state updates, SUMMARY.md creation).
```

**Why delegate to GSD?** GSD's execution pipeline handles:
- `gsd-tools.js init` for config loading
- `gsd-executor` subagent spawning with proper prompt templates
- Atomic per-task commits with conventional format
- SUMMARY.md creation with self-check verification
- STATE.md updates via `gsd-tools.js state advance-plan`
- Checkpoint protocol (human-verify, decision, human-action)
- Deviation rules (auto-fix bugs, missing functionality, blocking issues)
- Gap closure cycle (verify → plan gaps → execute gaps)

Reimplementing any of this in God Mode creates divergence and bugs.

### Step 5: After GSD Completes

When GSD finishes (SUMMARY.md exists for the plan), update GM tracking:

1. Update `assignments.md` status to `complete`
2. Update `sessions.md` with completion time
3. Release file locks in `conflicts.md`
4. Output:

```
01-02-PLAN complete (via GSD).

Your session is now idle.

Next steps:
1. Check wave status: /gm-status
2. Claim another plan: /gm-parallel
3. Sync and verify: /gm-sync
```

## Force Mode

With `--force` flag:

```
/gm-claim 01-02 --force

Warning: Forcing claim on 01-02-PLAN

This will:
- Override existing claim by gm-002
- Mark gm-002's work as abandoned
- You take responsibility for any partial work

Proceeding...

[Previous session gm-002 notified via conflicts.md]
```

## Resume Mode

With `--resume` flag:

```
/gm-claim 01-02 --resume

Resuming previous work on 01-02-PLAN...

Previous progress (from SUMMARY.md or git log):
- Last commit: abc123 "Add login route"

Re-registering claim in assignments.md...

Run GSD to continue:

  /gsd:execute-phase [phase-number]

GSD will detect existing progress and resume from the first
incomplete plan.
```

## Error Handling

**If GSD execution fails:**
```
GSD reported an error during 01-02-PLAN execution.

Options:
1. Debug and retry: Review error, run /gsd:execute-phase again
2. Release for others: /gm-release 01-02
3. Check status: /gm-status
```

**If conflict detected:**
```
Conflict detected while working on 01-02-PLAN.

File: src/api/routes.ts
Another session modified this file.

Options:
1. Pause and sync: /gm-sync
2. Continue (resolve later)
3. Abort: /gm-release 01-02
```
