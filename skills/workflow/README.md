# 5-Stage Workflow Pipeline

Your development pipeline. One entry point, three decision points, automatic flow.

---

## How It Works

```
┌──────────────┐
│ /braindump   │  Entry point
│   <idea>     │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Interview  │  5 questions to capture the idea
│   (auto)     │
└──────┬───────┘
       │
       ▼
┌──────────────────────────┐
│  Generate PLAN.md +      │  Strategy + Acceptance Criteria
│  SPEC.md                 │
└──────┬───────────────────┘
       │
       ▼
┌──────────────────────────┐
│  Auto-select board       │  Workflow + (optional) Project-specific
│  members & run review    │
└──────┬───────────────────┘
       │
       ▼
┌──────────────────────────┐
│  BOARD-FEEDBACK.md       │  Scores + Recommendations
│  generated               │
└──────┬───────────────────┘
       │
       ▼
┌──────────────────────────┐
│  Identify risky          │  Flags technical assumptions
│  assumptions for spiking │
└──────┬───────────────────┘
       │
       ▼
    [GATE 1]  ←────────────── User decides: proceed, edit, or stop
       │
       ├─ If risks → Auto-run spikes → SPIKE-RESULT.md
       │
       └─ If no risks → Skip to build strategy
       │
       ▼
    [GATE 2]  ←────────────── User confirms build approach
       │
       ▼
┌──────────────┐
│   /build     │  Execute the work (GSD, Agent Team, Sub-Agents, Single Session, Hybrid)
│   <phase>    │
└──────┬───────┘
       │
       ▼
    [GATE 3]  ←────────────── User confirms build complete
       │
       ▼
┌──────────────┐
│   /verify    │  Test against SPEC.md (works with any build method)
│   <phase>    │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   /retro     │  Capture lessons → CLAUDE.md + masterCLAUDE.md
│   (auto)     │
└──────────────┘
```

---

## The 5 Stages

| # | Stage | Command | What It Does | Output |
|---|-------|---------|--------------|--------|
| 1 | **Plan** | `/braindump <idea>` | 5-question interview → PLAN.md + SPEC.md → board review → spike identification | PLAN.md, SPEC.md, BOARD-FEEDBACK.md |
| 2 | **Validate** | `/spike` (or auto) | Run proof-of-concept on risky technical assumptions | SPIKE-RESULT.md |
| 3 | **Build** | `/build <phase>` | Execute the work (5 build strategies available) | Implemented feature |
| 4 | **Verify** | `/verify <phase>` | Test against SPEC.md acceptance criteria | VERIFICATION.md |
| 5 | **Learn** | `/retro` (auto after verify) | Audit session → extract lessons → apply to CLAUDE.md/masterCLAUDE.md | RETRO.md, updated CLAUDE.md |

---

## What Each Stage Does

### Stage 1: Plan

**Command:** `/braindump <idea>`

**Flow:**
1. 5-question interview captures your idea
2. Generates PLAN.md (strategy: problem, solution, risks, dependencies)
3. Generates SPEC.md (acceptance criteria, tests, verification checklist)
4. Auto-selects board members (2-3 specialized + 1-2 workflow)
5. Runs board review on both files
6. Generates BOARD-FEEDBACK.md with scores and recommendations
7. Identifies risky assumptions for spiking

**Gate 1:** User decides — proceed, edit files, or stop

### Stage 2: Validate

**Command:** `/spike` (or auto from braindump)

**When it runs:**
- Auto-triggered by braindump if BOARD-FEEDBACK flags high-risk assumptions
- Manually invoked for any technical unknowns

**What it does:**
- Runs proof-of-concept code or research on risky assumptions
- Validates hypotheses (e.g., "Can this API handle our latency target?")
- Documents findings in SPIKE-RESULT.md
- Updates confidence levels on assumptions

**Gate 2:** User confirms — build strategy recommendation

### Stage 3: Build

**Command:** `/build <phase>`

**Build strategies:**
- **GSD**: Phased project work with formal plans and wave ordering
- **Agent Team**: 2-5 specialists coordinate in parallel
- **Sub-Agents**: Parallel independent work, no coordination
- **Single Session**: Bug fixes, config changes, 1-3 files
- **Hybrid**: Research phase first, then team implementation

**Outputs:** Implemented feature + build artifacts (*-PLAN.md, *-SUMMARY.md)

**Gate 3:** User confirms build complete → auto-triggers verify

### Stage 4: Verify

**Command:** `/verify <phase>` (auto-triggered after build)

**What it does:**
- Loads SPEC.md acceptance criteria
- Tests each criterion (automated tests, manual verification, code inspection)
- Generates VERIFICATION.md with pass/fail per criterion
- Auto-chains to `/retro` when complete

### Stage 5: Learn

**Command:** `/retro` (auto-triggered after verify)

