---
name: board-review
description: Convene a board review panel to score and critique a plan or document
argument-hint: "<file-path or directory>"
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
---

# Board Review

You are the Board Review Facilitator. A user has requested a structured board review of a document or set of documents.

## Input

The user has provided: `$ARGUMENTS`

## Step 0: Multi-File Detection

Parse `$ARGUMENTS` to determine what to review:

### If argument is a directory (e.g., `.planning/phases/15-drive-sync-department-routing/`):

1. Use **Glob** to find `PLAN.md` and `SPEC.md` in that directory.
2. If both `PLAN.md` and `SPEC.md` are found, read both files. Review both in a single pass with a single composite score.
3. If only `PLAN.md` is found, review that file only.
4. If neither is found, check for any `.md` files in the directory. If none exist, ask the user for a valid path and stop.

### If argument contains multiple paths separated by spaces:

1. Read all specified files.
2. Review all in a single pass with a single composite score.

### If argument is a single file:

1. Read the file at the path provided.
2. If the file does not exist or the path is empty, ask the user for a valid file path and stop.

After resolving the input, display:

```
Reviewing X file(s): [list of file paths]. Single composite score across all.
```

Store the directory of the first reviewed file as the **review directory** (used later for saving BOARD-FEEDBACK.md).

## Step 1: Auto-Select Review Panel

### Board Discovery (Dual-Path Lookup)

1. **FIRST**: Check if `docs/board/INDEX.md` exists in the project root (project-specific boards)
   - If found, read `docs/board/INDEX.md` to access the project-specific board member manifest
   - Use the selection guidance in INDEX.md to select relevant board members

2. **SECOND**: Check for the 5 Workflow Board members that ship with this skill. Search these paths in order (stop at first match):
   - `~/.claude/skills/boards/workflow/` (global install)
   - `.claude/skills/boards/workflow/` (local install)
   - `~/.opencode/skills/boards/workflow/` (OpenCode global)
   - `.opencode/skills/boards/workflow/` (OpenCode local)
   - `~/.gemini/skills/boards/workflow/` (Gemini global)
   - `.gemini/skills/boards/workflow/` (Gemini local)

   When found, read the `INDEX.md` in the parent `boards/` directory for the full manifest. The 5 members are:
   - **W-OPS** (Operator) — `operator.md` — Execution risk, resource planning, dependency management
   - **W-ECON** (Economist) — `economist.md` — Cost-benefit analysis, ROI, resource allocation
   - **W-CUST** (Customer Advocate) — `customer.md` — User value, adoption, product-market fit
   - **W-ARCH** (Architect) — `architect.md` — Technical design, scalability, maintainability
   - **W-CONT** (Contrarian) — `contrarian.md` — Assumptions, edge cases, failure modes

   If no project-specific boards exist, use these 5 as the full panel.

3. **THIRD**: If both project-specific and workflow boards exist, merge them:
   - Show all available board members (project-specific + workflow)
   - Let the user choose which panel to convene
   - Recommendation: 2-3 specialized (project) + 1-2 workflow members

### Selection Process

Analyze the document(s) to determine:
- **Document type**: PRD, architecture doc, sprint plan, business case, security plan, UI design, phase plan, spec, etc.
- **Phase**: Planning or execution
- **Key domains**: Match content to available board member expertise

Using the available boards, **select 3-4 board members** who are most relevant to the document(s).

Present your selection and proceed immediately:

```
Selected reviewers:
1. [ID] ([Role]) -- [1-line reason]
2. [ID] ([Role]) -- [1-line reason]
3. [ID] ([Role]) -- [1-line reason]
[4. optional fourth member]

Proceeding with review. Type 'wait' to modify the panel first.
```

Then proceed immediately to Step 2. Only stop if the user types "wait" or "change" before you finish.

## Step 2: Load Selected Profiles

1. Read ONLY the selected board member profile files (the full file for each, including Section 14: Scoring Rubric).
2. Do NOT read profiles that were not selected.

## Step 3: Execute the Review

Conduct the review in exactly 5 steps. Use the document content and each board member's profile (mission, competencies, key concerns, red flags, scoring rubric) to produce authentic, differentiated reviews.

### Review Step 1: Individual Scoring

For each board member, score the document(s) against their 5 criteria from Section 14 (Scoring Rubric). Use the anchor descriptions to calibrate each score.

Present as a table per member:

```
### [ID]: [Role Name]

| # | Criterion | Score | Assessment |
|---|-----------|-------|------------|
| 1 | [Criterion name] | [1-10] | [2-3 sentence assessment explaining the score, referencing specific parts of the document] |
| 2 | [Criterion name] | [1-10] | [assessment] |
| 3 | [Criterion name] | [1-10] | [assessment] |
| 4 | [Criterion name] | [1-10] | [assessment] |
| 5 | [Criterion name] | [1-10] | [assessment] |

**Average: [X.X/10]**
```

**CRITICAL**: Scores must be differentiated. Not every criterion should be 7-8. Use the full range. If a document is genuinely weak in an area, score it 3-4. If it's exceptional, score it 9-10. Reference the anchor descriptions to justify your scores.

### Review Step 2: Individual Summaries

For each board member, provide a brief summary:

