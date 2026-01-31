---
name: gm-phase
description: Execute a specific phase from plan.md. Takes phase number as argument, runs all tasks in order, updates all tracking files, and performs quality gate checks before declaring complete.
---

# /gm-phase [N]: Execute Phase

## Trigger
User runs `/gm-phase 1` or `/gm-phase 2` etc.

## Arguments
- `N` — Phase number to execute (required)

## Process

### Step 1: Load Context
Read all `.gm/` files:
- `plan.md` — Get phase N tasks
- `context.md` — Verify ready state
- `decisions.md` — Understand prior choices
- `issues.md` — Check for blockers
- `progress.md` — Confirm prerequisites done

### Step 2: Verify Prerequisites
Check that phase N-1 is complete:
- All tasks checked off
- Quality gate passed
- No blocking issues

If not ready, output:
```
Cannot start Phase [N].

Blockers:
- [ ] Phase [N-1] task X.Y incomplete
- [ ] Quality gate not passed: [reason]
- [ ] Blocking issue: [description]

Run /gm-guard [N-1] to diagnose.
```

### Step 3: Update Context
Update `.gm/context.md`:
```markdown
**Updated:** [ISO timestamp]
**Phase:** [N]
**Status:** in-progress

## Current State
- Last completed task: [from previous phase]
- Active work: Starting Phase [N]
- Blocking issues: None
```

### Step 4: Execute Tasks in Order
For each task in Phase N:

1. **Announce:** "Starting task N.X: [description]"

2. **Execute:** Perform the work
   - Write code
   - Create files
   - Run commands

3. **Verify:** Check task is actually done
   - Files exist
   - Code compiles/runs
   - Tests pass (if applicable)

4. **Update plan.md:** Check off the task
   ```markdown
   - [x] N.X: [description]
   ```

5. **Update progress.md:** Log completion
   ```markdown
   - [timestamp] Completed: Task N.X
   ```

6. **Log decisions:** If any architecture choices made
   ```markdown
   ## [Date] [Decision Title]
   **Context:** [Why needed]
   **Decision:** [What chosen]
   **Impact:** [What this affects]
   ```

7. **Log issues:** If any problems found
   ```markdown
   ## Deferred (Fix Later)
   - [ ] [Issue description] — Revisit in: Phase [M]
   ```

8. **Continue** to next task

### Step 5: Handle Checkpoints
When reaching a **CHECKPOINT** task:

1. Run specified checks (tests, build, validation)
2. If checks fail:
   - Log failure to issues.md
   - Attempt fix
   - Re-run checks
   - If still failing, pause and inform user
3. If checks pass:
   - Check off checkpoint
   - Continue to next task

### Step 6: Quality Gate
After all tasks complete, run quality gate checks from plan.md:

```markdown
## Quality Gate Check — Phase [N]

Running checks:
- [ ] [Check 1 from plan.md]
- [ ] [Check 2 from plan.md]
- [ ] [Check 3 from plan.md]
```

For each check:
- Execute the verification
- Mark pass/fail
- Log failures to issues.md

### Step 7: Phase Complete

If all quality gates pass:

Update `.gm/context.md`:
```markdown
**Updated:** [ISO timestamp]
**Phase:** [N] (Complete)
**Status:** ready

## Current State
- Last completed task: [N.final]
- Active work: None - ready for Phase [N+1]
- Blocking issues: None

## Key Decisions
[List any decisions made this phase]

## For New Sessions
- Phase [N] complete
- [Summary of what was built]
- Ready to start Phase [N+1]
```

Update `.gm/progress.md`:
```markdown
| [N] | [X] | [X] | 0 | 100% |
```

Output:
```
Phase [N] complete.

Summary:
- [X] tasks completed
- [Y] decisions logged
- [Z] issues deferred

Quality gate: PASSED

Next steps:
1. Run /gm-guard [N] to verify (recommended)
2. Run /gm-phase [N+1] to continue
3. Or run /gm-parallel to parallelize Phase [N+1]
```

### Step 8: Handle Failures

If quality gate fails:

Update context.md status to "blocked"

Output:
```
Phase [N] quality gate FAILED.

Failed checks:
- [Check description]: [Failure reason]

Options:
1. Fix the issues and re-run /gm-phase [N]
2. Review issues in .gm/issues.md
3. Run /gm-guard [N] for detailed diagnosis
```

## Error Handling

**On compile/build errors:**
1. Log to issues.md
2. Attempt fix
3. If unfixable, pause and inform user
4. Update context.md status to "blocked"

**On test failures:**
1. Log failing tests to issues.md
2. If trivial, fix and continue
3. If complex, log as deferred and continue
4. Note in context.md

**On blockers:**
1. Immediately update issues.md
2. Update context.md status
3. Skip blocked task, continue with others if possible
4. Report blocked tasks at phase end
