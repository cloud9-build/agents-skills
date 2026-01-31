---
name: gm-restore
description: Restore context for a new Claude session by reading both GSD's STATE.md and God Mode's parallel session tracking. Enables seamless continuation across sessions.
---

# /gm-restore: Restore Session Context

## Trigger
User runs `/gm-restore` at the start of a new session.

## Purpose
Give a new Claude session complete awareness of:
- GSD project state (from STATE.md)
- Parallel session state (from sessions.md)
- What this terminal was working on
- What other terminals are doing
- What to do next

## Process

### Step 1: Read GSD State
Read `.planning/STATE.md`:
- Current phase and milestone
- Overall progress
- Recent activity
- Any blockers

If missing, error:
```
No GSD project found.
Run /gsd:new-project to create a project first.
```

### Step 2: Read Parallel State
Read `.planning/parallel/sessions.md`:
- Active sessions
- Plan assignments
- Last activity times
- Session statuses

If missing, suggest:
```
God Mode not initialized for this project.
Run /gm to initialize parallel coordination.
```

### Step 3: Identify This Session
Check if this terminal has an existing session:

**Returning session:**
```
Welcome back, Session gm-001.

Last activity: 2 hours ago
You were working on: PLAN-01-02 (User Authentication)
Status when you left: in_progress (60% complete)
```

**New session:**
```
New session detected.
Assigned Session ID: gm-004

No previous work in this terminal.
```

### Step 4: Analyze Current State

**Project Overview:**
```markdown
## Project: [NAME]
**Phase:** 2 of 4
**Overall Progress:** 45%

## Current Phase: 02 - Core Features
**Plans:** 5
**Complete:** 2
**In Progress:** 2
**Waiting:** 1
```

**Parallel Status:**
```markdown
## Active Sessions

| Session | Terminal | Plan | Status | Activity |
|---------|----------|------|--------|----------|
| gm-001 | Terminal 1 | 02-01 | in_progress | 5m ago |
| gm-002 | Terminal 2 | 02-02 | complete | 10m ago |
| gm-003 | Terminal 3 | 02-03 | in_progress | 2m ago |
| gm-004 | This terminal | - | idle | just now |

## Wave Status
- Wave 1: Complete (2/2 plans)
- Wave 2: In progress (1/2 plans complete)
- Wave 3: Waiting
```

### Step 5: Generate Recommendations

**If this session had incomplete work:**
```
## Recommended Action

Resume your previous work on PLAN-01-02.

To continue:
1. Review where you left off: /gm-status
2. Resume execution: /gm-claim 01-02 --resume

Or start fresh:
1. Release old claim: /gm-release 01-02
2. See available work: /gm-parallel
```

**If this is a new session:**
```
## Recommended Action

Available plans in current wave:
- PLAN-02-04: API Integration (unclaimed)

To claim and start:
/gm-claim 02-04

Or see all options:
/gm-parallel
```

**If all work assigned:**
```
## Recommended Action

All plans in current wave are assigned.

Options:
1. Wait for a plan to become available
2. Help with conflict resolution: /gm-sync
3. Verify completed work: /gm-guard
```

**If phase complete:**
```
## Recommended Action

Phase 2 complete. Ready for Phase 3.

To start Phase 3:
/gm-phase 3

Or verify Phase 2 first:
/gm-guard 2
```

### Step 6: Update Session Tracking

1. Register or update this session in `sessions.md`
2. Update "Last Ping" timestamp
3. Log restoration in session history

### Step 7: Output Full Summary

```markdown
# Session Restored

## Project Overview
**Name:** [from PROJECT.md]
**Goal:** [from PROJECT.md]

## GSD State
**Milestone:** [current]
**Phase:** [N] of [Total] - [Name]
**Progress:** [X]%

## Parallel State
**Active Sessions:** [N]
**Your Session:** gm-004 (new/returning)
**Your Assignment:** [plan or none]

## Recent Activity
[Last 5 entries from combined STATE.md and sessions.md]

## Where You Left Off
**Previous:** [task or "New session"]
**Current:** [status]

## Recommended Action
[Specific next step based on state]

---

Ready to continue. What would you like to do?
- /gm-parallel — See parallelizable work
- /gm-claim [plan] — Claim a plan
- /gm-status — Full status overview
- /gm-sync — Check for conflicts
```

## Quick Restore Format

For rapid orientation, also output condensed state:

```
PROJECT: My App
PHASE: 2/4 Core Features (45%)
SESSION: gm-004 (new)
ACTIVE: 3 sessions, 2 plans in progress
WAVE: 2 (1/2 complete)
NEXT: /gm-claim 02-04 or /gm-parallel
```

## Handling Stale Sessions

If detecting stale sessions (no ping > 30m):
```
## Warning: Stale Sessions Detected

Session gm-002 has been inactive for 45 minutes.
Plan 02-02 may be abandoned.

Options:
1. Wait for session to return
2. Take over: /gm-claim 02-02 --force
3. Release for others: /gm-release 02-02
```

## Handling Migration

If old `.gm/` directory detected:
```
## Legacy God Mode Detected

Found old .gm/ directory from standalone God Mode.

God Mode now integrates with GSD for parallel coordination.

To migrate:
1. Your project data is in .planning/ (GSD)
2. Session data is now in .planning/parallel/
3. Old .gm/ files are no longer used

Safe to delete: rm -rf .gm/
```
