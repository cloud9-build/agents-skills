---
name: gm-plan
description: Create a structured execution plan for god-mode. Analyzes the project, asks clarifying questions, then generates plan.md with phased tasks, dependencies, quality gates, and parallel work annotations.
---

# /gm-plan: Create Execution Plan

## Trigger
User runs `/gm-plan` or asks to "create a plan" in god-mode context.

## Process

### Step 1: Understand the Project
Read the codebase if it exists. Identify:
- Tech stack (languages, frameworks, databases)
- Existing file structure
- Current state (new project vs existing code)

### Step 2: Ask Clarifying Questions
Ask the user (use AskUserQuestion tool):
1. What is the main goal of this project?
2. What is the target outcome when "done"?
3. Any hard constraints? (deadline, tech requirements, budget)
4. What's already built vs needs building?

### Step 3: Identify Phases
Break work into logical phases:
- **Phase 1:** Always foundation (setup, schema, core infra)
- **Phase 2-N:** Feature phases (group related work)
- **Final Phase:** Polish, testing, deployment

### Step 4: Identify Dependencies
For each task, determine:
- What must complete before this can start?
- What other tasks could run in parallel?
- What files will this modify?

### Step 5: Define Quality Gates
For each phase, define specific pass criteria:
- Tests pass
- Schema validates
- Feature works end-to-end
- No critical errors in logs

### Step 6: Generate plan.md

Create `.gm/plan.md` with this structure:

```markdown
# Project: [NAME]

## Overview
[2-3 sentences describing what this project does and why]

## Tech Stack
- [Language/Framework]
- [Database]
- [Key libraries]

## Success Criteria
- [ ] [Measurable outcome 1]
- [ ] [Measurable outcome 2]
- [ ] [Measurable outcome 3]

---

## Phase 1: Foundation
**Goal:** [One sentence]
**Dependencies:** None
**Estimated Tasks:** [N]

### Quality Gate
- [ ] [Specific check 1]
- [ ] [Specific check 2]

### Tasks
- [ ] 1.1: [Task description]
- [ ] 1.2: [Task description]
- [ ] 1.3: **CHECKPOINT** — Verify foundation before proceeding

---

## Phase 2: [Name]
**Goal:** [One sentence]
**Dependencies:** Phase 1 complete
**Estimated Tasks:** [N]

### Quality Gate
- [ ] [Specific check 1]
- [ ] [Specific check 2]

### Tasks
- [ ] 2.1: [Task description]
- [ ] 2.2: [Task description] *(parallel: 2.3)*
- [ ] 2.3: [Task description] *(parallel: 2.2)*
- [ ] 2.4: **CHECKPOINT** — Integration test

---

[Continue for all phases]

---

## Parallel Work Map
| Task | Can Parallel With | Reason |
|------|-------------------|--------|
| 2.2  | 2.3               | No shared files |
| 3.1  | 3.2, 3.3          | Independent features |
```

### Step 7: Initialize Other Files

Create `.gm/context.md`:
```markdown
# Context Snapshot
**Updated:** [ISO timestamp]
**Phase:** 0 (Planning Complete)
**Status:** ready

## Current State
- Last completed task: Planning
- Active work: None - ready to start Phase 1
- Blocking issues: None

## Key Decisions
- None yet

## For New Sessions
- Project goal: [from user input]
- Start with Phase 1, Task 1.1
- Run /gm-phase 1 to begin execution
```

Create `.gm/decisions.md`:
```markdown
# Decision Log

## [Today's Date] Project Initialized
**Context:** Starting new god-mode project
**Decision:** Using phased approach with [N] phases
**Rationale:** [Brief explanation of phase structure]
**Impact:** All work follows plan.md structure

---
```

Create `.gm/issues.md`:
```markdown
# Issues & Deferred Work

## Blockers (Must Fix)
None

## Deferred (Fix Later)
None

## Edge Cases (Known)
None

## Resolved
None yet

---
```

Create `.gm/progress.md`:
```markdown
# Progress Tracker
**Last Updated:** [timestamp]

## Phase Summary
| Phase | Tasks | Complete | Blocked | Progress |
|-------|-------|----------|---------|----------|
| 1     | [N]   | 0        | 0       | 0%       |
| 2     | [N]   | 0        | 0       | 0%       |
[...]

## Recent Activity
- [timestamp] Plan created
```

### Step 8: Confirm with User

Output:
```
Plan created in .gm/plan.md

Summary:
- [N] phases identified
- [N] total tasks
- [N] tasks can run in parallel

Next steps:
1. Review .gm/plan.md
2. Run /gm-phase 1 to start execution
3. Or run /gm-parallel to see parallel opportunities
```

## Output Artifacts
- `.gm/plan.md` — The execution plan
- `.gm/context.md` — Session state
- `.gm/decisions.md` — Decision log
- `.gm/issues.md` — Issue tracker
- `.gm/progress.md` — Progress tracker
