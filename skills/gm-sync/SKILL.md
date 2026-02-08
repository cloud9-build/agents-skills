---
name: gm-sync
description: Check for conflicts across sessions, verify git state, and update tracking files. Respects GSD's branching strategy. Run after parallel work to ensure consistency.
---

# /gm-sync: Synchronize Parallel Sessions

## Trigger
User runs `/gm-sync` after parallel work.

## Purpose
1. Check for file conflicts between sessions
2. Verify git state is clean
3. Detect STATE.md contention from parallel writes
4. Update tracking files
5. Prepare for next wave

## Process

### Step 1: Read Current State
1. `.planning/parallel/sessions.md` — Who's working on what
2. `.planning/parallel/conflicts.md` — File locks
3. `.planning/STATE.md` — GSD state
4. `.planning/config.json` — GSD config (check `branching_strategy`)
5. Git status — Uncommitted changes, conflicts

### Step 2: Check GSD Branching Strategy

Read `branching_strategy` from `.planning/config.json` (or GSD's init output):

- **`"none"`** — All sessions work on the same branch. File-level conflict detection applies.
- **`"phase"`** — Sessions may be on feature branches. Check branch divergence.
- **`"milestone"`** — Long-lived branches per milestone.

Adapt conflict detection to match:

```markdown
## Branching Strategy: [none | phase | milestone]

Current branch: [branch name]
```

**If `phase` or `milestone` branching:**
```
Sessions may be on different branches.

Branch status:
- gm-001: feature/phase-02 (3 commits ahead of main)
- gm-002: feature/phase-02 (2 commits ahead of main)

Branch divergence: None (same branch)
```

### Step 3: Git Status Check

```markdown
## Git Status

**Branch:** feature/phase-02
**Clean:** Yes/No

### Uncommitted Changes
[List any uncommitted files]

### Merge Conflicts
[List any unresolved conflicts]
```

**If conflicts found:**
```
Git merge conflicts detected.

Conflicted files:
- src/api/routes.ts
- src/services/user.ts

These must be resolved before continuing.

Options:
1. Resolve manually and commit
2. View conflict details: git diff --name-only --diff-filter=U
3. Abort and reset: git merge --abort
```

### Step 4: STATE.md Contention Check

Multiple sessions running GSD executors write to STATE.md via `gsd-tools.js`. If two sessions update state simultaneously, one may overwrite the other.

**Check for contention signs:**
1. Read STATE.md — does the plan counter match expected value?
2. Compare SUMMARY.md count on disk vs STATE.md reported progress
3. Check git log for conflicting STATE.md commits

```markdown
## STATE.md Consistency

Expected completed plans (from SUMMARY.md files on disk): 3
STATE.md reports completed plans: 2

WARNING: STATE.md is behind — likely a parallel write conflict.

Fix: Run gsd-tools to recalculate from disk:
  node [gsd-path]/bin/gsd-tools.js state update-progress
```

**To prevent future contention:**
- Designate one terminal as the "state writer" (coordinator)
- Other terminals execute plans but let the coordinator update STATE.md
- Or: run `/gm-sync` after each plan completes to reconcile

### Step 5: Cross-Session File Analysis

Compare what each session modified:

```markdown
## File Modification Analysis

### Session gm-001 (PLAN-02-01)
Modified files:
- src/auth/jwt.ts (created)
- src/auth/middleware.ts (created)
- src/api/routes.ts (lines 50-75)

### Session gm-002 (PLAN-02-02)
Modified files:
- src/db/schema.ts (created)
- src/models/user.ts (created)
- src/api/routes.ts (lines 10-25)

### Overlap Analysis

| File | Sessions | Lines | Status |
|------|----------|-------|--------|
| src/api/routes.ts | gm-001, gm-002 | Different sections | OK |

No overlapping modifications detected.
```

**If overlap detected:**
```
Overlapping modifications detected.

File: src/config/database.ts
- gm-001: Modified lines 20-30 (connection settings)
- gm-002: Modified lines 25-35 (pool configuration)
- Overlap: Lines 25-30

Risk: Merge conflict likely.

Options:
1. Review changes: git diff gm-001..gm-002 -- src/config/database.ts
2. Manual merge: Edit file to combine changes
3. Keep one: /gm-resolve database.ts --keep gm-001
```

### Step 6: Session State Verification

```markdown
## Session State Check

| Session | Expected | Actual | Status |
|---------|----------|--------|--------|
| gm-001 | PLAN-02-01 complete | SUMMARY.md exists, commits present | OK |
| gm-002 | PLAN-02-02 complete | SUMMARY.md exists, commits present | OK |
| gm-003 | PLAN-02-03 in_progress | No SUMMARY.md yet | OK |

All sessions consistent with tracking files.
```

### Step 7: Update Tracking Files

After verification, update:

1. **sessions.md** — Update ping times, statuses
2. **assignments.md** — Mark verified completions
3. **conflicts.md** — Clear resolved locks

### Step 8: Wave Transition Check

```markdown
## Wave Status

### Wave 1 Summary
| Plan | Status |
|------|--------|
| 02-01 | complete |
| 02-02 | complete |
| 02-03 | in_progress (50%) |

Wave 1 completion: 67% (2/3)

### Wave 2 Readiness
Status: BLOCKED
Reason: PLAN-02-03 still in progress
```

**If wave complete:**
```
Wave 1 COMPLETE

All Wave 1 plans verified complete.

Wave 2 is now available:
- PLAN-02-04: Frontend Integration
- PLAN-02-05: Error Handling

Run /gm-parallel to see terminal assignments.
Or /gm-claim 02-04 to start immediately.
```

### Step 9: Generate Sync Report

```markdown
# Sync Report
**Timestamp:** [now]
**Branching Strategy:** [from config]

## Summary
- Sessions synced: 3
- Conflicts found: 0
- STATE.md consistent: Yes/No
- Wave status: 1 → 67% complete

## Actions Taken
- Updated session ping times
- Verified 2 plan completions
- Released 4 file locks
- Reconciled STATE.md progress (if needed)

## Next Steps
- /gm-status — View current state
- /gm-guard — Verify completed work
- /gm-parallel — When Wave 2 ready
```

## Force Sync

If tracking files are corrupted:

```
/gm-sync --force

Warning: Force sync will:
1. Re-scan all session states from git log and SUMMARY.md files
2. Rebuild assignments.md from PLAN.md files
3. Clear all file locks
4. Recalculate STATE.md progress from disk

This may lose tracking for in-progress work.

Proceed? [y/n]
```
