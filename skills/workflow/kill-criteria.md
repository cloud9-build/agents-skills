# Kill Criteria Checklist (Board Requirement MH-4)

**Purpose:** Pre-defined failure conditions that trigger stopping the workflow experiment. Prevents sunk-cost fallacy ("we've invested so much, let's keep trying even though it's not working").

---

## Why Kill Criteria Matter

**Board feedback (W-CONT):**
> "What's the 'stop' signal? If there's no pre-defined exit criteria, we'll keep pouring resources into a sinking ship out of sunk cost fallacy."

Kill criteria force **honest evaluation** after early checkpoints. If the workflow doesn't deliver promised benefits, abandon it quickly rather than waste time optimizing a broken approach.

---

## The 3 Kill Signals

### Kill Signal 1: Mode Prediction Accuracy < 60%

**Measurement checkpoint:** After 10 tasks using execution modes

**What to measure:**
- How many tasks were classified correctly upfront? (Right mode chosen based on file count/systems)
- Misclassification = you picked Mode A but should have used Mode B, or picked Mode B but hit Mode C complexity

**Board threshold:** Must achieve ≥ 60% accuracy (6 out of 10 tasks classified correctly)

**If failed (<6 correct):**
- **Option A:** Simplify to 2 modes only (Trivial vs Heavy, eliminate Moderate)
- **Option B:** Adjust thresholds (e.g., Mode C at 10 files instead of 15)
- **Option C:** Kill the experiment — classification is too subjective, revert to ad-hoc workflow

**Example failure:**
```
Tasks 1-10 classification results:
✅ Task 1: Mode A predicted, Mode A actual (Correct)
❌ Task 2: Mode A predicted, Mode B actual (Wrong - underestimated)
✅ Task 3: Mode B predicted, Mode B actual (Correct)
❌ Task 4: Mode B predicted, Mode C actual (Wrong - scope creep)
❌ Task 5: Mode A predicted, Mode B actual (Wrong)
✅ Task 6: Mode C predicted, Mode C actual (Correct)
❌ Task 7: Mode B predicted, Mode A actual (Wrong - over-classified)
✅ Task 8: Mode B predicted, Mode B actual (Correct)
❌ Task 9: Mode A predicted, Mode B actual (Wrong)
✅ Task 10: Mode C predicted, Mode C actual (Correct)

Accuracy: 5/10 = 50% < 60% threshold → KILL SIGNAL TRIGGERED
```

---

### Kill Signal 2: Handoff Resume Time > 10 Minutes

**Measurement checkpoint:** After each HANDOFF.md usage (Mode B/C tasks that hit 150K tokens)

**What to measure:**
- Time from "read HANDOFF.md" to "productive work resumed" in new session
- Includes: reading the doc, understanding context, finding files, getting oriented

**Board threshold:** Must achieve ≤ 10 minute average resume time

**If failed (>10 min):**
- **Option A:** Revise HANDOFF.md template (what critical info is missing?)
- **Option B:** Add "Files to Read First" checklist to template
- **Option C:** Kill the handoff pattern — if it takes >10min to resume, the overhead negates the benefit

**Example failure:**
```
Handoff 1: Resume time = 12 minutes (read doc, hunted for files, re-read 3 files to understand context)
Handoff 2: Resume time = 8 minutes (doc was clear, quick resume)
Handoff 3: Resume time = 15 minutes (doc missing critical architecture decision)

Average: 11.7 minutes > 10 minute threshold → KILL SIGNAL TRIGGERED
```

**Why 10 minutes?**
- Emergency context reset wastes ~15-20 minutes (re-reading files, reorienting)
- If handoff takes >10min, we're not saving time vs emergency reset
- Board set 10min as "reasonable overhead for planned handoff"

---

### Kill Signal 3: Context Savings < 20%

**Measurement checkpoint:** After 10 tasks using execution modes, compare vs 3-task baseline

**What to measure:**
- Peak token usage: Baseline average vs New workflow average
- Context overflow frequency: Baseline events vs New workflow events

**Board threshold:** Must achieve ≥ 20% reduction in peak token usage (40% target, 20% minimum)

**If failed (<20% savings):**
- **Diagnosis:** Overhead of state management (HANDOFF.md, TEAM-MANIFEST.md, mode classification) is consuming the gains from context clearing
- **Verdict:** Workflow doesn't deliver promised value
- **Action:** Kill the experiment, revert to ad-hoc workflow

**Example failure:**
```
Baseline (3 tasks):
- Avg peak tokens: 155K
- Overflow events: 5 total (1.7 per task)

New workflow (10 tasks):
- Avg peak tokens: 140K
- Overflow events: 3 total (0.3 per task)

Context savings: (155K - 140K) / 155K = 9.7% < 20% threshold → KILL SIGNAL TRIGGERED
```

**Why 20% minimum?**
- Original claim was 40% savings
- Board skeptical, set 20% as "acceptable compromise"
- If we can't even hit 20%, the workflow is net-negative (overhead > benefit)

---

## Checkpoint Schedule

