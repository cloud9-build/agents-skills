---
name: gm-status
description: Show all active sessions and their assignments. Overview of parallel execution state across all terminals.
---

# /gm-status: Show Parallel Execution Status

## Trigger
User runs `/gm-status`.

## Purpose
Display comprehensive overview of:
- All active terminal sessions
- Plan assignments
- Wave progress
- File locks
- Potential issues

## Process

### Step 1: Read All State Files
1. `.planning/STATE.md` — GSD project state
2. `.planning/parallel/sessions.md` — Session tracking
3. `.planning/parallel/assignments.md` — Plan assignments
4. `.planning/parallel/conflicts.md` — Locks and conflicts
5. `.planning/phases/[current]/PLAN-*.md` — Plan frontmatter

### Step 2: Generate Status Report

```markdown
# Parallel Execution Status

**Project:** [Name]
**Updated:** [timestamp]

---

## Project Progress

| Metric | Value |
|--------|-------|
| Milestone | v1.0 |
| Phase | 2 of 4 (Core Features) |
| Overall | 45% complete |

---

## Session Overview

### Active Sessions (3)

| Session | Terminal | Plan | Status | Duration | Last Ping |
|---------|----------|------|--------|----------|-----------|
| gm-001 | Term 1 | 02-01 | in_progress | 25m | 2m ago |
| gm-002 | Term 2 | 02-02 | complete | 18m | 5m ago |
| gm-003 | Term 3 | 02-03 | in_progress | 12m | 1m ago |
| **gm-004** | **This** | - | idle | - | now |

### Session Details

**gm-001** (Terminal 1)
- Plan: PLAN-02-01 - API Authentication
- Progress: 3/5 tasks (60%)
- Current task: "Implement JWT validation"
- Files locked: `src/auth/*.ts`

**gm-002** (Terminal 2)
- Plan: PLAN-02-02 - Database Models
- Status: Complete
- Duration: 18 minutes
- Ready to claim new work

**gm-003** (Terminal 3)
- Plan: PLAN-02-03 - User Service
- Progress: 2/4 tasks (50%)
- Current task: "Add user CRUD operations"
- Files locked: `src/services/user.ts`

---

## Wave Progress

### Phase 02: Core Features

| Wave | Plans | Complete | In Progress | Waiting |
|------|-------|----------|-------------|---------|
| 1 | 3 | 1 | 2 | 0 |
| 2 | 2 | 0 | 0 | 2 |

**Wave 1 Status:** 33% complete (1/3)
- PLAN-02-01: in_progress (gm-001)
- PLAN-02-02: complete (gm-002)
- PLAN-02-03: in_progress (gm-003)

**Wave 2 Status:** Waiting for Wave 1
- PLAN-02-04: waiting (unclaimed)
- PLAN-02-05: waiting (unclaimed)

---

## Plan Assignments

| Plan | Title | Wave | Assigned | Status |
|------|-------|------|----------|--------|
| 02-01 | API Authentication | 1 | gm-001 | in_progress |
| 02-02 | Database Models | 1 | gm-002 | complete |
| 02-03 | User Service | 1 | gm-003 | in_progress |
| 02-04 | Frontend Integration | 2 | - | waiting |
| 02-05 | Error Handling | 2 | - | waiting |

---

## File Locks

| File | Locked By | Plan | Duration |
|------|-----------|------|----------|
| src/auth/jwt.ts | gm-001 | 02-01 | 25m |
| src/auth/middleware.ts | gm-001 | 02-01 | 25m |
| src/services/user.ts | gm-003 | 02-03 | 12m |

No conflicts detected.

---

## Recent Activity

| Time | Session | Action |
|------|---------|--------|
| 2m ago | gm-001 | Completed task "Create auth routes" |
| 5m ago | gm-002 | Plan 02-02 complete |
| 8m ago | gm-003 | Started task "Add user CRUD" |
| 12m ago | gm-003 | Claimed PLAN-02-03 |
| 18m ago | gm-002 | Claimed PLAN-02-02 |

---

## Recommendations

### For This Terminal (gm-004)

You're currently idle. Options:
1. **Claim available work:** `/gm-claim 02-02` (gm-002 finished, can help Wave 1)
2. **Wait for Wave 2:** Wave 1 almost done, Wave 2 will have 2 plans
3. **Help verify:** `/gm-guard` to check completed work

### For All Terminals

- Wave 1 is 67% complete
- Estimated time to Wave 2: ~10 minutes
- No blockers detected

---

## Quick Actions

```
/gm-claim [plan]  — Claim a plan for this terminal
/gm-parallel      — See parallelizable work
/gm-sync          — Check for conflicts
/gm-guard         — Verify completed work
```
```

### Step 3: Highlight Issues

If problems detected, add warnings section:

```markdown
---

## Warnings

### Stale Session Detected
Session **gm-005** has been inactive for 45 minutes.
- Last plan: PLAN-02-06
- Status: in_progress
- Last ping: 45m ago

Consider: `/gm-release 02-06` to free the plan

### File Conflict Risk
Sessions gm-001 and gm-003 may both need `src/api/index.ts`
- Currently locked by: Neither
- Risk: Merge conflict if both modify

Recommendation: Coordinate before modifying shared files

### Wave Blockage
Wave 2 cannot start until:
- PLAN-02-01 completes (currently 60%)
- PLAN-02-03 completes (currently 50%)

Estimated wait: ~15 minutes
```

## Compact Mode

For quick overview, support `/gm-status --compact`:

```
STATUS: Phase 2/4 (45%)
SESSIONS: 4 active, 1 idle (this)
WAVE 1: 1/3 complete, 2 in progress
WAVE 2: waiting (2 plans)
YOUR TURN: /gm-claim 02-04 when Wave 2 ready
```

## JSON Output

For automation, support `/gm-status --json`:

```json
{
  "project": "My App",
  "phase": 2,
  "sessions": [
    {"id": "gm-001", "plan": "02-01", "status": "in_progress"},
    {"id": "gm-002", "plan": "02-02", "status": "complete"}
  ],
  "waves": {
    "1": {"total": 3, "complete": 1},
    "2": {"total": 2, "complete": 0, "blocked": true}
  }
}
```
