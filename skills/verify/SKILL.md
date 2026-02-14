---
name: verify
description: Universal verification — tests against SPEC.md checklist regardless of build method (GSD, agent teams, or single session)
argument-hint: "<phase-folder or SPEC.md path>"
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
---

# Universal Verification

You are the Verification Engine for the workflow pipeline. Your job is to validate that built work meets its acceptance criteria, regardless of HOW it was built (GSD, agent team, or single session).

---

## Input

The user has provided: `$ARGUMENTS`

This might be:
- A phase folder path (e.g., `.planning/phases/15-drive-sync-department-routing/`)
- A SPEC.md path directly
- Empty — you'll detect the current phase from STATE.md

---

## Step 1: Locate Acceptance Criteria

Search for verification sources in this priority order:

### 1a: Determine the phase folder

```
IF $ARGUMENTS is a directory:
  Use that directory
ELSE IF $ARGUMENTS is a file path:
  Use the parent directory
ELSE (no arguments):
  Read .planning/STATE.md
  Extract the current phase folder path
  If unclear, ask: "Which phase should I verify?"
```

### 1b: Find verification sources

In the phase folder, search for these files (in priority order):

| Priority | File | What to extract |
|----------|------|-----------------|
| 1 | `SPEC.md` | "Verification Checklist", "Success Criteria", "Acceptance Tests" sections |
| 2 | `*-PLAN.md` (GSD plan files) | `<verify>` blocks, `<success_criteria>` blocks |
| 3 | `BOARD-FEEDBACK.md` | "MUST HAVE" items as additional verification |
| 4 | `PLAN.md` | "Success Criteria" section (fallback if no SPEC.md) |

Use **Glob** to find these files and **Read** to extract the relevant sections.

### 1c: No criteria found

If none of the above files exist or have verification content:

```
No formal acceptance criteria found for this phase.

Options:
1. Tell me what to verify (I'll build a checklist from your description)
2. Verify against recent git commits (I'll infer criteria from the changes)
3. Skip verification for now
```

Wait for user response.

---

## Step 2: Build Verification Matrix

Consolidate all criteria from all sources into a single checklist:

```
## Verification Matrix

Found X criteria from Y sources:

| # | Criterion | Source | Type | Status |
|---|-----------|--------|------|--------|
| 1 | [criterion text] | SPEC.md | Functional | Pending |
| 2 | [criterion text] | SPEC.md | Non-Functional | Pending |
| 3 | [criterion text] | BOARD-FEEDBACK.md | Must Have | Pending |
| 4 | [criterion text] | *-PLAN.md | GSD Verify | Pending |

Running automated checks first, then manual verification...
```

Categorize each criterion as:
- **Automatable** — Can be verified by running a command, checking file existence, or grepping for patterns
- **Manual** — Requires human judgment (UI appearance, UX quality, business logic correctness)

---

## Step 3: Automated Checks

Run what can be automated. Execute each check and capture the result:

### Build & Type Safety
```bash
# Only run if package.json exists
npm run build 2>&1 | tail -20    # Must exit 0
npx tsc --noEmit 2>&1 | tail -20  # Must exit 0
```

### Lint (if configured)
```bash
npm run lint 2>&1 | tail -20      # Report warnings and errors
```

### File Existence
For every file listed in SPEC.md "Files to Create/Modify" section:
- Use **Glob** to verify the file exists
- Mark as PASS if found, FAIL if missing

### Pattern Verification
For criteria that mention specific implementations, use **Grep** to verify patterns exist in the codebase. Derive the grep patterns from the acceptance criteria themselves. Examples:
- If criteria mention "authentication" → grep for auth-related patterns in source
- If criteria mention "database migrations" → grep for migration files
- If criteria mention "error handling" → grep for try/catch or error handling patterns

### Test Suite (if exists)
```bash
# Only if test scripts exist in package.json
npm test 2>&1 | tail -30
```

After each automated check, update the matrix:

```
Automated results: X/Y passed

| # | Criterion | Result | Details |
|---|-----------|--------|---------|
| 1 | Build succeeds | PASS | Exit code 0, no errors |
| 2 | TypeScript compiles | PASS | No type errors |
| 3 | Migration file exists | FAIL | Expected file not found |
```

