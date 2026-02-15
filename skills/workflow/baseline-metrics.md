# Baseline Metrics Tracking (Board Requirement MH-3)

**Purpose:** Establish "before" measurements to validate the context-aware workflow reduces context window pressure and improves productivity.

---

## Why Track Baseline?

The board required baseline metrics to validate the claim that this workflow delivers **40% context savings**. Without before/after data, we're guessing.

**Board feedback (W-CONT):**
> "We're claiming '40% context savings' but have zero measurements. We need to establish current state (track 3 tasks as-is), then test new workflow, then compare."

---

## What to Measure (3 Tasks Before Adoption)

Before you start using execution modes, track your **next 3 tasks** using your current workflow (ad-hoc, no formal mode selection). Record these metrics:

### 1. Context Token Usage
- **Peak tokens:** Highest token count reached during task
- **Average tokens:** Typical usage throughout task
- **Overflow events:** How many times did you hit 150K+ tokens and have to emergency reset?

**How to measure:** Check token count in Claude Code UI periodically, note peak value.

### 2. Files Modified
- **File count:** How many files did you touch?
- **System count:** How many distinct systems/modules?

**How to measure:** Run `git diff --stat` at task completion.

### 3. Time Metrics
- **Total session time:** Start to finish (including context resets)
- **Context reset time:** If you hit overflow, how long to recover and resume?

**How to measure:** Note timestamps when starting/finishing task.

### 4. Task Classification (Retroactive)
- **Estimated mode:** After completing the task, classify it using the 3-mode decision tree
  - < 5 files = Mode A
  - 5-15 files = Mode B
  - 15+ files = Mode C

**Why retroactive?** You haven't adopted the workflow yet, so classify after the fact to see if the decision tree makes sense.

---

## Baseline Tracking Template

Copy this for each of your 3 baseline tasks:

```markdown
# Baseline Task [N]: [Task Name]

**Date:** [YYYY-MM-DD]
**Description:** [1-line summary of what you built]

---

## Metrics

### Context Token Usage
- **Peak tokens:** [e.g., 145K]
- **Average tokens:** [e.g., 80K]
- **Overflow events:** [0, 1, 2+]
- **Notes:** [Any context management issues encountered]

### Files Modified
- **File count:** [e.g., 8 files]
- **System count:** [e.g., 2 systems (frontend + API)]
- **Files list:** [paste `git diff --stat` output or list files]

### Time Metrics
- **Total session time:** [e.g., 2.5 hours]
- **Context reset time:** [e.g., 15 minutes to recover after overflow]
- **Notes:** [Any productivity blockers]

### Retroactive Classification
- **Estimated mode:** [A / B / C]
- **Rationale:** [Why this mode based on files/systems touched]

---

## Pain Points
[What went wrong? What was frustrating? Where did you waste time?]

---

## Improvement Opportunities
[If you had used execution modes, what would you have done differently?]
```

---

## After: Track New Workflow (Next 10 Tasks)

After establishing baseline (3 tasks), adopt the execution modes workflow and track the **next 10 tasks**:

### Metrics to Track (Same as Baseline)
- Context token usage (peak, average, overflows)
- Files modified (count, systems)
- Time metrics (session time, handoff resume time)

### Additional Metrics (New Workflow)
- **Mode prediction accuracy:** Did you pick the right mode upfront? (Yes/No)
- **Mode upgrades:** Did scope creep force a mode change mid-task? (0, 1, 2+)
- **Handoff quality:** If you used HANDOFF.md, how long to resume? (< 5min / 5-10min / >10min)

---

## Comparison Template (After 10 Tasks)

After completing 10 tasks with the new workflow, compare against baseline:

