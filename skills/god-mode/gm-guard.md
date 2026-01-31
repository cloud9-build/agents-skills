---
name: gm-guard
description: Verify phase completion and check for gaps. Scans the codebase against plan.md to ensure all tasks are actually done, identifies missing work, and validates quality gates. The plan guardian.
---

# /gm-guard [N]: Verify Phase Completion

## Trigger
User runs `/gm-guard` or `/gm-guard 2` etc.

## Arguments
- `N` — Phase number to verify (optional, defaults to current phase from context.md)

## Purpose
Act as the "plan guardian" — verify that what plan.md says is done actually exists in the codebase.

## Process

### Step 1: Load State
Read all `.gm/` files to understand:
- What tasks are marked complete
- What decisions were made
- What issues exist
- Current phase status

### Step 2: Identify Checked Tasks
Extract all tasks marked `[x]` in Phase N from plan.md.

### Step 3: Verify Each Task
For each completed task, verify it's actually done:

**For code tasks:**
- Does the file exist?
- Does the function/component exist?
- Does it compile?
- Does it match the task description?

**For setup tasks:**
- Is the config present?
- Is the schema created?
- Are dependencies installed?

**For integration tasks:**
- Do the pieces connect?
- Can data flow through?

**For test tasks:**
- Do tests exist?
- Do tests pass?

### Step 4: Check Quality Gates
Run each quality gate check from plan.md:
- Execute the verification
- Record pass/fail
- Note specific failures

### Step 5: Check for Conflicts
After parallel work, check:
- Any files with uncommitted merge conflicts
- Any duplicate implementations
- Any broken imports/references
- Any inconsistent naming

### Step 6: Cross-Reference Issues
Check issues.md for:
- Any blockers still open
- Any deferred items that should have been fixed
- Any edge cases that need handling

### Step 7: Generate Report

```markdown
# Guard Report — Phase [N]
**Verified:** [timestamp]

## Task Verification

### Completed & Verified
- [x] N.1: [Task] — VERIFIED
  - File: [path] exists
  - Function: [name] implemented
- [x] N.2: [Task] — VERIFIED
  - Component: [name] renders
  - Tests: 3/3 pass

### Marked Complete But Issues Found
- [x] N.3: [Task] — ISSUES
  - Expected: [what should exist]
  - Found: [what actually exists]
  - Gap: [what's missing]

### Not Completed
- [ ] N.4: [Task] — INCOMPLETE
  - Status: Not started / Partial

## Quality Gate Results

| Check | Status | Notes |
|-------|--------|-------|
| [Check 1] | PASS | [details] |
| [Check 2] | FAIL | [what failed] |
| [Check 3] | PASS | [details] |

## Conflict Check
- [x] No merge conflicts found
- [x] No duplicate implementations
- [ ] Broken import in [file]: [details]

## Issues Status
- Blockers: [N] (must fix before proceeding)
- Deferred: [N] (can proceed)
- New issues found: [N]

## Verdict

[PASS | FAIL | PARTIAL]

[Summary of phase status]
```

### Step 8: Recommendations

**If PASS:**
```
Phase [N] verified complete.

Recommendations:
1. Proceed to Phase [N+1]
2. Or run /gm-parallel to identify parallel work
```

**If FAIL:**
```
Phase [N] has gaps.

Required fixes:
1. [Specific fix needed]
2. [Specific fix needed]

After fixing:
1. Re-run /gm-guard [N] to verify
2. Or run /gm-phase [N] to complete remaining tasks
```

**If PARTIAL:**
```
Phase [N] mostly complete with deferred items.

Complete:
- [X/Y] tasks verified

Deferred (logged in issues.md):
- [Issue 1]
- [Issue 2]

You can proceed to Phase [N+1] if deferred items are acceptable.
```

## Special Checks After Parallel Work

When verifying after `/gm-parallel`:

1. **File collision check:**
   - List all files modified by multiple terminals
   - Verify no conflicting changes
   - Check git status for conflicts

2. **Integration check:**
   - Verify modules can import each other
   - Check for naming conflicts
   - Verify shared state is consistent

3. **Progress sync check:**
   - Ensure all terminals updated progress.md
   - Check for any gaps in activity log
   - Verify task checkboxes match reality

## No-Code Mode

The guardian does NOT write code. It only:
- Reads and analyzes
- Reports findings
- Recommends actions

If fixes are needed, user should:
1. Run `/gm-phase [N]` to complete remaining work
2. Or fix manually and re-run `/gm-guard [N]`
