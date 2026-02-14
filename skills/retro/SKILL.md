---
name: retro
description: Audit this session for lessons learned. Applies additions to CLAUDE.md and masterCLAUDE.md with per-item confirmation and dedup checking.
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
---

# Session Retrospective

You are running a structured retrospective on the current session. Your job is to extract lessons learned and **apply** them to `CLAUDE.md` (project-specific) and `masterCLAUDE.md` (cross-project universal) with per-item user confirmation.

---

## Step 0: Detect Mode

Check how this retro was triggered:

1. **End-of-phase (default):** Audit the full conversation history for lessons.
2. **Incremental (`--incremental` or called from `/verify` auto-chain):** Scope the audit to only the current phase/session. Focus on decisions and pitfalls discovered during this specific build. Write a mini-RETRO.md to the phase folder in addition to CLAUDE.md updates.

If `.planning/STATE.md` indicates a phase was just completed or verified, default to incremental mode.

---

## Step 1: Load Existing Knowledge

Read these files to understand what's already documented:

1. `CLAUDE.md` (project root) — project-specific instructions
2. `masterCLAUDE.md` (project root, may not exist) — cross-project patterns
3. `.planning/STATE.md` — current phase context

If `masterCLAUDE.md` doesn't exist at the project root, use `Glob` to search for it. If it doesn't exist anywhere, note this — you'll offer to create it in Step 6 if cross-project lessons are found.

---

## Step 2: Audit the Session

Review the conversation history (full or incremental based on Step 0). For each category below, identify lessons that are **not already captured** in the existing files.

### For CLAUDE.md (this project only):

**1. Architecture Patterns**
- New conventions we established or discovered
- Integration patterns between specific tools/services in this project
- Data flow patterns that worked (or didn't)

**2. Pitfalls**
- Bugs, misconfigurations, or wrong assumptions YOU hit during this session
- Errors that required debugging — what was the root cause?
- Things that looked right but were wrong

**3. Constraints**
- Limits, gotchas, or "don't do X" rules we learned
- API limitations, version incompatibilities, framework quirks
- Things that silently fail or behave unexpectedly

**4. Key Decisions**
- Non-obvious choices made and WHY (so future sessions don't re-debate them)
- Tradeoffs considered and which direction was chosen
- "We tried X but switched to Y because Z"

### For masterCLAUDE.md (all projects):

**5. Tool / Framework Lessons**
- General patterns that apply beyond this project
- Library version gotchas, CLI quirks, SDK behaviors
- "Always do X when using Y" rules

**6. Workflow Improvements**
- Process changes that would help any Claude Code session
- Better prompting patterns, file organization, debugging approaches

---

## Step 3: Deduplicate

For each candidate lesson, search both `CLAUDE.md` and `masterCLAUDE.md` using `Grep` to check if the core insight is already documented (even if worded differently). Drop anything that's already captured.

---

## Step 4: Present All Proposals

For each surviving lesson, present it in this format:

```
### [Category Number]. [Category Name]

**Target file:** CLAUDE.md | masterCLAUDE.md
**Target section:** [Exact section heading where this belongs, or "NEW SECTION: [name]"]
**Action:** Add | Update existing entry

**Evidence:** [Quote the specific error, file, or conversation moment that taught this]

**Proposed text:**
> [The exact text to add, formatted to match the target file's style]

**If updating an existing entry:**
- Before: [current text]
- After: [updated text]
```

Group proposals by target file (CLAUDE.md first, then masterCLAUDE.md).

---

## Step 5: Apply Per-Item with Confirmation

After presenting all proposals, apply them one at a time with user confirmation.

```
Applying X proposals. Confirm each:

---
1/X: [CLAUDE.md] Add to '[Section Name]':
> [Proposed text — exact content that will be added]

Apply? (yes / no / edit)
```

For each item:
- **"yes"** (or Enter): Use the **Edit** tool to insert the text into the target file at the specified section. Apply immediately.
- **"no"** (or "skip"): Skip this item. Move to the next.
- **"edit"**: Wait for user to provide modified text, then apply that version using the **Edit** tool.

After each successful apply, confirm: `Applied to [file]:[section].`

After all items processed:
```
Applied X of Y proposals:
- CLAUDE.md: A additions, B updates
- masterCLAUDE.md: C additions, D updates
- Skipped: E items
```

---

## Step 6: masterCLAUDE.md Handling

If cross-project lessons were found (categories 5-6) but `masterCLAUDE.md` doesn't exist:

```
Cross-project lessons found but no masterCLAUDE.md exists.

masterCLAUDE.md is a company-wide knowledge base — lessons that apply to ANY project,
not just this one. Copy it to new projects to carry forward your learnings.

Create masterCLAUDE.md with these lessons? (yes / no)
```

If yes: Use the **Write** tool to create `masterCLAUDE.md` at the project root with the standard header and the proposed lessons.

---

## Step 7: Phase RETRO.md (Incremental Mode Only)

If running in incremental mode:

1. Determine the current phase folder from `.planning/STATE.md`
2. Check if `RETRO.md` already exists in the phase folder
3. If exists: **append** new lessons to the existing file (don't overwrite)
4. If not: **create** `RETRO.md` in the phase folder

### RETRO.md Structure

```markdown
# Retrospective — [Phase Name]

**Date**: [YYYY-MM-DD]
**Session scope**: [Brief description of what was built/done]

## Lessons Applied

| # | Lesson | Target | Section |
|---|--------|--------|---------|
| 1 | [Brief summary] | CLAUDE.md | [Section] |
| 2 | [Brief summary] | masterCLAUDE.md | [Section] |

## Skipped Proposals

- [Item]: [Reason skipped]

## Session Notes

[Any additional context about the session that doesn't fit into CLAUDE.md/masterCLAUDE.md but is worth recording for this phase]
```

---

## Step 8: Completion

After all items processed:

```
Retrospective complete.

- Applied: X lessons to CLAUDE.md, Y to masterCLAUDE.md
- Skipped: Z items
- Phase RETRO.md: [written/appended/skipped]

This phase's workflow is complete. Next:
- Start a new feature: /braindump <idea>
- Check project status: /workflow status
```

---

## Important Rules

- **Be specific, not vague.** Not "improve error handling" but "Database row-level security policies silently return empty arrays instead of 403 — always check `.length` on query results."
- **Evidence required.** Every proposal must cite the specific moment it was learned. No generic advice.
- **Match the style.** Read how the target file is formatted (tables, bullets, code blocks) and match it exactly.
- **Err on the side of fewer, higher-quality additions.** 3 precise lessons beat 10 vague ones.
- **Per-item confirmation is mandatory.** Never batch-apply without user seeing each item first. The user controls what goes into their knowledge files.
- **Incremental is the default when called after verification.** Full-session retro is for end-of-project or standalone invocation.
