---
name: gm-phase
description: Analyze a phase's plans and waves, then coordinate parallel terminal assignments. Delegates all execution to GSD's /gsd:execute-phase.
---

# /gm-phase [N]: Coordinate Phase Execution

## Trigger
User runs `/gm-phase 1` or `/gm-phase 2` etc.

## Arguments
- `N` — Phase number to coordinate (required)

## Purpose
Analyze phase structure and coordinate terminal assignments for parallel execution. This command is the **coordinator** — it reads plans, groups by wave, and tells users which terminals should claim which plans. It does NOT execute plans itself.

## Core Rule

**God Mode is air traffic control. GSD flies the plane.**

`/gm-phase` analyzes and coordinates. `/gsd:execute-phase` does the actual execution. God Mode never spawns executor agents or runs plan tasks directly.

## Process

### Step 1: Verify Prerequisites
1. Check `.planning/PROJECT.md` exists — if not, error with GSD setup instructions
2. Check `.planning/parallel/` exists — if not, run `/gm` initialization first
3. Read `.planning/STATE.md` to verify phase N-1 is complete (if N > 1)

### Step 2: Analyze Phase Structure
1. Find all `*-PLAN.md` files in `.planning/phases/[N]-*/` (supports decimal phases like `05.1-01-PLAN.md`)
2. Parse frontmatter for wave assignments
3. Count plans per wave
4. Check current assignments in `assignments.md`

### Step 3: Present Execution Strategy

**Single Plan Phase:**
```
Phase [N] has 1 plan: [plan-name]

No parallel coordination needed. Run directly:

  /gsd:execute-phase [N]
```

**Multi-Plan, Single Wave:**
```
Phase [N] has 3 plans, all in Wave 1.

These can run in parallel across terminals:
- 01-01-PLAN: Database Schema
- 01-02-PLAN: User Authentication
- 01-03-PLAN: API Routes

Options:
1. Sequential — Run /gsd:execute-phase [N] in this terminal (runs all plans one by one)
2. Parallel — Open 3 terminals, each claims one plan

For parallel execution:
  Terminal 1: /gm && /gm-claim 01-01   then   /gsd:execute-phase [N]
  Terminal 2: /gm && /gm-claim 01-02   then   /gsd:execute-phase [N]
  Terminal 3: /gm && /gm-claim 01-03   then   /gsd:execute-phase [N]

After all complete: /gm-sync
```

**Multi-Plan, Multi-Wave:**
```
Phase [N] has 5 plans across 2 waves.

Wave 1 (can run in parallel):
- 01-01-PLAN: Database Schema
- 01-02-PLAN: User Authentication

Wave 2 (after Wave 1 completes):
- 01-03-PLAN: API Integration
- 01-04-PLAN: Frontend Setup
- 01-05-PLAN: Error Handling

Recommended approach:
1. Open 2 terminals for Wave 1 (each claims + runs via GSD)
2. Run /gm-sync after Wave 1 completes
3. Open 3 terminals for Wave 2

Wave 1 terminal commands:
  Terminal 1: /gm && /gm-claim 01-01   then   /gsd:execute-phase [N]
  Terminal 2: /gm && /gm-claim 01-02   then   /gsd:execute-phase [N]
```

### Step 4: Register Coordination State

Update `assignments.md` with the phase overview:

```markdown
## Current Phase: [N] - [Name]

| Plan | Wave | Assigned To | Status |
|------|------|-------------|--------|
| 01-01 | 1 | - | available |
| 01-02 | 1 | - | available |
| 01-03 | 2 | - | waiting (wave 1) |
```

### Step 5: Wave Transition Guidance

After presenting the strategy, remind:

```
After each wave completes:
1. All terminals run /gm-sync to check for conflicts
2. Run /gm-guard to verify completed work
3. If passed, next wave plans become available
4. Claim next wave plans and run /gsd:execute-phase again

After ALL waves complete:
1. Run /gm-guard for full phase verification
2. GSD handles ROADMAP.md and STATE.md updates
3. Check next phase: /gsd:progress
```

## Error Handling

**If prerequisites fail:**
```
Cannot start Phase [N].

Blockers:
- Phase [N-1] not complete (2/4 plans done)
- Run /gm-guard [N-1] to diagnose

Or force start (not recommended):
/gm-phase [N] --force
```

**If session crashes mid-execution:**
```
Session gm-002 appears stale (no activity 30m).

Options:
1. Wait for session to resume
2. Release plan: /gm-release 01-02
3. Take over: /gm-claim 01-02 --force
```

## What This Command Does NOT Do

- Does NOT spawn gsd-executor agents (GSD does that)
- Does NOT run plan tasks (GSD does that)
- Does NOT update STATE.md execution state (GSD does that)
- Does NOT create SUMMARY.md files (GSD does that)
- Does NOT handle checkpoints (GSD does that)

It ONLY reads phase structure and coordinates which terminal works on which plan.