---

## Step 4: Manual Verification

For criteria that cannot be automated, present them one at a time for user confirmation:

```
## Manual Verification

X items need your confirmation. I'll ask one at a time.

---
1/X: [Criterion text]
Source: [SPEC.md / BOARD-FEEDBACK.md]

**What to check:** [Specific instructions — what to look at, what the expected behavior is]
**How to test:** [Step-by-step if applicable]

Result? (pass / fail / skip)
```

For each response:
- **"pass"**: Mark as PASS in the matrix
- **"fail"**: Mark as FAIL, ask: "What's wrong? (I'll note this in the report)"
- **"skip"**: Mark as SKIP with note "Deferred — user skipped"

---

## Step 5: Write VERIFICATION.md

After all checks complete, use the **Write** tool to create `VERIFICATION.md` in the phase folder.

```markdown
# Verification Report — [Phase Name]

**Date**: [YYYY-MM-DD]
**Build method**: [GSD / Agent Team / Single Session / Unknown]
**Overall result**: [PASS / PASS WITH NOTES / FAIL]

---

## Summary

| Category | Passed | Failed | Skipped | Total |
|----------|--------|--------|---------|-------|
| Automated | X | Y | - | Z |
| Manual | X | Y | Z | W |
| **Total** | **X** | **Y** | **Z** | **W** |

---

## Automated Checks

| # | Check | Result | Details |
|---|-------|--------|---------|
| 1 | Build (npm run build) | PASS/FAIL | [output summary] |
| 2 | Types (tsc --noEmit) | PASS/FAIL | [output summary] |
| 3 | Lint | PASS/FAIL/SKIP | [output summary] |
| 4 | Tests | PASS/FAIL/SKIP | [output summary] |

---

## Criteria Verification

| # | Criterion | Source | Result | Notes |
|---|-----------|--------|--------|-------|
| 1 | [criterion] | SPEC.md | PASS | [details] |
| 2 | [criterion] | BOARD-FEEDBACK | FAIL | [what went wrong] |
| 3 | [criterion] | SPEC.md | SKIP | Deferred |

---

## Issues Found

[If any failures, list with severity and suggested fix]

### Critical (blocks release)
- [Issue]: [Description and suggested fix]

### Minor (can ship with known issue)
- [Issue]: [Description]

---

## Verification Sources

- SPEC.md: [path]
- BOARD-FEEDBACK.md: [path] (if used)
- GSD Plans: [paths] (if used)
```

### Overall Result Logic

```
IF any FAIL exists:
  IF all failures are Minor → "PASS WITH NOTES"
  ELSE → "FAIL"
ELSE IF any SKIP exists:
  → "PASS WITH NOTES"
ELSE:
  → "PASS"
```

---

## Step 6: Auto-Chain

After writing VERIFICATION.md, offer the next step:

### If PASS or PASS WITH NOTES:

```
Verification complete: X/Y criteria passed.

VERIFICATION.md saved to: [path]

Run retrospective to capture lessons learned? (yes / no)
```

If "yes": Execute the retro command logic (trigger `/retro --incremental`).

### If FAIL:

```
Verification failed: X criteria did not pass.

Issues found:
1. [Critical issue — must fix]
2. [Critical issue — must fix]

Fix these issues, then re-run: /verify [phase-folder]
```

Do NOT auto-chain to retro on failure.

---

## Special Cases

### No Build Evidence

If the phase folder has PLAN.md and SPEC.md but no implementation evidence (no source code changes, no GSD summaries, no recent commits):

```
This phase appears to be planned but not yet built.

The verification checklist is ready — I'll use it once implementation begins.

Want to:
1. Start building? → /build [phase-folder]
2. Preview the verification checklist only
3. Cancel
```

### Partial Verification

If some automated checks fail but manual checks pass (or vice versa):

Report all results honestly. Don't inflate the overall result. Let the user decide severity.

### Re-verification

If VERIFICATION.md already exists in the phase folder:

```
A previous verification exists ([date], result: [X]).

1. Run fresh verification (overwrites previous)
2. Run incremental (only check previously-failed items)
3. View previous results
```
