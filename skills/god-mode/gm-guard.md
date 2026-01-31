---
name: gm-guard
description: Verify phase completion by calling GSD's verify-work and adding parallel-session conflict detection. The guardian for coordinated parallel execution.
---

# /gm-guard: Verify Completion with Conflict Check

## Trigger
User runs `/gm-guard` or `/gm-guard [phase]`.

## Arguments
- `[phase]` — Phase number to verify (optional, defaults to current phase from STATE.md)

## Purpose
1. Call GSD's `/gsd:verify-work` to verify the actual work is done
2. Add parallel-session specific checks for conflicts and synchronization issues
3. Ensure all sessions completed cleanly before moving to next phase/wave

## Process

### Step 1: Verify Prerequisites
1. Check `.planning/PROJECT.md` exists
2. Check `.planning/parallel/` exists
3. Read `.planning/STATE.md` for current phase
4. Read `.planning/parallel/sessions.md` for session states

### Step 2: Call GSD Verification
Invoke `/gsd:verify-work` which:
- Checks all plans in the phase are complete
- Verifies code matches plan descriptions
- Runs quality gate checks
- Returns pass/fail with details

### Step 3: Parallel-Specific Checks

**Session State Check:**
```markdown
## Session Status

| Session | Plan | Status | Last Activity |
|---------|------|--------|---------------|
| gm-001 | 01-01 | complete | 5m ago |
| gm-002 | 01-02 | complete | 3m ago |
| gm-003 | 01-03 | complete | 1m ago |

All sessions reported complete.
```

**File Conflict Check:**
```markdown
## File Conflict Analysis

Checking for overlapping changes...

Files modified by multiple sessions:
- src/index.ts: gm-001 (lines 1-20), gm-002 (lines 50-60) — NO CONFLICT
- src/api/routes.ts: gm-001 (lines 30-45), gm-003 (lines 35-50) — CONFLICT

Conflict detected in src/api/routes.ts:
- gm-001 modified lines 30-45 for "auth middleware"
- gm-003 modified lines 35-50 for "error handling"
- Overlapping region: lines 35-45
```

**Git Status Check:**
```markdown
## Git Status

- Uncommitted changes: None
- Merge conflicts: None
- Unpushed commits: 3

All changes committed cleanly.
```

**Stale Session Check:**
```markdown
## Stale Sessions

Sessions with no activity for >30 minutes:
- gm-004: Last ping 45m ago, Plan 01-04, Status: in_progress

Warning: Session gm-004 may have crashed or been abandoned.
Consider running /gm-release 01-04 to free the plan.
```

### Step 4: Generate Report

```markdown
# Guard Report — Phase [N]
**Verified:** [timestamp]
**Wave:** [current wave]

## GSD Verification
[Output from /gsd:verify-work]

## Parallel Coordination

### Session Status
- Total sessions: 4
- Completed: 3
- In progress: 0
- Stale: 1

### File Conflicts
- Conflicts found: 1
- See details above

### Git Status
- Clean: Yes
- Commits synced: Yes

## Verdict

[PASS | FAIL | PARTIAL]

### If PASS:
Phase [N] Wave [W] verified complete.
All sessions completed without conflicts.

Next steps:
1. Wave [W+1] plans are now available
2. Run /gm-parallel to see new assignments
3. Or run /gm-phase [N+1] if phase complete

### If FAIL (conflicts):
Conflicts detected. Resolution required.

Conflicts:
1. src/api/routes.ts — overlapping changes

Resolution options:
1. Manual merge: Review and combine changes
2. Session priority: Keep gm-001's changes (/gm-resolve 01-01)
3. Revert: Undo gm-003's changes and redo

After resolving:
1. Commit the resolution
2. Re-run /gm-guard

### If FAIL (incomplete):
Wave [W] incomplete.

Missing:
- PLAN-01-03: Not started (session gm-003 stale)

Options:
1. Wait for session to resume
2. Release plan: /gm-release 01-03
3. Claim in this terminal: /gm-claim 01-03
```

### Step 5: Update Tracking Files

If verification passes:
1. Update `sessions.md` - mark sessions as verified
2. Update `assignments.md` - mark wave as complete
3. Update `conflicts.md` - clear resolved conflicts
4. Release all file locks for completed plans

## Conflict Resolution Commands

When conflicts are detected, suggest:

```
/gm-resolve [plan] --keep    # Keep this plan's changes, discard others
/gm-resolve [plan] --merge   # Open merge tool
/gm-resolve [plan] --revert  # Revert this plan's changes
```

## No-Code Mode

The guardian does NOT write code. It only:
- Reads and analyzes
- Reports findings
- Suggests resolution commands

If fixes are needed, user should:
1. Resolve conflicts manually or with suggested commands
2. Re-run `/gm-guard` to verify
