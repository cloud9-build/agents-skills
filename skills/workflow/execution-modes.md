# Execution Modes — Context-Aware Workflow

**Purpose:** Choose the right execution strategy based on task complexity to avoid hitting context window limits.

---

## The 3 Execution Modes

Board-approved simplification (from original 5 modes). Start here for all new work.

### Mode A: Trivial — Single Session

**When to use:**
- < 5 files modified
- 1 system touched
- No architecture decisions
- Estimated < 50K tokens

**Execution pattern:**
- Work in a single Claude session
- No state files needed
- Complete from start to finish without context clearing

**Example tasks:**
- Fix a typo
- Add a console.log
- Update a single config value
- Write a small utility function

---

### Mode B: Moderate — Sub-Agents

**When to use:**
- 5-15 files modified
- 2-3 systems touched
- Minor architecture decisions
- Estimated 50K-150K tokens

**Execution pattern:**
- Delegate exploration/testing/documentation to sub-agents
- Main session handles coordination and integration
- Optional: Create HANDOFF.md if approaching 150K tokens

**Sub-agent delegation examples:**
- **Explore agents**: "Search the codebase for all authentication patterns"
- **Test agents**: "Run the test suite and report failures"
- **Doc agents**: "Write API documentation for these 3 endpoints"

**State files:**
- HANDOFF.md (optional, only if > 150K tokens)

**Example tasks:**
- Add a new API endpoint with tests
- Refactor a component and update its uses
- Implement a new database migration
- Add a feature that touches 2-3 files

---

### Mode C: Heavy — Agent Teams

**When to use:**
- 15+ files modified
- 3+ systems touched
- Significant architecture decisions
- Estimated 150K-200K tokens
- Has 2-3 independent work streams

**Execution pattern:**
- Spawn agent team with 2-4 specialized agents
- Use TEAM-MANIFEST.md for coordination
- Create HANDOFF.md for mid-build context clearing
- Main session orchestrates, delegates actual work

**Agent team patterns:**
- **Parallel streams**: Frontend agent + Backend agent + DB agent
- **Sequential handoffs**: Research agent → Plan agent → Execution agent
- **Specialized domains**: Auth agent + Payment agent + Notification agent

**State files:**
- HANDOFF.md (mandatory at 150K tokens)
- TEAM-MANIFEST.md (tracks agent assignments and status)

**Example tasks:**
- Build a full-stack feature (UI + API + database)
- Major architecture refactoring (affects 20+ files)
- Multi-system integration (auth + payments + notifications)
- New module/subsystem with multiple components

---

## Decision Tree (Quick Reference)

```
Start here: How many files will this touch?

   < 5 files?
   └─→ YES → Mode A (Single Session)
                    ↓ Execute directly
   └─→ NO → Continue...

   5-15 files?
   └─→ YES → Mode B (Sub-Agents)
                    ↓ Delegate research/tests/docs
   └─→ NO → Continue...

   15+ files?
   └─→ YES → Mode C (Agent Teams)
                    ↓ Spawn team, use TEAM-MANIFEST

Still unsure? Count systems:
   - 1 system → Mode A or B
   - 2-3 systems → Mode B
   - 3+ systems → Mode C
```

---

## Upgrading Mid-Task (Scope Creep)

If task grows beyond initial estimate:

1. **Pause** current work
2. **Write HANDOFF.md** with current state
3. **Re-classify** using decision tree
4. **Upgrade mode** if needed:
   - A → B: Start delegating to sub-agents
   - B → C: Spawn agent team, migrate work via HANDOFF

**Don't downgrade** — if you started with Mode C, stay with Mode C even if scope shrinks.

---

## Context Clearing Gate (150K Token Rule)

Regardless of mode, if you hit 150K tokens:

1. **Stop work immediately**
2. **Write HANDOFF.md** with:
   - What was completed
   - What remains
   - Critical context for resume
3. **Clear context** (start new session)
4. **Resume** by reading HANDOFF.md

**Why 150K?** Leaves 50K token buffer before hard limit, prevents emergency context loss.

---

## Mode Selection Examples (Real Tasks)

| Task Description | Files | Systems | Mode | Reason |
|------------------|-------|---------|------|--------|
| "Fix login button color" | 1 | 1 | **A** | Single CSS file, trivial |
| "Add dark mode toggle" | 8 | 2 | **B** | UI + theme context, use sub-agents for testing |
| "Implement user authentication" | 25 | 4 | **C** | Frontend + backend + DB + middleware, spawn team |
| "Update README typo" | 1 | 1 | **A** | One file, trivial |
| "Refactor API error handling" | 12 | 2 | **B** | Touches multiple endpoints, sub-agents for testing |
| "Build admin dashboard" | 35 | 5 | **C** | Full-stack feature, UI + API + auth + DB + analytics |

---

## Anti-Patterns to Avoid

**❌ Don't over-classify:**
- Simple bug fix → Don't spawn agent team
- Premature optimization → Start with lower mode, upgrade if needed

**❌ Don't under-classify:**
- 20-file refactor → Don't try single session, you'll hit context limit
- Multi-system integration → Don't skip agent teams, coordination overhead is high

**❌ Don't skip HANDOFF.md:**
- If you hit 150K tokens without HANDOFF, you'll lose context on reset
- Write HANDOFF preemptively at 120K-130K to be safe

---

## Validation Checkpoints (Board Requirement MH-3)

After your first 10 tasks using these modes:

**Track these metrics:**
- Task weight prediction accuracy (did you pick the right mode?)
- Context token usage (did you stay under 150K?)
- Mode upgrade frequency (how often did scope creep force mode change?)

**Success criteria (Board MH-4):**
- Prediction accuracy > 60% (6 out of 10 tasks classified correctly)
- Zero context overflow failures (all tasks complete without emergency resets)

**If metrics fail:**
- < 60% accuracy → Adjust classification thresholds (e.g., 10 files instead of 15 for Mode C)
- Context overflows → Lower the handoff gate (e.g., 120K instead of 150K)

---

## Templates & Tools

- **HANDOFF.md template**: See `/handoff` skill
- **TEAM-MANIFEST.md template**: See [team-manifest-template.md](./team-manifest-template.md)
- **Baseline metrics tracker**: See [baseline-metrics.md](./baseline-metrics.md)
- **Kill criteria checklist**: See [kill-criteria.md](./kill-criteria.md)

---

## Board Review Score

**Original plan:** 7.3/10 (5 modes, 3 context gates)
**Simplified plan:** 8.5/10 (3 modes, 1 handoff gate)

**Board recommendations incorporated:**
- MH-1: ✅ Reduced from 5 modes to 3
- MH-2: ✅ Collapsed 3 gates into 1 (150K token handoff)
- MH-3: ✅ Baseline metrics tracking added
- MH-4: ✅ Kill criteria defined (60% accuracy threshold)
- MH-5: ⏸️ Spike deferred (test handoff flow before production use)

---

**Last updated:** 2026-02-14 (Board-approved simplification)