**What it does:**
- Audits the session for lessons learned
- Categorizes: Architecture Patterns, Pitfalls, Constraints, Decisions (CLAUDE.md) + Tool/Workflow lessons (masterCLAUDE.md)
- Deduplicates against existing knowledge
- Presents proposals one-by-one for user confirmation
- Applies approved lessons via Edit tool
- Generates phase RETRO.md summary

---

## When to Skip Stages

| Situation | What To Do |
|-----------|------------|
| **Major feature with unknowns** | Full pipeline (1-5) — start with `/braindump` |
| **Bug fix, config change, trivial addition** | Skip to Stage 3 — run `/build <work>` directly |
| **Low-risk feature** | Braindump auto-skips Stage 2 (spikes) if no risks |
| **Prototype/throwaway code** | Skip Stages 4-5 (verify + retro) — not worth testing/documenting |
| **Research-only spike** | Run `/spike` standalone, skip 1/3/4/5 |

---

## Quick Commands

| Command | When to Use |
|---------|-------------|
| `/braindump <idea>` | Starting a new feature/phase with unknowns |
| `/spike` | Validate a risky technical assumption |
| `/build <work>` | Execute a build (any strategy) |
| `/verify <phase>` | Test against acceptance criteria |
| `/retro` | Capture lessons learned |
| `/workflow status` | See progress through the 5 stages |
| `/workflow next` | Get the next recommended command |
| `/handoff` | Capture context before clearing session |
| `/board-review <file>` | Run a standalone board review |

---

## What Gets Created

| File | Created By | Contains |
|------|-----------|----------|
| `PLAN.md` | `/braindump` | Problem, solution, risks, dependencies, success criteria |
| `SPEC.md` | `/braindump` | Acceptance criteria, test scenarios, verification checklist |
| `BOARD-FEEDBACK.md` | `/braindump` | Board scores (1-10 per criterion), recommendations, verdict |
| `SPIKE-RESULT.md` | `/spike` | Hypothesis, experiment, findings, confidence update |
| `*-PLAN.md` | `/build` (GSD) | Detailed execution plan (waves, tasks, dependencies) |
| `*-SUMMARY.md` | `/build` | Build completion summary |
| `VERIFICATION.md` | `/verify` | Test results per acceptance criterion (pass/fail) |
| `RETRO.md` | `/retro` | Lessons applied, skipped proposals, session notes |
| `HANDOFF.md` | `/handoff` | Current state, next step, context for resume, warnings |

---

## The Board System

### 3-Tier Board Structure

1. **Workflow Board** (ships with this repo)
   - 5 project-agnostic members: Operator, Economist, Customer, Architect, Contrarian
   - Universal lenses that apply to any project
   - Located in `skills/boards/workflow/`

2. **Project-Specific Boards** (generated per-project)
   - Planning Board: Business-heavy (CTO, PM, Finance, Sales, Compliance, CS)
   - Execution Board: Technical-heavy (CTO, PO, Engineers, Designers, Security)
   - Generated using prompts in `skills/boards/prompts/`
   - Located in your project's `docs/board/`

3. **Mixed Reviews** (best practice)
   - 2-3 specialized members (from your project boards)
   - 1-2 workflow members (from this repo)
   - Balances domain expertise with universal challenge

### How to Generate Project Boards

1. Run the "Design Advisory Boards" prompt (`skills/boards/prompts/01-design-advisory-boards.md`) with your PRD
2. Run the "Create Board Member Profiles" prompt (`skills/boards/prompts/02-create-board-member-profiles.md`)
3. Add them to your project's `docs/board/INDEX.md`

See `skills/boards/templates/` for example profiles.

---

## Build Strategies Explained

### Single Session
- **Use for:** Bug fixes, config changes, 1-3 file edits
- **How it works:** One focused session, direct implementation
- **Output:** Code changes

### Sub-Agents
- **Use for:** Parallel independent work (no coordination needed)
- **How it works:** Spawn 2-5 agents with separate tasks
- **Output:** Multiple deliverables, no cross-talk
- **Example:** "Write API docs, create DB migration, build UI component" (all independent)

### Agent Team
- **Use for:** Parallel work requiring coordination
- **How it works:** Spawn 2-5 specialists who share context and communicate
- **Output:** Integrated deliverables
- **Example:** "Backend engineer + frontend engineer building a feature together"

### GSD (Get Stuff Done)
- **Use for:** Phased project work with dependencies
- **How it works:** Waves of work ordered by dependencies, formal planning
- **Output:** *-PLAN.md + *-SUMMARY.md per wave
- **Example:** "Phase 1: Auth foundation → Phase 2: Document ingestion → Phase 3: Chat interface"

### Hybrid
- **Use for:** Research → implementation flow
- **How it works:** Research phase (single session or spike) → team implementation
- **Output:** Research findings + implemented feature
- **Example:** "Spike: evaluate 3 vector DB options → Agent team: implement chosen solution"

---

## Utility Commands

