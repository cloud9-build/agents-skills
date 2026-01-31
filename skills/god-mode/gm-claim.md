---
name: gm-claim
description: Claim a GSD plan for this terminal to work on. Updates assignments.md, locks relevant files, and begins execution.
---

# /gm-claim [plan]: Claim a Plan

## Trigger
User runs `/gm-claim 01-02` or `/gm-claim PLAN-01-02`.

## Arguments
- `[plan]` — Plan ID to claim (e.g., `01-02` or `PLAN-01-02`)
- `--force` — Override existing claim (use with caution)
- `--resume` — Resume previously claimed work

## Purpose
Assign a specific plan to this terminal for execution. Prevents other terminals from working on the same plan.

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
This terminal is already working on PLAN-01-01.

Options:
1. Complete current plan first
2. Release current plan: /gm-release 01-01
3. Force switch (may lose progress): /gm-claim 01-02 --force
```

### Step 2: Check Plan Availability
1. Read `.planning/phases/[phase]/PLAN-[id].md`
2. Verify plan exists
3. Check `assignments.md` for existing claims
4. Check wave prerequisites

**If plan doesn't exist:**
```
Plan 01-05 not found.

Available plans in Phase 01:
- PLAN-01-01: Database Schema (claimed by gm-001)
- PLAN-01-02: User Auth (available)
- PLAN-01-03: API Routes (available)

Run /gm-parallel to see full breakdown.
```

**If already claimed:**
```
PLAN-01-02 is already claimed by Session gm-002.

Options:
1. Choose different plan: /gm-parallel
2. Take over (if session stale): /gm-claim 01-02 --force

Session gm-002 status: Active (last ping 5m ago)
```

**If wave not ready:**
```
PLAN-01-04 is in Wave 2.

Wave 1 is still in progress:
- PLAN-01-01: in_progress (gm-001)
- PLAN-01-02: in_progress (gm-002)

Wait for Wave 1 to complete before claiming Wave 2 plans.
```

### Step 3: Claim the Plan
1. Update `assignments.md`:
   ```markdown
   | 01-02 | 1 | gm-004 | claimed | [timestamp] |
   ```

2. Update `sessions.md`:
   ```markdown
   | gm-004 | Terminal 4 | 01-02 | in_progress | [now] | [now] |
   ```

3. Lock files (from plan's expected file changes):
   ```markdown
   ## File Locks
   | src/auth/login.ts | gm-004 | [now] | 01-02 |
   | src/auth/register.ts | gm-004 | [now] | 01-02 |
   ```

### Step 4: Begin Execution
Output confirmation and start:

```
Claimed PLAN-01-02: User Authentication

Session: gm-004
Wave: 1
Files locked:
  - src/auth/login.ts
  - src/auth/register.ts

Starting execution...

---

[GSD executor output for the plan]
```

### Step 5: Execute via GSD
Call GSD's internal executor with the specific plan:
- Read PLAN-01-02.md for tasks
- Execute each task
- Update progress in STATE.md
- Commit changes atomically

### Step 6: On Completion
When plan execution finishes:

1. Update `assignments.md` status to `complete`
2. Update `sessions.md` with completion time
3. Release file locks
4. Output summary:

```
PLAN-01-02 complete.

Summary:
- Tasks completed: 5/5
- Files modified: 2
- Commits: 3
- Duration: 15m

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

Warning: Forcing claim on PLAN-01-02

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

Resuming previous work on PLAN-01-02...

Previous progress:
- Tasks completed: 3/5
- Last task: "Create login endpoint"
- Last commit: abc123 "Add login route"

Continuing from Task 4: "Add session management"

[Execution continues]
```

## Error Handling

**If execution fails:**
```
Error during PLAN-01-02 execution.

Task 3 failed: Create login endpoint
Error: TypeScript compilation error

Options:
1. Debug and retry: Review error, fix, run /gm-claim 01-02 --resume
2. Mark as blocked: /gm-block 01-02 "Compilation error in auth module"
3. Release for others: /gm-release 01-02
```

**If conflict detected:**
```
Conflict detected while working on PLAN-01-02.

File: src/api/routes.ts
Another session modified this file.

Options:
1. Pause and sync: /gm-sync
2. Continue (resolve later)
3. Abort: /gm-release 01-02
```
