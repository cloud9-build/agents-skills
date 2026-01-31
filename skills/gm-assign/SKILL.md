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

3. Log notification in `conflicts.md`

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
