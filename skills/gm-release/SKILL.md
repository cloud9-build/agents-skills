---
name: gm-release
description: Release a claimed plan back to the pool. Use when stopping work, changing plans, or freeing stale claims.
---

# /gm-release [plan]: Release a Plan

## Trigger
User runs `/gm-release 01-02` or `/gm-release` (releases current plan).

## Arguments
- `[plan]` — Plan ID to release (optional, defaults to current session's plan)
- `--force` — Release even if work in progress
- `--abandon` — Release and discard any uncommitted work

## Purpose
Free a claimed plan so other sessions can work on it. Used when:
- Stopping work on a plan
- Switching to different work
- Freeing stale claims from crashed sessions

## Process

### Step 1: Identify Plan to Release

**If no argument, use current session's plan:**
```
This session (gm-001) is working on PLAN-01-02.

Release PLAN-01-02? [y/n]:
```

**If argument provided, verify ownership:**
```
PLAN-01-02 is assigned to gm-003, not this session.

To release another session's plan:
/gm-release 01-02 --force

Note: This requires coordinator privileges.
```

### Step 2: Check Work State

**If work is complete:**
```
PLAN-01-02 is marked complete.

No need to release. Plan is done.

If you need to re-work it:
/gm-claim 01-02 --force
```

**If work is in progress:**
```
PLAN-01-02 is in progress.

Progress: 3/5 tasks complete
Uncommitted changes: 2 files
Last commit: "Add login endpoint"

Options:
1. Commit and release: Save progress for next session
2. Abandon: Discard uncommitted work
3. Cancel: Keep working

Choice [1/2/3]:
```

### Step 3: Handle Uncommitted Work

**Option 1: Commit and release**
```
Committing current progress...

Committed: "WIP: PLAN-01-02 partial progress (3/5 tasks)"
Branch: feature/01-02-wip

Next session can resume with:
/gm-claim 01-02 --resume
```

**Option 2: Abandon**
```
Warning: Abandoning uncommitted work.

Changes to be discarded:
- src/auth/login.ts (modified)
- src/auth/session.ts (new file)

This cannot be undone.

Proceed? [y/n]: y

Discarded 2 file changes.
Plan released.
```

### Step 4: Update Tracking Files

1. **assignments.md:**
   ```markdown
   | 01-02 | 1 | - | available | [timestamp] |
   ```

2. **sessions.md:**
   ```markdown
   | gm-001 | Terminal 1 | - | idle | [now] | [now] |
   ```

3. **conflicts.md:**
   Remove file locks

### Step 5: Confirm Release

```
Released PLAN-01-02.

Status: Available for other sessions
Progress saved: Yes (3/5 tasks)
File locks released: 2

This session is now idle.

Next steps:
- Claim different work: /gm-parallel
- Check status: /gm-status
- Exit God Mode: Close terminal
```

## Release Stale Session

For coordinator releasing another session's work:

```
/gm-release 01-02 --force

Session gm-003 has PLAN-01-02.

Session status:
- Last ping: 45 minutes ago
- Status: in_progress
- Progress: Unknown (session unresponsive)

Releasing as stale...

Note: Any uncommitted work by gm-003 may be lost.
Next session should verify state before continuing.

Released PLAN-01-02 from gm-003.
```

## Error Handling

**If plan not found:**
```
PLAN-01-99 not found.

Your current plan: PLAN-01-02

To release your plan:
/gm-release 01-02
or just:
/gm-release
```

**If release fails:**
```
Failed to release PLAN-01-02.

Reason: Git has uncommitted changes that couldn't be stashed.

Fix:
1. Commit changes: git add . && git commit -m "WIP"
2. Or discard: git checkout .
3. Then retry: /gm-release 01-02
```
