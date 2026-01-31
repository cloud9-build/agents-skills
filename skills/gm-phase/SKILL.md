---
name: gm-phase
description: Execute a phase by reading its PLAN.md files, checking waves, and either running a single plan directly or suggesting parallel terminal assignments for multi-wave phases.
---

# /gm-phase [N]: Execute Phase with Parallel Coordination

## Trigger
User runs `/gm-phase 1` or `/gm-phase 2` etc.

## Arguments
- `N` — Phase number to execute (required)

## Purpose
Orchestrate phase execution across multiple terminals:
1. Analyze the phase structure (plans and waves)
2. For single-plan phases: execute directly
3. For multi-plan phases: coordinate parallel execution

## Process

### Step 1: Verify Prerequisites
1. Check `.planning/PROJECT.md` exists - if not, error with GSD setup instructions
2. Check `.planning/parallel/` exists - if not, run `/gm` initialization
3. Read `.planning/STATE.md` to verify phase N-1 is complete (if N > 1)

### Step 2: Analyze Phase Structure
1. Find all `*-PLAN.md` files in `.planning/phases/[N]-*/` (supports decimal phases like `05.1-01-PLAN.md`)
2. Parse frontmatter for wave assignments
3. Count plans per wave
4. Check current assignments in `assignments.md`

### Step 3: Determine Execution Strategy

**Single Plan Phase:**
```
Phase [N] has 1 plan.

Executing directly in this terminal...
[Runs GSD executor for the plan]
```

**Multi-Plan, Single Wave:**
```
Phase [N] has 3 plans, all in Wave 1.

These can run in parallel:
- 01-01-PLAN: Database Schema
- 01-02-PLAN: User Authentication
- 01-03-PLAN: API Routes

Options:
1. Run sequentially in this terminal (slower, simpler)
2. Run in parallel across 3 terminals (faster)

Choice [1/2]:
```

**Multi-Plan, Multi-Wave:**
```
Phase [N] has 5 plans across 2 waves.

Wave 1 (parallel):
- 01-01-PLAN: Database Schema
- 01-02-PLAN: User Authentication

Wave 2 (after Wave 1, parallel):
- 01-03-PLAN: API Integration
- 01-04-PLAN: Frontend Setup
- 01-05-PLAN: Error Handling

Recommended approach:
1. Open 2 terminals for Wave 1
2. After Wave 1 completes, open 3 terminals for Wave 2

Start Wave 1 now? [y/n]:
```

### Step 4: Execute Based on Strategy

**Sequential Execution (single terminal):**
```
Executing Phase [N] sequentially...

[1/3] 01-01-PLAN: Database Schema
      Running /gsd:execute-phase with plan 01-01...
      Complete.

[2/3] 01-02-PLAN: User Authentication
      Running /gsd:execute-phase with plan 01-02...
      Complete.

[3/3] 01-03-PLAN: API Routes
      Running /gsd:execute-phase with plan 01-03...
      Complete.

Phase [N] complete. Run /gm-guard to verify.
```

**Parallel Execution (coordinate terminals):**
```
Parallel execution mode for Phase [N].

This terminal will coordinate. Open additional terminals and run:

Terminal 2: /gm && /gm-claim 01-02
Terminal 3: /gm && /gm-claim 01-03

This terminal claiming 01-01-PLAN...
[Runs GSD executor for plan 01-01]

After all terminals complete, run /gm-sync in any terminal.
```

### Step 5: Wave Transitions

After Wave N completes:
1. Run `/gm-guard` to verify
2. If passed, announce Wave N+1 available:
   ```
   Wave 1 complete. Wave 2 plans now available.

   Run /gm-parallel to see assignments.
   ```

### Step 6: Phase Complete

When all waves done:
1. Run `/gm-guard` for full phase verification
2. Update STATE.md via GSD
3. Announce completion:
   ```
   Phase [N] complete.

   Summary:
   - Plans executed: 5
   - Waves completed: 2
   - Sessions used: 3
   - Conflicts resolved: 0

   Next: Run /gm-phase [N+1] or check /gsd:progress
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

## Integration with GSD

This command orchestrates GSD's execution:

1. Reads PLAN.md files from `.planning/phases/`
2. Executes plans via GSD's internal executor
3. Updates STATE.md through GSD
4. Adds parallel coordination layer on top

God Mode doesn't replace GSD's execution - it coordinates WHICH terminal runs WHICH plan.
