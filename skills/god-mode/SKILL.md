---
name: god-mode
description: Run Claude Code in structured parallel mode with plan tracking, context preservation, and quality gates. Use /gm to start a new project, /gm-plan to create a plan, /gm-parallel to identify parallel work, /gm-phase to execute a phase, /gm-guard to verify completion, /gm-restore to resume work.
---

# God Mode: Structured Parallel Execution Framework

Run complex projects with multiple parallel Claude sessions while maintaining coherence, tracking progress, and preserving context.

## Quick Start Commands

| Command | Purpose |
|---------|---------|
| `/gm` | Initialize god-mode for a project |
| `/gm-plan` | Create structured plan.md |
| `/gm-parallel` | Identify parallel work opportunities |
| `/gm-phase [N]` | Execute phase N |
| `/gm-guard [N]` | Verify phase N completion |
| `/gm-restore` | Restore context for new session |

## Core Files (Auto-Created)

```
.gm/
├── plan.md           # Phased task breakdown with checkboxes
├── context.md        # Machine-readable state for session restoration
├── decisions.md      # Architecture and design choices (dated)
├── issues.md         # Blockers, deferred work, edge cases
└── progress.md       # Automated progress tracking
```

## When User Runs /gm

Initialize god-mode by creating the file structure:

1. Create `.gm/` directory if it doesn't exist
2. Read the codebase to understand current state
3. Ask clarifying questions about the project goal
4. Create initial `context.md` with:
   - Project name and one-sentence goal
   - Tech stack detected
   - Current session timestamp
   - Phase: "Planning"
5. Inform user: "God-mode initialized. Run `/gm-plan` to create your execution plan."

## File Formats

### plan.md

```markdown
# Project: [NAME]

## Overview
[2-3 sentences: What problem this solves]

## Phases

### Phase 1: Foundation
**Dependencies:** None
**Quality Gate:** [Specific criteria to pass before Phase 2]

- [ ] Task 1.1: [Description]
- [ ] Task 1.2: [Description]
- [ ] **CHECKPOINT:** Run tests, verify schema

### Phase 2: Core Features
**Dependencies:** Phase 1 complete
**Quality Gate:** [Specific criteria]

- [ ] Task 2.1: [Description]
- [ ] Task 2.2: [Description] *(can parallel with 2.3)*
- [ ] Task 2.3: [Description] *(can parallel with 2.2)*
- [ ] **CHECKPOINT:** Integration test

### Phase 3: Polish
**Dependencies:** Phase 2 complete
**Quality Gate:** [Specific criteria]

- [ ] Task 3.1: [Description]
```

### context.md

```markdown
# Context Snapshot
**Updated:** [ISO timestamp]
**Phase:** [Current phase number]
**Status:** [in-progress | blocked | complete]

## Current State
- Last completed task: [task ID]
- Active work: [description]
- Blocking issues: [none | list]

## Key Decisions
- [Decision 1 summary] → see decisions.md line X
- [Decision 2 summary] → see decisions.md line Y

## For New Sessions
[3-5 bullet summary of what any new session needs to know]
```

### decisions.md

```markdown
# Decision Log

## [YYYY-MM-DD] [Short Title]
**Context:** [Why this decision was needed]
**Decision:** [What was decided]
**Alternatives Considered:** [Brief list]
**Impact:** [What this affects going forward]

---
```

### issues.md

```markdown
# Issues & Deferred Work

## Blockers (Must Fix)
- [ ] [Issue]: [Description] — Blocks: [task ID]

## Deferred (Fix Later)
- [ ] [Issue]: [Description] — Revisit in: [phase]

## Edge Cases (Known)
- [ ] [Scenario]: [How it's handled or TODO]

## Resolved
- [x] [Issue]: [Resolution] — [Date]
```

### progress.md

```markdown
# Progress Tracker
**Last Updated:** [timestamp]

## Phase Summary
| Phase | Tasks | Complete | Blocked | Progress |
|-------|-------|----------|---------|----------|
| 1     | 5     | 5        | 0       | 100%     |
| 2     | 8     | 3        | 1       | 37%      |
| 3     | 4     | 0        | 0       | 0%       |

## Recent Activity
- [timestamp] Completed: Task 2.3
- [timestamp] Started: Task 2.4
- [timestamp] Blocked: Task 2.5 (see issues.md)
```

## Execution Rules

### Before Starting Any Task
1. Read `context.md` first
2. Check `issues.md` for blockers
3. Verify dependencies in `plan.md`

### After Completing Any Task
1. Check off task in `plan.md`
2. Update `progress.md` with timestamp
3. Update `context.md` current state
4. Log any new decisions to `decisions.md`
5. Log any new issues to `issues.md`

### Before Moving to Next Phase
1. Run the quality gate checks listed in `plan.md`
2. Verify all tasks checked off
3. Run `/gm-guard [N]` to validate
4. Update `context.md` phase number

### On Any Error or Blocker
1. Log to `issues.md` immediately
2. Update `context.md` status to "blocked"
3. Continue with non-blocked tasks if possible
4. Inform user of blocker

## Quality Gates

Every phase transition requires:
1. All phase tasks checked complete
2. Quality gate criteria met (defined in plan.md)
3. No critical issues in issues.md
4. Guardian verification passed

## Parallel Work Rules

Tasks can run in parallel when:
- They have no shared file dependencies
- They don't modify the same database tables
- They don't depend on each other's output
- Phase dependencies are met

Mark parallelizable tasks in plan.md with:
`*(can parallel with X.Y)*`

## Session Restoration Protocol

When starting a new session:
1. Run `/gm-restore`
2. Claude reads all .gm/ files
3. Claude outputs current state summary
4. Claude identifies next action
5. User confirms or redirects

## Integration After Parallel Work

After parallel sessions complete:
1. Run `/gm-guard` to check for conflicts
2. Review any overlapping file changes
3. Resolve conflicts in a dedicated session
4. Update all .gm/ files to reflect merged state

## Rollback Protocol

If a phase fails quality gates:
1. Document failure in issues.md
2. Use `git log` to find last good state
3. Create rollback plan in decisions.md
4. Execute rollback with `git revert` or `git reset`
5. Update context.md with rollback note

## Best Practices

1. **One job per terminal** - Keep prompts focused
2. **Update files immediately** - Don't batch updates
3. **Trust the plan** - Deviate only when necessary, log why
4. **Guard religiously** - Always verify before phase transitions
5. **Context is king** - Keep context.md accurate for seamless handoffs
