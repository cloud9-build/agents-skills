---
name: gm-parallel
description: Show which GSD plans can run in parallel based on wave assignments. Reads wave frontmatter from PLAN.md files and displays terminal assignment suggestions.
---

# /gm-parallel: Show Parallelizable Work

## Trigger
User runs `/gm-parallel` after God Mode is initialized.

## Purpose
Analyze GSD's PLAN.md files in the current phase, read their `wave` frontmatter, and show which plans can run simultaneously in different terminals.

## Process

### Step 1: Verify Prerequisites
1. Check `.planning/PROJECT.md` exists - if not, error: "No GSD project. Run /gsd:new-project first."
2. Check `.planning/parallel/` exists - if not, error: "God Mode not initialized. Run /gm first."
3. Read `.planning/STATE.md` to get current phase

### Step 2: Read Phase Plans
1. Get current phase from STATE.md
2. Find all PLAN-*.md files in `.planning/phases/[phase]/`
3. Parse frontmatter from each plan:
   ```yaml
   ---
   phase: 01
   plan: 02
   title: User Authentication
   wave: 1
   status: pending
   ---
   ```

### Step 3: Group by Wave
Organize plans into wave groups:

```
Wave 1 (can start now):
  - PLAN-01-01: Database Schema
  - PLAN-01-02: User Authentication
  - PLAN-01-03: API Routes

Wave 2 (after wave 1 complete):
  - PLAN-01-04: Frontend Integration
  - PLAN-01-05: Error Handling

Wave 3 (after wave 2 complete):
  - PLAN-01-06: Testing & QA
```

### Step 4: Check Current Assignments
Read `.planning/parallel/assignments.md` to see:
- Which plans are already claimed
- Which sessions are active
- Which plans are complete

### Step 5: Generate Output

```markdown
# Parallel Work Analysis

**Phase:** 01 - Foundation
**Total Plans:** 6
**Current Wave:** 1

## Wave Status

### Wave 1: Ready to Parallelize (3 plans)

| Plan | Title | Status | Assigned To |
|------|-------|--------|-------------|
| 01-01 | Database Schema | in_progress | gm-001 (Terminal 1) |
| 01-02 | User Authentication | available | - |
| 01-03 | API Routes | available | - |

**Recommendation:** Open 2 more terminals and run:
- Terminal 2: `/gm-claim 01-02`
- Terminal 3: `/gm-claim 01-03`

### Wave 2: Waiting (2 plans)

| Plan | Title | Blocked By |
|------|-------|------------|
| 01-04 | Frontend Integration | Wave 1 incomplete |
| 01-05 | Error Handling | Wave 1 incomplete |

*These plans will be available after Wave 1 completes.*

### Wave 3: Waiting (1 plan)

| Plan | Title | Blocked By |
|------|-------|------------|
| 01-06 | Testing & QA | Wave 2 incomplete |

---

## Terminal Prompts

Copy-paste these into new terminal windows:

### Terminal 2
```
/gm
/gm-claim 01-02
```

### Terminal 3
```
/gm
/gm-claim 01-03
```

---

## After All Terminals Complete

1. Each terminal runs `/gm-sync` to check for conflicts
2. Run `/gm-status` to verify all wave 1 plans complete
3. Wave 2 plans will automatically become available
```

### Step 6: Handle Edge Cases

**If no plans in current phase:**
```
No plans found in Phase [N].

Run /gsd:plan-phase to create plans first.
```

**If all plans already assigned:**
```
All plans in Wave [N] are already assigned.

Active sessions:
- gm-001: PLAN-01-01 (in_progress)
- gm-002: PLAN-01-02 (in_progress)
- gm-003: PLAN-01-03 (in_progress)

Wait for current work to complete, or run /gm-status for details.
```

**If wave complete but next wave blocked:**
```
Wave 1 complete. Wave 2 is blocked.

Blocking issues:
- PLAN-01-01 completed but verification failed
- See /gsd:verify-work for details

Fix blocking issues before Wave 2 can start.
```

## Wave Calculation

If a PLAN.md doesn't have a `wave` field, God Mode should:
1. Warn: "PLAN-01-02 missing wave assignment"
2. Default to highest wave + 1 (treat as sequential)
3. Suggest: "Run /gsd:plan-phase to regenerate with wave assignments"

## No-Code Mode

This command only reads and analyzes. It does NOT:
- Modify any files
- Execute any plans
- Claim any work

Use `/gm-claim` to actually assign work to this terminal.