| Checkpoint | When | What to Measure | Pass Threshold | Fail Action |
|------------|------|-----------------|----------------|-------------|
| **CP1: Early signal** | After task 3 | Mode prediction accuracy on first 3 tasks | ≥ 2/3 correct (67%) | Adjust thresholds before continuing |
| **CP2: Handoff quality** | After first HANDOFF.md use | Resume time in new session | ≤ 10 minutes | Revise template |
| **CP3: Final validation** | After task 10 | All 3 kill signals | All pass | Continue or kill |

**CP1 rationale:** Catch major issues early (after 3 tasks) rather than waiting for 10

**CP2 rationale:** First handoff is most critical — if resume fails badly, fix before next handoff

**CP3 rationale:** Final go/no-go decision after statistically significant sample (10 tasks)

---

## Decision Matrix (After CP3)

| Kill Signal | Result | Verdict |
|-------------|--------|---------|
| All 3 PASS | Workflow delivers value | ✅ **Continue** — workflow is proven |
| 2 PASS, 1 FAIL | Mixed results | ⚠️ **Iterate** — fix the failing metric, retest 5 more tasks |
| 1 PASS, 2 FAIL | Workflow struggling | ❌ **Kill likely** — too many issues, high effort to fix |
| All 3 FAIL | Complete failure | ❌ **Kill immediately** — workflow is broken, revert to ad-hoc |

**Iterate example:**
- Prediction accuracy: PASS (75%)
- Handoff resume: FAIL (12 min avg)
- Context savings: PASS (35%)

**Action:** Revise HANDOFF.md template, test on 5 more tasks, re-measure handoff resume time. If still >10min, kill the handoff pattern but keep mode classification.

---

## Anti-Patterns to Avoid

**❌ Rationalizing failure:**
- "We only missed 60% by a little, let's keep going" → NO. Board set thresholds for a reason.
- "The workflow will improve with practice" → Maybe, but test that hypothesis with a 5-task extension, don't assume.

**❌ Cherry-picking tasks:**
- "Let's only measure easy tasks where the workflow works well" → NO. Track all tasks sequentially.

**❌ Moving the goalposts:**
- "Actually 20% context savings is fine, we don't need 40%" → NO. If you can't hit the minimum threshold, the workflow is failing.

---

## If You Kill the Workflow

**Steps to revert:**

1. **Stop creating state files** — Delete `.planning/workflow-state/` directory
2. **Revert skill changes** — If /braindump or /workflow were modified, git revert
3. **Document the failure** — Write a brief post-mortem:
   - What we tried (execution modes, handoff pattern, 3-mode classification)
   - What failed (which kill signals triggered)
   - Why it failed (overhead too high, prediction too hard, etc.)
   - Lessons learned (what would we do differently next time)

4. **Communicate** — If team members adopted the workflow, notify them it's deprecated

**No shame in killing** — Failed experiments teach us what doesn't work. The board prefers fast failure over slow death.

---

## Example Kill Decision (Contrived)

```markdown
# Workflow Kill Decision — 2026-02-14

**Checkpoint 3 results (after 10 tasks):**

| Kill Signal | Threshold | Actual | Status |
|-------------|-----------|--------|--------|
| Prediction accuracy | ≥ 60% | 45% | ❌ FAIL |
| Handoff resume time | ≤ 10 min | 13 min | ❌ FAIL |
| Context savings | ≥ 20% | 12% | ❌ FAIL |

**Verdict:** All 3 kill signals triggered. Workflow experiment is terminated.

**Root causes:**
1. **Prediction accuracy (45%):** File count is poor proxy for complexity. Tasks with 8 files ranged from Mode A (trivial config changes) to Mode C (full refactor). Classification is too subjective.
2. **Handoff resume (13 min):** HANDOFF.md template is too verbose, takes too long to read. Missing "Start here" section for immediate action.
3. **Context savings (12%):** Overhead of mode classification (5-10 min per task) + HANDOFF creation (10 min) consumes gains from context clearing.

**Action:** Kill the workflow, revert to ad-hoc. Document failure in `RETRO.md`.

**Lessons learned:**
- File count alone doesn't predict complexity
- Handoff docs need "TL;DR" section for fast resume
- Workflow overhead must be < 10% of task time to be viable
```

---

## Summary

**Board-mandated kill criteria:**
- MH-4 requires **pre-defined exit conditions**
- Prevents sunk-cost fallacy and wasted effort
- Forces honest evaluation at checkpoints

**The 3 kill signals:**
1. Prediction accuracy < 60% (Mode classification is broken)
2. Handoff resume > 10 min (HANDOFF.md overhead too high)
3. Context savings < 20% (Workflow doesn't deliver value)

**Checkpoint schedule:**
- CP1: After 3 tasks (early warning)
- CP2: After first handoff (quality check)
- CP3: After 10 tasks (final go/no-go)

**If workflow fails:** Document why, revert changes, move on. Fast failure is better than slow death.

---

**See also:**
- [baseline-metrics.md](./baseline-metrics.md) — How to measure kill signals
- [execution-modes.md](./execution-modes.md) — The workflow being tested
- Board feedback: [BOARD-FEEDBACK.md](../../.planning/phases/workflow-evolution/BOARD-FEEDBACK.md)
