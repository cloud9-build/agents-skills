---
name: gm-parallel
description: Identify parallel work opportunities from plan.md. Analyzes task dependencies and generates ready-to-paste prompts for running multiple Claude sessions simultaneously.
---

# /gm-parallel: Identify Parallel Work

## Trigger
User runs `/gm-parallel` after plan exists.

## Process

### Step 1: Read Current State
Read all `.gm/` files:
- `plan.md` for task list and dependencies
- `context.md` for current phase
- `progress.md` for completed tasks
- `issues.md` for blockers

### Step 2: Identify Current Phase
Determine which phase is active based on:
- Checked boxes in plan.md
- Phase number in context.md

### Step 3: Analyze Remaining Tasks
For each uncompleted task in current phase:
1. Check explicit `*(parallel: X.Y)*` annotations
2. Analyze file dependencies (what files will be created/modified)
3. Check for shared state (database tables, global config)
4. Identify data flow dependencies

### Step 4: Group Parallel Candidates
Create groups of tasks that can safely run simultaneously:

**Safe to parallelize when:**
- Tasks touch different files
- Tasks create independent features
- No task reads another's output
- All share the same prerequisite phase

**NOT safe to parallelize when:**
- Tasks modify same files
- One task depends on another's output
- Tasks share database migration order
- Tasks have API contract dependencies

### Step 5: Generate Terminal Prompts
For each parallel group, create a ready-to-paste prompt:

```markdown
## Parallel Group [N]: [Description]

### Terminal 1: [Task Name]
```
Read `.gm/plan.md` and `.gm/context.md`.
Assume all previous phases are complete.

Your task: [Task X.Y description]

Focus only on this task. Do not work on other tasks.

When complete:
1. Save all code to the appropriate files
2. Check off task X.Y in `.gm/plan.md`
3. Add an entry to `.gm/progress.md`
4. Log any decisions to `.gm/decisions.md`
5. Log any issues to `.gm/issues.md`
6. Report "Task X.Y complete" and stop
```

### Terminal 2: [Task Name]
```
Read `.gm/plan.md` and `.gm/context.md`.
Assume all previous phases are complete.

Your task: [Task X.Z description]

Focus only on this task. Do not work on other tasks.

When complete:
1. Save all code to the appropriate files
2. Check off task X.Z in `.gm/plan.md`
3. Add an entry to `.gm/progress.md`
4. Log any decisions to `.gm/decisions.md`
5. Log any issues to `.gm/issues.md`
6. Report "Task X.Z complete" and stop
```
```

### Step 6: Warn About Conflicts
List potential merge points:
```markdown
## After Parallel Work

These files may need review for conflicts:
- [file1.ts] — touched by Terminal 1 and Terminal 3
- [config.json] — may have overlapping changes

Run `/gm-guard` after all terminals complete to verify integration.
```

### Step 7: Output Format

```markdown
# Parallel Work Analysis

## Current State
- Phase: [N]
- Completed: [X/Y] tasks
- Ready for parallel: [N] tasks

## Parallel Groups

### Group 1: [Name] (2 terminals)
**Tasks:** 2.2, 2.3
**Why safe:** Different files, no shared state
**Potential conflicts:** None

[Terminal prompts here]

### Group 2: [Name] (3 terminals)
**Tasks:** 2.5, 2.6, 2.7
**Why safe:** Independent features
**Potential conflicts:** shared API routes file

[Terminal prompts here]

---

## Sequential Tasks (Cannot Parallelize)
- Task 2.4: Depends on 2.2 and 2.3 output
- Task 2.8: Modifies core config

## After Parallel Completion
1. Wait for all terminals to report complete
2. Run `/gm-guard` to verify integration
3. Resolve any file conflicts
4. Continue with sequential tasks
```

## Key Warnings to Include
- Always run `/gm-guard` after parallel work
- Don't start dependent tasks until parallel group finishes
- Each terminal should update `.gm/` files independently
- Review progress.md for any gaps after parallel work
