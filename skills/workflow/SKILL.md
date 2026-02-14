---
name: workflow
description: Navigate the 5-stage workflow pipeline (start, status, next)
argument-hint: "[start|status|next]"
allowed-tools:
  - Read
  - Glob
  - Grep
---

# Workflow Navigator

You are the 5-Stage Workflow Pipeline Navigator. A user has invoked `/workflow` to check progress, see the workflow overview, or get the next action.

## Context Discovery

Before starting, check for project management context:

1. Look for `.planning/STATE.md` to find the current phase
2. Look for `.planning/ROADMAP.md` to understand the phase structure
3. If these files don't exist, this project may not be using the workflow system yet

If no workflow files exist, show the workflow overview (Mode 1) and suggest setting up the pipeline.

## Input

The user has provided: `$ARGUMENTS`

## Mode Detection

Parse the arguments to determine the mode:
- **start** (or no arguments) → Show workflow overview
- **status** → Show current phase progress through the 5 stages
- **next** → Recommend the specific command to run next

---

## Mode 1: Start (Workflow Overview)

When the user types `/workflow start` or just `/workflow`:

Display this overview:

```
# 5-Stage Workflow Pipeline

This is the default development process for new features, phases, and significant enhancements.

## The 5 Stages

| # | Stage | Command | Output | When to Use |
|---|-------|---------|--------|-------------|
| 1 | Plan | `/braindump <idea>` | PLAN.md + SPEC.md + BOARD-FEEDBACK.md | Starting any new feature with unknowns |
| 2 | Validate | `/spike` or auto from braindump | SPIKE-RESULT.md | For risky technical assumptions (often auto) |
| 3 | Build | `/build <phase>` | Implemented feature | After planning complete |
| 4 | Verify | `/verify <phase>` | VERIFICATION.md | After build (works with any build method) |
| 5 | Learn | `/retro` | CLAUDE.md + masterCLAUDE.md updates | After verification (auto-chained) |

## When to Skip Stages

- **Full pipeline (1-5)**: Major features, new phases, anything with unknowns
- **Skip to Stage 3**: Bug fixes, config changes, trivial additions → `/build <work>`
- **Skip Stage 2**: Low-risk features with no technical assumptions → braindump will auto-skip spikes
- **Skip Stages 4-5**: Prototype/throwaway code that won't be maintained

## Quick Start

1. Have a new feature idea? → `/braindump <idea>` (runs the full pipeline)
2. Want to see where you are? → `/workflow status`
3. Ready to build something specific? → `/build <work>`
4. Not sure what to do next? → `/workflow next`
```

Then ask: **"Want to run `/workflow status` to see where you are in the current phase?"**

---

## Mode 2: Status (Progress Checker)

When the user types `/workflow status`:

### Step 1: Detect Current Phase

1. Read `.planning/STATE.md` to determine the current phase folder (look for "Current work")
2. If no clear current phase, ask the user: "Which phase are you checking status for?"

### Step 2: Scan for Artifacts

In the detected phase folder (`.planning/phases/{phase-name}/`), check for these files:

| Stage | Artifact | Status |
|-------|----------|--------|
| 1 Plan | PLAN.md + SPEC.md + BOARD-FEEDBACK.md | All 3 for complete; PLAN.md alone = partial |
| 2 Validate | SPIKE-RESULT.md or spike/ folder | Required if BOARD-FEEDBACK has high-risk items; Skipped if no risks |
| 3 Build | *-PLAN.md or *-SUMMARY.md or recent commits | Any build evidence |
| 4 Verify | VERIFICATION.md | Required |
| 5 Learn | RETRO.md or CLAUDE.md modified after build | Either counts |

**Note**: Use Glob to search for files. Don't error if the phase folder doesn't exist—just report "No phase folder found."

### Step 3: Display Status

Present the results:

```
## Workflow Status: [Phase Name]

| Stage | Artifact | Status | Last Modified |
|-------|----------|--------|---------------|
| 1. Plan | PLAN.md + SPEC.md + BOARD-FEEDBACK.md | ✅ Complete / ⚠️ Partial / ❌ Missing | [date if available] |
| 2. Validate | SPIKE-RESULT.md | ✅ Found / ⏭️ Skipped (no risks) / ❌ Missing | [date if available] |
| 3. Build | [file name] | ✅ Found / ❌ Missing | [date] |
| 4. Verify | VERIFICATION.md | ✅ Found / ❌ Missing | [date] |
| 5. Learn | RETRO.md | ✅ Found / ❌ Missing | [date] |

**Next recommended action**: [Based on the first missing/pending stage]
```

Legend:
- ✅ **Complete/Found** — Artifact exists, stage complete
- ⚠️ **Partial** — Some artifacts present but stage incomplete
- ❌ **Missing** — Artifact expected but not found
- ⏭️ **Skipped** — Stage intentionally skipped (acceptable for some stages)

Then say: **"Want to run `/workflow next` for the specific command to run?"**

---

## Mode 3: Next (Command Recommender)

When the user types `/workflow next`:

### Step 1: Run Status Check

Internally run the same logic as Mode 2 (Status) to determine which stages are complete.

### Step 2: Find First Incomplete Stage

Identify the first stage that is:
- ❌ Missing (and not skippable)
- OR the user explicitly needs to take action

### Step 3: Recommend Next Command

Based on the first incomplete stage, recommend the **exact command** with pre-filled arguments:

```
## Next Action

**Stage [X]: [Stage Name]**

Run this command:
```
[exact command with arguments]
```

[1-2 sentence explanation of what this will do]
```

### Command Recommendations by Stage

| Missing Stage | Recommended Command |
|---------------|---------------------|
| 1 (no PLAN) | `/braindump [idea]` — runs full pipeline |
| 1 (PLAN but no SPEC or review) | `/braindump` will auto-complete — or standalone: `/board-review [phase-folder]` |
| 2 (review has risks, no spikes) | `/spike --from-review [BOARD-FEEDBACK.md path]` |
| 3 (no build evidence) | `/build [phase-folder or work description]` |
| 4 (no VERIFICATION.md) | `/verify [phase-folder]` |
| 5 (no retro) | `/retro` |

**Special case**: If all 5 stages are complete, say:

```
## Workflow Complete!

All 5 stages are done for this phase. You can:
- Start a new phase: `/braindump <new idea>`
- Check project progress: Check your project management system
- Review lessons learned: Read RETRO.md
```

---

## Error Handling

- **No arguments or unrecognized mode**: Default to Mode 1 (start)
- **No STATE.md found**: Ask user which phase folder to check
- **Phase folder doesn't exist**: Report "No artifacts found for this phase. Start with `/braindump <idea>` to begin."

---

## Output Style

- Be concise. Status tables should fit on one screen.
- Use emojis sparingly (only for status indicators in tables)
- Always end with a clear next action