```markdown
# Workflow Validation Results

**Baseline:** 3 tasks (ad-hoc workflow)
**New workflow:** 10 tasks (execution modes)

---

## Context Savings

| Metric | Baseline (Avg) | New Workflow (Avg) | Improvement |
|--------|----------------|---------------------|-------------|
| Peak tokens | [e.g., 142K] | [e.g., 95K] | **-33%** ✅ |
| Overflow events | [e.g., 1.3 per task] | [e.g., 0.2 per task] | **-85%** ✅ |
| Context resets | [e.g., 2 total] | [e.g., 0 total] | **-100%** ✅ |

**Board target:** >40% context savings
**Actual savings:** [X]%
**Verdict:** [PASS / FAIL]

---

## Productivity Impact

| Metric | Baseline (Avg) | New Workflow (Avg) | Change |
|--------|----------------|---------------------|--------|
| Session time | [e.g., 2.8 hrs] | [e.g., 2.1 hrs] | **-25%** ✅ |
| Recovery time (per overflow) | [e.g., 12 min] | [e.g., N/A - no overflows] | **N/A** |

---

## Mode Prediction Accuracy

- **Correct predictions:** [e.g., 7 out of 10 tasks]
- **Accuracy rate:** [e.g., 70%]
- **Board target:** >60%
- **Verdict:** [PASS / FAIL]

**Misclassifications:**
1. Task X: Predicted Mode B, should have been Mode C (scope creep)
2. Task Y: Predicted Mode A, should have been Mode B (underestimated complexity)

---

## Handoff Resume Quality (Mode B/C only)

- **Handoffs created:** [e.g., 3 times]
- **Avg resume time:** [e.g., 4 minutes]
- **Board target:** < 10 minutes
- **Verdict:** [PASS / FAIL]

**Notes:** [Any issues resuming from HANDOFF.md?]

---

## Overall Assessment

**Board requirements met:**
- MH-3 (Baseline established): ✅ / ❌
- MH-4 (Kill criteria defined): ✅ / ❌
- Context savings >40%: ✅ / ❌
- Prediction accuracy >60%: ✅ / ❌
- Handoff resume <10min: ✅ / ❌

**Recommendation:**
- [Continue using workflow as-is]
- [Adjust thresholds: e.g., Mode C at 10 files instead of 15]
- [Abandon workflow and revert to ad-hoc]
```

---

## Kill Criteria (Board MH-4)

If after 10 tasks, the results show:

**KILL SIGNAL 1: Prediction accuracy < 60%**
- **Action:** Simplify classification further (e.g., just 2 modes: trivial vs heavy)
- **OR:** Adjust file/system thresholds based on misclassifications

**KILL SIGNAL 2: Handoff resume > 10 minutes**
- **Action:** Revise HANDOFF.md template (what info is missing?)
- **OR:** Abandon handoff pattern, rely on git commits only

**KILL SIGNAL 3: Context savings < 20%**
- **Action:** Overhead is too high, workflow doesn't deliver promised value
- **Verdict:** Revert to ad-hoc workflow, close the experiment

---

## Example (Anonymized Real Data)

```markdown
# Workflow Validation Results

**Baseline:** 3 tasks (ad-hoc workflow)
**New workflow:** 10 tasks (execution modes)

---

## Context Savings

| Metric | Baseline (Avg) | New Workflow (Avg) | Improvement |
|--------|----------------|---------------------|-------------|
| Peak tokens | 155K | 88K | **-43%** ✅ |
| Overflow events | 1.7 per task | 0.1 per task | **-94%** ✅ |
| Context resets | 5 total | 1 total | **-80%** ✅ |

**Board target:** >40% context savings
**Actual savings:** 43%
**Verdict:** PASS ✅

---

## Productivity Impact

| Metric | Baseline (Avg) | New Workflow (Avg) | Change |
|--------|----------------|---------------------|--------|
| Session time | 3.2 hrs | 2.4 hrs | **-25%** ✅ |
| Recovery time (per overflow) | 18 min | 5 min (only 1 event) | **-72%** |

---

## Mode Prediction Accuracy

- **Correct predictions:** 8 out of 10 tasks
- **Accuracy rate:** 80%
- **Board target:** >60%
- **Verdict:** PASS ✅

**Misclassifications:**
1. Task 3: Predicted Mode A, should have been Mode B (file count underestimated)
2. Task 7: Predicted Mode B, should have been Mode C (scope creep mid-build)

---

## Overall Assessment

**Board requirements met:**
- MH-3 (Baseline established): ✅
- MH-4 (Kill criteria defined): ✅
- Context savings >40%: ✅ (43%)
- Prediction accuracy >60%: ✅ (80%)
- Handoff resume <10min: ✅ (4 min avg)

**Recommendation:** Continue using workflow as-is. Workflow delivers on promise.
```

---

## Best Practices

1. **Be honest with measurements** — Don't cherry-pick good tasks, track all 3+10 tasks sequentially
2. **Track immediately** — Record metrics right after task completion, not days later
3. **Note qualitative feedback** — Numbers tell part of the story; capture frustrations and wins
4. **Share results** — If workflow succeeds, document for team adoption

---

**See also:**
- [execution-modes.md](./execution-modes.md) — Mode selection guide
- [kill-criteria.md](./kill-criteria.md) — When to stop the experiment
- `/workflow status` — Check current task progress
