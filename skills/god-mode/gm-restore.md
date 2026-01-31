---
name: gm-restore
description: Restore context for a new Claude session. Reads all .gm/ files and outputs a comprehensive summary of project state, enabling seamless continuation of work across sessions.
---

# /gm-restore: Restore Session Context

## Trigger
User runs `/gm-restore` at the start of a new session.

## Purpose
Give a new Claude session complete awareness of:
- What the project is
- What's been done
- What's in progress
- What decisions were made
- What issues exist
- What to do next

## Process

### Step 1: Read All State Files
Read in order:
1. `.gm/context.md` — Current state summary
2. `.gm/plan.md` — Full task list with checkboxes
3. `.gm/progress.md` — Activity timeline
4. `.gm/decisions.md` — Architecture choices
5. `.gm/issues.md` — Blockers and deferred work

### Step 2: Analyze Current State
Determine:
- Current phase number
- Phase status (not started / in-progress / complete / blocked)
- Last completed task
- Active/in-progress tasks
- Blocking issues
- Recent activity

### Step 3: Identify Critical Context
From decisions.md, extract:
- Tech stack choices
- Architecture patterns
- Naming conventions
- Key constraints

From issues.md, extract:
- Any blockers
- Important deferred items
- Known edge cases

### Step 4: Determine Next Action
Based on state:
- If phase in-progress: Identify next task
- If phase complete: Recommend starting next phase
- If blocked: Explain blocker and options
- If all phases done: Confirm project complete

### Step 5: Output Restoration Summary

```markdown
# Session Restored

## Project Overview
**Name:** [from plan.md]
**Goal:** [from plan.md overview]

## Current State
**Phase:** [N] of [Total]
**Status:** [in-progress | complete | blocked]
**Progress:** [X]% overall ([Y]/[Z] tasks)

## Recent Activity
[Last 5 entries from progress.md]

## Key Decisions in Effect
- [Decision 1 summary]
- [Decision 2 summary]
- [Decision 3 summary]

## Active Issues
**Blockers:** [count]
[List if any]

**Deferred:** [count]
[List if any]

## Where You Left Off
**Last completed:** Task [X.Y] — [description]
**Next task:** Task [X.Z] — [description]

## Recommended Action
[Specific recommendation based on state]

Examples:
- "Continue with Task 2.4 to complete Phase 2"
- "Run /gm-phase 3 to start Phase 3"
- "Fix blocker in issues.md before proceeding"
- "Run /gm-guard 2 to verify parallel work completed"

---

Ready to continue. What would you like to do?
```

### Step 6: Update Context
Update `.gm/context.md` with new session timestamp:
```markdown
## Session History
- [Previous timestamp]: [Previous session summary]
- [Current timestamp]: Session restored
```

## Quick Restore (Machine-Readable)

For automated or rapid restoration, also output a condensed format:

```
STATE: Phase 2, in-progress, 45% complete
LAST: Task 2.3 complete
NEXT: Task 2.4
BLOCKERS: None
COMMAND: Continue /gm-phase 2 or run task 2.4
```

## Handling Stale State

If `.gm/` files seem outdated (e.g., files exist that aren't tracked):

```markdown
## Warning: Possible State Drift

The codebase may have changes not reflected in .gm/ files.

Detected:
- [New file not in plan]
- [Modified file not logged]

Recommendations:
1. Run /gm-guard to sync state
2. Update plan.md if scope changed
3. Log any decisions made outside god-mode
```

## Handling Missing Files

If some `.gm/` files are missing:

```markdown
## Warning: Incomplete State

Missing files:
- [ ] .gm/decisions.md — No decision history
- [ ] .gm/issues.md — No issue tracking

Recommendations:
1. Create missing files manually
2. Or run /gm-plan to reinitialize
```

## Session Handoff Best Practice

At the end of any session, the user should run:
```
Update .gm/context.md with current state and what the next session should do first.
```

This ensures `/gm-restore` has accurate data.