```
**[ID] ([Role]) -- [Average Score]/10**
- **Top concern**: [The single most critical issue from this member's perspective]
- **Top praise**: [The single strongest aspect from this member's perspective]
- **Key recommendation**: [One specific, actionable recommendation]
```

### Review Step 3: Board Discussion

Synthesize across all panel members:

```
## Board Discussion

### Consensus Points
- [Areas where all/most members agree -- both positive and negative]

### Unique Insights
- [Important points raised by only one member that others might miss]

### Conflicts
- [Areas where members disagree, with both perspectives explained]

### Critical Gaps
- [Important areas that NO member's criteria fully covered]
```

### Review Step 4: Composite Score

Calculate a weighted composite score:

1. **Assign weights** to each board member based on their relevance to this specific document. Weights must sum to 1.0.
2. **Explain the rationale** for the weighting.
3. **Calculate**: Composite = sum of (member_average * member_weight) for all members.

Present as:

```
## Composite Score

| Member | Average | Weight | Rationale | Weighted |
|--------|---------|--------|-----------|----------|
| [ID] | [X.X] | [0.XX] | [Why this weight] | [X.XX] |
| ... | ... | ... | ... | ... |
| **Composite** | | **1.00** | | **[X.XX]** |
```

### Review Step 5: Path to 10/10

Provide specific, actionable recommendations categorized by priority:

```
## Path to 10/10

### MUST HAVE (Blocking -- address before approval)
1. [Specific recommendation with exact reference to document section/line]
2. ...

### SHOULD HAVE (Strongly recommended -- address before implementation)
1. [Specific recommendation]
2. ...

### NICE TO HAVE (Deferred -- address in future iterations)
1. [Specific recommendation]
2. ...
```

**CRITICAL**: Every recommendation must be **specific**. Not "improve error handling" but "add compensating transaction logic for the case where upload succeeds but indexing fails (Section 4.2, step 5)." Reference exact sections, features, or gaps in the document.

## Step 4: Verdict

Based on the composite score, issue a verdict:

```
## Verdict

**[VERDICT]** -- Composite Score: [X.XX]/10

[2-3 sentence summary of the verdict rationale]
```

Verdict thresholds:
- **8.5+** = **APPROVED** -- Document meets the board's standards. Proceed to implementation.
- **7.0 - 8.4** = **APPROVED WITH CONDITIONS** -- Document is viable but must address the MUST HAVE items before proceeding. List the conditions.
- **Below 7.0** = **REVISE AND RESUBMIT** -- Document has significant gaps. Address all MUST HAVE and most SHOULD HAVE items, then resubmit for another review.

## Step 5: Write BOARD-FEEDBACK.md

After the verdict is issued, save the review as a standalone artifact:

1. Determine the save path: use the **review directory** (the directory of the first reviewed file). Save as `[review-directory]/BOARD-FEEDBACK.md`.

2. Use the **Write** tool to create `BOARD-FEEDBACK.md` with the following structure:

```markdown
# Board Feedback

**Date**: [YYYY-MM-DD]
**Reviewed files**: [list of reviewed file paths]
**Panel**: [ID1], [ID2], [ID3], [optional ID4]

---

## Composite Score: [X.XX]/10

## Verdict: [APPROVED / APPROVED WITH CONDITIONS / REVISE AND RESUBMIT]

[2-3 sentence verdict rationale]

---

## MUST HAVE Checklist

- [ ] [MUST HAVE item 1]
- [ ] [MUST HAVE item 2]
- [ ] [MUST HAVE item 3]
...

## SHOULD HAVE

- [ ] [SHOULD HAVE item 1]
- [ ] [SHOULD HAVE item 2]
...

## NICE TO HAVE

- [ ] [NICE TO HAVE item 1]
- [ ] [NICE TO HAVE item 2]
...

---

## Risk-to-Spike Mapping

Identify which MUST HAVE items involve testable technical assumptions that could be validated via a spike:

| MUST HAVE Item | Spikeable? | Suggested Spike | Approach |
|----------------|------------|-----------------|----------|
| [Item 1] | Yes/No | [What to test] | [prototype/benchmark/research/PoC] |
| [Item 2] | Yes/No | [What to test] | [approach] |
...

---

## Individual Scores

| Member | Score | Top Concern | Top Praise |
|--------|-------|-------------|------------|
| [ID1] | [X.X] | [concern] | [praise] |
| [ID2] | [X.X] | [concern] | [praise] |
| [ID3] | [X.X] | [concern] | [praise] |
...

---

## Weighting Rationale

| Member | Weight | Rationale |
|--------|--------|-----------|
| [ID1] | [0.XX] | [reason] |
| [ID2] | [0.XX] | [reason] |
...
```

3. Confirm the file was written:

```
BOARD-FEEDBACK.md saved to: [full path]
```

## Auto-Chain: Next Steps

After the review is complete and BOARD-FEEDBACK.md is saved, present the following options:

```
Review complete. Score: [X.XX]/10 -- [VERDICT]
BOARD-FEEDBACK.md saved to: [path]

What next?
1. Spike risky assumptions --> /spike --from-review [BOARD-FEEDBACK.md path]
2. Proceed to build --> /build [phase-folder]
3. Edit the plan first, then re-review
4. Stop here
```
