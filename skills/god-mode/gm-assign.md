---
name: gm-assign
description: Assign a plan to a specific terminal session. Used for coordinating work distribution from a central terminal.
---

# /gm-assign [session] [plan]: Assign Plan to Session

## Trigger
User runs `/gm-assign gm-002 01-03`.

## Arguments
- `[session]` — Session ID to assign to (e.g., `gm-002`)
- `[plan]` — Plan ID to assign (e.g., `01-03` or `PLAN-01-03`)

## Purpose
Centrally coordinate work distribution. One terminal (coordinator) can assign plans to other terminals without them having to choose.

## When to Use

**Use `/gm-assign` when:**
- You're coordinating multiple terminals from one place
- You want to control work distribution
- Assigning work to terminals that haven't claimed anything

**Use `/gm-claim` when:**
- Each terminal picks its own work
- Decentralized self-assignment

## Process

### Step 1: Verify Prerequisites
1. Check God Mode initialized
2. Verify session exists in `sessions.md`
3. Verify plan exists and is available

### Step 2: Check Session State

**If session busy:**
```
Session gm-002 is currently working on PLAN-01-01.

Options:
1. Wait for current work to complete
2. Force reassign: /gm-assign gm-002 01-03 --force
3. Choose different session
```

**If session doesn't exist:**
```
Session gm-002 not found.

Active sessions:
- gm-001 (busy: PLAN-01-01)
- gm-003 (idle)
- gm-004 (idle)

Did you mean gm-003?
```

**If session stale:**
```
Session gm-002 appears stale (last ping 45m ago).

Options:
1. Assign anyway (session may not respond)
2. Choose active session
3. Wait for session to reconnect
```

### Step 3: Check Plan Availability

**If plan doesn't exist:**
```
Plan 01-05 not found.

Available plans:
- PLAN-01-01 (assigned to gm-001)
- PLAN-01-02 (available)
- PLAN-01-03 (available)
```

**If plan already assigned:**
```
PLAN-01-02 is already assigned to gm-003.

Options:
1. Choose different plan
2. Reassign: /gm-assign gm-002 01-02 --force
```

**If wave blocked:**
```
PLAN-01-04 is in Wave 2 (blocked).

Wave 1 must complete first:
- PLAN-01-01: in_progress
- PLAN-01-02: available
- PLAN-01-03: available

Assign an available Wave 1 plan instead.
```

### Step 4: Make Assignment

1. Update `assignments.md`:
   ```markdown
   | 01-03 | 1 | gm-002 | assigned | [timestamp] |
   ```

2. Update `sessions.md`:
   ```markdown
   | gm-002 | Terminal 2 | 01-03 | assigned | - | [now] |
   ```

3. Log in `conflicts.md` (notification):
   ```markdown
   ## Pending Notifications
   | Session | Message | Time |
   |---------|---------|------|
   | gm-002 | Assigned PLAN-01-03 by coordinator | [now] |
   ```

### Step 5: Confirm Assignment

```
Assigned PLAN-01-03 to Session gm-002.

Plan: User Authentication
Wave: 1
Session: gm-002 (Terminal 2)
Status: assigned (waiting for session to start)

Session gm-002 will see this assignment when they:
- Run /gm-status
- Run /gm-restore
- Start any God Mode command

They can start with:
/gm-claim 01-03
```

## Batch Assignment

Assign multiple plans at once:

```
/gm-assign gm-002 01-02, gm-003 01-03, gm-004 01-04

Batch assignment:
- gm-002 → PLAN-01-02: Database Schema
- gm-003 → PLAN-01-03: User Auth
- gm-004 → PLAN-01-04: API Routes (Wave 2 - queued)

Note: PLAN-01-04 will wait for Wave 1 to complete.

Assigned 3 plans. Sessions notified.
```

## Coordinator Mode

For coordinating many terminals:

```
/gm-assign --interactive

Entering coordinator mode...

Current phase: 01 - Foundation
Available plans: 3
Active sessions: 4

Unassigned plans:
1. PLAN-01-02: Database Schema (Wave 1)
2. PLAN-01-03: User Auth (Wave 1)
3. PLAN-01-04: API Routes (Wave 2)

Idle sessions:
- gm-002
- gm-003
- gm-004

Assign plan 01-02 to which session? [gm-002/gm-003/gm-004]: gm-002
Assigned.

Assign plan 01-03 to which session? [gm-003/gm-004]: gm-003
Assigned.

All Wave 1 plans assigned.
Wave 2 plans will auto-queue when Wave 1 completes.

Exit coordinator mode? [y/n]: y

Summary:
- Assigned: 2 plans
- Queued: 1 plan (Wave 2)
```

## Force Assignment

Override existing assignments:

```
/gm-assign gm-002 01-03 --force

Warning: Force assigning PLAN-01-03

This will:
- Remove assignment from gm-001
- Mark gm-001's work as transferred
- Assign to gm-002

gm-001's progress (if any) will need manual recovery.

Proceed? [y/n]: y

Reassigned PLAN-01-03 from gm-001 to gm-002.
```

## Auto-Assign

Let God Mode distribute work automatically:

```
/gm-assign --auto

Auto-assigning available plans to idle sessions...

Wave 1 assignments:
- gm-002 → PLAN-01-02 (random selection)
- gm-003 → PLAN-01-03 (random selection)

Remaining:
- gm-004: idle (no available plans in Wave 1)

Auto-assignment complete.
Sessions notified to begin work.
```

## Error Handling

**If assignment fails:**
```
Failed to assign PLAN-01-03 to gm-002.

Reason: Session gm-002 disconnected during assignment.

Options:
1. Retry: /gm-assign gm-002 01-03
2. Choose different session: /gm-assign gm-003 01-03
3. Let session self-claim when back: Plan remains available
```