### `/handoff`
Captures current state before clearing context. Writes HANDOFF.md with:
- Current state (what's done, what files changed)
- Next step (immediate next action)
- Context for resume (files to read, decisions made, gotchas)
- Warnings (blockers, edge cases, things to avoid)

### `/blueprint`
Generates a comprehensive technical implementation plan with:
- Component tree
- Data flow diagrams
- API contracts
- State machine diagrams
- File structure
- Test plan
- Performance budget

Used before `/build` for complex features.

### `/board-review <file-path>`
Runs a standalone board review on any document (plan, architecture, spec, PRD).
- Auto-recommends 3-4 board members
- User confirms or modifies panel
- Each member scores independently (1-10 per criterion)
- Board discusses findings
- Composite score + path to 10/10
- Verdict: APPROVED / APPROVED WITH CONDITIONS / REVISE AND RESUBMIT

---

## Knowledge Files

### CLAUDE.md
**Location:** Project root

**Purpose:** Project-specific instructions for Claude Code

**What goes here:**
- Tech stack decisions
- Architecture patterns specific to this project
- Pitfalls and gotchas encountered
- Key project decisions and why
- File structure conventions
- Development workflow

### masterCLAUDE.md
**Location:** Project root (optional, copy to new projects)

**Purpose:** Cross-project universal lessons

**What goes here:**
- Tool/framework gotchas that apply anywhere
- CLI quirks, SDK behaviors, library version issues
- Workflow improvements for any Claude Code session
- Prompting patterns, debugging approaches
- General best practices

**Usage:** Copy this file to every new project to carry forward learnings.

---

## Integration with Other Systems

### With Your Project Management Tool

The workflow pipeline is project-management-agnostic. It produces artifacts (PLAN.md, SPEC.md, VERIFICATION.md) that can be tracked in:
- GitHub Issues/Projects
- Jira
- Linear
- Notion
- Asana
- Or any other system

**Best practice:** Link workflow artifacts to your PM tool items.

### With God Mode (if available)

- `/build` can route to GSD for full-phase execution
- God Mode coordinates parallel terminals running builds
- `/workflow` tracks progress across the pipeline

### With Version Control

- All artifacts (PLAN.md, SPEC.md, etc.) should be committed
- `/retro` updates CLAUDE.md — commit after each retro
- Board reviews can gate PR merges

---

## Workflow Examples

### Example 1: New Feature with Unknowns

```
User: /braindump Add real-time collaborative editing

[5-question interview runs]
[PLAN.md + SPEC.md generated]
[Board review runs → BOARD-FEEDBACK.md]
[Risky assumptions flagged: "WebSocket connection stability at 100+ concurrent users"]

→ GATE 1: User confirms "proceed"

[Auto-spike runs on WebSocket scalability]
[SPIKE-RESULT.md: "Tested with 200 simulated users, latency <50ms, stable"]

→ GATE 2: User confirms "build with Agent Team strategy"

User: /build collaborative-editing

[Agent team spawns: backend-developer + frontend-developer]
[Feature implemented]

→ GATE 3: Auto-triggers /verify

[VERIFICATION.md: All 12 acceptance criteria pass]

[Auto-triggers /retro]

[5 lessons extracted, 3 applied to CLAUDE.md, 1 to masterCLAUDE.md, 1 skipped]

✅ Workflow complete
```

### Example 2: Bug Fix (Skip to Build)

```
User: /build Fix CORS error on /api/upload endpoint

[Single session build]
[Fix implemented in 1 file]

User: Done

[User manually tests → works]

[Skips /verify and /retro for simple fixes]
```

### Example 3: Research Spike Only

```
User: /spike Can we use serverless edge functions for scheduled jobs?

[Spike runs]
[SPIKE-RESULT.md: "Yes, supports cron scheduling, tested with 5-minute interval"]

[No build follows — spike answered the question]
```

---

## Getting Started

### First Time Setup

1. Copy this workflow skill to your agents-skills repo
2. Run `/workflow start` to see the overview
3. (Optional) Generate project-specific boards using the prompts in `skills/boards/prompts/`

### Starting Your First Feature

```
/braindump <your idea>
```

That's it. The pipeline guides you through the rest.

### Checking Status Anytime

```
/workflow status  # See where you are in the 5 stages
/workflow next    # Get the next recommended command
```

---

## Philosophy

The 5-Stage Workflow Pipeline is designed around three principles:

1. **One entry point** — `/braindump` starts everything. No need to remember 10 different commands.

2. **Automatic flow with gates** — The pipeline auto-chains stages but pauses at 3 decision points for user confirmation.

3. **Continuous learning** — Every build captures lessons and applies them to knowledge files, so the system gets smarter over time.

It's not a rigid process. Skip stages when appropriate. But for features with unknowns, the full pipeline prevents the "we should have planned this" moments.

---

**Ready to start?**

Run `/workflow start` or `/braindump <idea>` to begin.
