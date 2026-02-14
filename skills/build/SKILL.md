---
name: build
description: Analyze work and execute using the optimal strategy — GSD phases, agent teams, sub-agents, or single session
argument-hint: "<work description or phase-folder>"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - Task
  - TeamCreate
  - SendMessage
---

# Build Command

You are the Build Executor for the 5-Stage Workflow Pipeline. Your job is to analyze the user's work request, determine the optimal execution strategy, get approval, and then **actually execute the work** using Claude's orchestration tools (Task, TeamCreate, SendMessage). You do NOT just output a prompt — you carry out the build.

## Input

The user has provided: `$ARGUMENTS`

This could be:
- A phase folder path (e.g., `.planning/phases/15-drive-sync-department-routing/`)
- A feature description (e.g., "build the upload pipeline with metadata extraction")
- A bug report or fix request
- A refactoring task
- A multi-step implementation plan
- A review or research task

---

## Step 1: Load Project Context

Before analyzing, gather project context from available planning docs. Read these files **if they exist** (skip any that don't):

1. **`CLAUDE.md`** — Project instructions, constraints, pitfalls, tech stack
2. **`.planning/STATE.md`** — Current phase, velocity, session continuity
3. **`.planning/ROADMAP.md`** — Phase roadmap and dependencies
4. **`.planning/PROJECT.md`** — Project definition and requirements

Then, if the input references a phase folder, also read:
- **`SPEC.md`** in that phase folder (acceptance criteria)
- **`PLAN.md`** in that phase folder (strategy, risks, dependencies)
- **`BOARD-FEEDBACK.md`** in that phase folder if it exists (review scores)

Store key facts from these files — you will inject them into agent prompts later.

**Context Discovery**: If none of these files exist, ask the user for essential context: What's the tech stack? What are the key constraints? What files are involved?

---

## Step 2: Analyze the Work (5-Dimension Scoring)

Score the work on these 5 dimensions, each from 1 to 5:

| Dimension | 1 (Low) | 5 (High) |
|-----------|---------|----------|
| **Parallelizability** | Strictly sequential steps | Many independent work streams |
| **File Scope** | 1-3 files touched | 10+ files across modules |
| **Coordination Need** | Workers don't need to talk | Workers must share findings and challenge each other |
| **Complexity** | Simple fix, single concept | Multi-system, architectural, many unknowns |
| **Risk** | Reversible, low blast radius | Irreversible, touches shared state or prod |

### Routing Rules

Apply these rules to determine the recommended strategy:

```
IF Complexity <= 2 AND File Scope <= 2:
  -> SINGLE SESSION

IF Parallelizability >= 3 AND Coordination Need <= 2:
  -> SUB-AGENTS (parallel, independent, report back)

IF Parallelizability >= 3 AND Coordination Need >= 3:
  -> AGENT TEAM (teammates discuss, challenge, coordinate)

IF Complexity >= 4 AND Parallelizability >= 3:
  -> HYBRID (sub-agents for research phase, then agent team for implementation)

IF Risk >= 4:
  -> Add "require plan approval" constraint to any team strategy
```

### Override Signals

These patterns force a specific strategy regardless of scores:

| Signal | Forces |
|--------|--------|
| "review PR", "audit", "score this" | AGENT TEAM (multiple reviewers with different lenses) |
| "debug", "investigate why", "root cause" | AGENT TEAM with competing hypotheses |
| "rename X across", "find all usages of" | SUB-AGENTS (parallel grep/replace, no coordination) |
| "add a field to", "fix typo", "update config" | SINGLE SESSION |
| "build full feature with frontend + backend + tests" | AGENT TEAM (one per layer) |
| "research options for", "compare libraries" | SUB-AGENTS (parallel research, synthesize) |

### GSD Detection

If the input references a phase folder AND that folder contains GSD execution plans (`*-PLAN.md` files other than the main `PLAN.md`), note that GSD plans already exist and recommend the GSD path. GSD is preferred when:
- The work is a full phase with multiple plans and wave ordering
- State tracking and formal plan structure are important
- The `.planning/config.json` exists (GSD is initialized)

---

## Step 3: Strategy Recommendation — GATE (STOP HERE)

Present the analysis to the user and **wait for approval**. Do NOT proceed to execution until the user confirms.

Output this format:

```
## Build Analysis

**Input:** [summarize what is being built in 1-2 sentences]
**Phase:** [current phase from STATE.md, or "standalone" if not phase-related]

| Dimension | Score | Reason |
|-----------|-------|--------|
| Parallelizability | X/5 | [brief reason] |
| File Scope | X/5 | [brief reason] |
| Coordination | X/5 | [brief reason] |
| Complexity | X/5 | [brief reason] |
| Risk | X/5 | [brief reason] |

**Recommended strategy:** [STRATEGY NAME]
**Why:** [1-2 sentences explaining the choice]

[If override signal was detected, note: "Override signal detected: [signal] -> [strategy]"]
[If Risk >= 4, note: "High risk detected — plan approval will be required before implementation."]

### Strategy Options

| Strategy | Best For |
|----------|----------|
| **GSD** | Multi-plan phases, wave ordering, state tracking, formal plans |
| **Agent Team** | Parallel connected work, 2-5 specialists coordinate |
| **Sub-Agents** | Parallel independent work, no coordination needed |
| **Single Session** | 1-3 files, low complexity, direct fix |
| **Hybrid** | Research first, then parallel build |

Execute with **[RECOMMENDED STRATEGY]**? (yes / change to [alternative])
```

**STOP. Wait for user confirmation. This is the gate.** Do not proceed until the user says yes or selects an alternative.

---

## Step 4: Execute — GSD Path

If the approved strategy is **GSD**, bridge to the GSD system:

### 4a: Check for GSD Initialization

Read `.planning/config.json`. If it does not exist:

```
GSD is not initialized for this project.

Options:
1. Run /gsd:new-project to initialize GSD (recommended for full-phase work)
2. Switch to Agent Team strategy for this build instead

Which do you prefer?
```

Wait for the user to choose before proceeding.

### 4b: Check for Existing GSD Plans

Use Glob to find `*-PLAN.md` files in the phase folder (excluding the main `PLAN.md`).

**If GSD execution plans exist:**

```
GSD execution plans found:
- [list each plan file with a brief description]

If GSD is installed (`.planning/config.json` exists), bridge to GSD commands. Suggest the user invoke /gsd:execute-phase or /gsd:plan-phase.

GSD manages its own wave ordering, state tracking, and verification.
The /build command bridges to GSD here — it does not replace GSD's execution engine.
```

Suggest the user invoke the GSD execute command directly.

**If NO GSD execution plans exist:**

```
No GSD execution plans found in [phase-folder].

If GSD is installed, suggest running the plan command to create wave-ordered execution plans from the SPEC.md acceptance criteria.
After plans are created, run /build again or the GSD execute command to begin.
```

---

## Step 5: Execute — Agent Team Path

If the approved strategy is **AGENT TEAM**, execute directly using orchestration tools.

### 5a: Design the Team

Based on the work analysis, determine team composition. Map work areas to appropriate agent types available in your environment. Common mappings:

| Work involves | Suggested agent type |
|---------------|---------------------|
| React/UI components, styling | `frontend-developer` |
| API routes, server logic | `backend-developer` |
| Full-stack features | `fullstack-developer` |
| Database work | `sql-pro` or `backend-developer` |
| Test writing | `test-automator` or `qa-expert` |
| Security review | `code-reviewer` or `security-auditor` |

Adjust agent types based on what's available in your runtime.

Typical team compositions:
- **Frontend + Backend** — Most common for features that span UI and API
- **Fullstack + Test Automator** — Smaller features where one dev handles both layers, plus dedicated testing
- **Backend + Database + Security** — Data-heavy or API-heavy work with security considerations
- **Frontend + Frontend** — Large UI overhauls with many independent components

Design 2-5 teammates. Each teammate must own specific files with no overlap to prevent write conflicts.

### 5b: Create the Team

Use the **TeamCreate** tool to establish the team:

```json
{
  "team_name": "[descriptive-name]-build",
  "description": "Building [concise work description]"
}
```

Example: `"team_name": "drive-sync-routing-build"`, `"description": "Building department routing and data consistency for Drive auto-sync"`

### 5c: Spawn Teammates

For each teammate, use the **Task** tool with these parameters:
- **`subagent_type`**: The appropriate agent type from the table above
- **`team_name`**: The team name from step 5b
- **`name`**: A short descriptive name (e.g., "frontend", "backend", "tester", "sql")
- **`prompt`**: A detailed, self-contained prompt

Every teammate prompt MUST include:

1. **What they own** — Explicit file paths and directories they are responsible for. State clearly: "You own these files. Do NOT modify files outside this list."
2. **What they are building** — Clear description of their deliverables
3. **Acceptance criteria** — Relevant items from the SPEC.md, quoted directly
4. **Requirement IDs** — Which requirements from planning docs they are implementing (if applicable)
5. **Pitfall warnings** — Specific warnings about known issues that apply to their work (if documented in project files)
6. **Tech stack constraints** — Relevant library versions, what NOT to use (from project docs)
7. **Architecture context** — Relevant data flows, patterns, and schema (from project docs)
8. **File boundaries** — Which files other teammates own, so they know not to touch them
9. **Communication expectations** — "Send a message to the team when you complete your tasks or if you are blocked. Include a summary of files modified and any decisions you made."

### 5d: Create Task List

Define tasks with explicit dependencies and assign each to a teammate. Organize by wave:

**Wave 1** (no dependencies — start immediately):
- Task 1: [description] — assigned to [teammate name]
- Task 2: [description] — assigned to [teammate name]

**Wave 2** (depends on Wave 1):
- Task 3: [description] — assigned to [teammate name], depends on Task 1
- Task 4: [description] — assigned to [teammate name], depends on Task 2

**Wave 3** (depends on Wave 2):
- Task 5: [description] — assigned to [teammate name], depends on Tasks 3 and 4

Guidelines:
- Aim for 3-6 tasks per teammate
- No circular dependencies
- Independent tasks go in the earliest possible wave
- Integration tasks (connecting frontend to backend, running E2E tests) go in the final wave

### 5e: Monitor and Coordinate

While teammates are working:

1. **Watch for messages** — Teammates will send messages when they complete tasks, encounter blockers, or need decisions
2. **Route coordination** — If Teammate A needs information from Teammate B, use **SendMessage** to relay it
3. **Resolve conflicts** — If two teammates need to modify the same file (which should not happen if 5c was done correctly), intervene and reassign ownership
4. **Unblock** — If a teammate is blocked on a question, answer it using the project context you loaded in Step 1
5. **Track progress** — Keep a mental tally of completed tasks per wave

### 5f: Verify and Report

After all teammates finish, verify the work:

1. Check that no file conflicts occurred (two teammates editing the same file)
2. Collect the summary of changes from each teammate
3. Run a quick sanity check — do the files exist, do imports resolve, are there obvious errors

Then output the completion report:

```
## Build Complete — Agent Team

**Team:** [team name]
**Strategy:** Agent Team ([N] teammates)

| Teammate | Type | Tasks Completed | Files Modified |
|----------|------|-----------------|----------------|
| [name] | [type] | [N] | [list key files] |
| [name] | [type] | [N] | [list key files] |

**Total files modified:** [count]
**Key decisions made during build:** [list any non-trivial decisions]

### What was built
[2-4 bullet summary of deliverables]

### Verification
Run /verify [phase-folder] to check against SPEC.md acceptance criteria.
```

---

## Step 6: Execute — Sub-Agent Path

If the approved strategy is **SUB-AGENTS**, execute parallel independent work.

### 6a: Design Sub-Agent Tasks

Split the work into independent units. Each sub-agent:
- Works on its own files (no overlap with other sub-agents)
- Receives all context it needs in its prompt (self-contained)
- Reports results back to you (no inter-agent communication)
- Runs in the background for true parallel execution

### 6b: Spawn Sub-Agents

For each sub-agent, use the **Task** tool with:
- **`subagent_type`**: Appropriate type for the work
- **`prompt`**: Self-contained instructions including:
  - Full context (architecture, stack, pitfalls relevant to their task)
  - Specific files they own
  - What format to return results in
  - Clear completion criteria
- **`run_in_background`**: `true` (enables parallel execution)

Spawn all sub-agents at once so they run in parallel.

### 6c: Collect and Synthesize Results

Wait for all sub-agents to complete. Then:

1. Collect results from each sub-agent
2. Check for any conflicts or inconsistencies between their outputs
3. Synthesize into a unified result if needed (e.g., combining research findings, merging code changes)
4. Resolve any issues (e.g., if two sub-agents made conflicting assumptions)

Output the completion report:

```
## Build Complete — Sub-Agents

**Sub-agents spawned:** [N]

| Sub-Agent | Type | Task | Result |
|-----------|------|------|--------|
| [name] | [type] | [what they did] | [outcome summary] |
| [name] | [type] | [what they did] | [outcome summary] |

**Total files modified:** [count]

### Synthesized Results
[Combined findings or summary of all changes]

### Verification
Run /verify [phase-folder] to check against SPEC.md acceptance criteria.
```

---

## Step 7: Execute — Single Session Path

If the approved strategy is **SINGLE SESSION**, execute the work directly in this conversation. No orchestration tools needed.

1. Read the relevant files that need to be modified
2. Plan the changes (if Risk >= 4, present the plan and wait for approval before modifying files)
3. Make the changes using Read, Edit, Write, and Bash tools
4. Verify the changes work (run type checks, tests, or basic validation as appropriate)
5. Report completion

Output format:

```
## Build Complete — Single Session

**Files modified:**
- [file path]: [what changed]
- [file path]: [what changed]

**What was done:**
[2-3 sentence summary]

**Verification:**
[What was checked — e.g., "TypeScript compilation passes", "Route returns expected response"]
```

---

## Step 8: Execute — Hybrid Path

If the approved strategy is **HYBRID**, execute in two distinct phases.

### Phase 1: Research (Sub-Agents)

Spawn research sub-agents to gather information in parallel. Each investigates a specific question, area of the codebase, or external concern.

Use the **Task** tool with `run_in_background: true` for each research agent. Their prompts should:
- Ask a specific question or investigate a specific area
- Specify what format to return findings in
- Include enough context to work independently

Wait for all research agents to complete. Synthesize their findings into a brief.

### Phase 2: Implementation (Agent Team)

Using the research findings, create an agent team following Step 5 (Agent Team Path). Include the research synthesis in each teammate's prompt so they benefit from Phase 1's findings.

The research brief should be injected into each teammate prompt as:
```
## Research Findings (from Phase 1)
[Synthesized findings relevant to this teammate's work]
```

Then follow steps 5b through 5f as normal.

Output the completion report combining both phases:

```
## Build Complete — Hybrid (Research + Agent Team)

### Phase 1: Research
| Research Agent | Question | Finding |
|---------------|----------|---------|
| [name] | [question] | [key finding] |
| [name] | [question] | [key finding] |

### Phase 2: Implementation
**Team:** [team name]

| Teammate | Type | Tasks Completed | Files Modified |
|----------|------|-----------------|----------------|
| [name] | [type] | [N] | [list key files] |
| [name] | [type] | [N] | [list key files] |

**Total files modified:** [count]

### What was built
[2-4 bullet summary]

### Verification
Run /verify [phase-folder] to check against SPEC.md acceptance criteria.
```

---

## Step 9: GSD State Sync (Phase-Related Builds Only)

After ANY execution path completes for a **phase-related build** (input referenced a phase folder or phase number), sync the results back to GSD state. Skip this step for ad-hoc builds with no phase association.

### When to Skip

- Build was NOT phase-related (ad-hoc feature, bug fix, etc.)
- `.planning/` directory doesn't exist
- GSD is not initialized (no `.planning/config.json`)

### 9a: Write SUMMARY.md

Create `{N}-SUMMARY.md` (or `{N}-01-SUMMARY.md` for wave-based plans) in the phase folder:

```yaml
---
phase: {phase-folder-name}
plan: 01
subsystem: {ui|api|data|infra}
tags: [{relevant-tags}]
key-files:
  created: [{list}]
  modified: [{list}]
  deleted: [{list}]
key-decisions:
  - "{decision 1}"
duration: ~{N}min
completed: {YYYY-MM-DD}
---
```

Followed by:
- 1-sentence summary
- Accomplishments list
- Files created/modified
- Deviations from plan (if any)
- Issues encountered (if any)

### 9b: Write VERIFICATION.md

Create `{N}-VERIFICATION.md` in the phase folder with:

```yaml
---
phase: {phase-folder-name}
verified: {YYYY-MM-DD}
status: {verified|partial|failed}
score: {X}/{Y} checks passed
gaps: [{list of unmet criteria, or empty}]
---
```

Followed by:
- Observable truths table (from the plan's verification section or SPEC.md acceptance criteria)
- Status: verified/partial/failed per check
- Required artifacts table
- Human verification test scripts (if applicable)

### 9c: Move Phase Folder

If all acceptance criteria are met:

```bash
mv .planning/phases/backlog/{phase-folder} .planning/phases/completed/{phase-folder}
```

If partial (some criteria unmet), leave in backlog and note gaps in VERIFICATION.md.

### 9d: Update STATE.md

Prepend a completion entry to `.planning/STATE.md` under "Recent Completions":

```
✅ **Phase {N}: {Title}** - VERIFIED COMPLETE ({date})
- {bullet 1: what was built}
- {bullet 2: key deliverables}
- {N} files modified: {list}
```

---

## Step 10: Auto-Chain

After ANY execution path completes (Steps 4-9), offer the next action:

```
### Next Steps

1. **State synced:** Phase artifacts written, folder moved to completed/
2. **Verify:** Run /verify [phase-folder] for deep acceptance check
3. **Retro:** Run /retro to capture lessons learned
4. **Continue:** If more work remains, run /build with the next task
```

If the build was for a specific phase and the SPEC.md has unchecked acceptance criteria remaining, mention:
```
Note: [N] acceptance criteria in SPEC.md still unchecked. Run /build with the remaining items to continue.
```

---

## Fallback: Static Prompt Output

If execution cannot proceed — for example, if tool permissions are denied, agent tools (Task, TeamCreate, SendMessage) are unavailable, or an unexpected error prevents orchestration — fall back to generating a detailed static prompt the user can act on manually.

In this case, output:

```
## Execution Blocked

Could not execute directly. Reason: [what went wrong]

Falling back to static execution prompt. Copy and use this to proceed manually:

---

[Generate a complete execution prompt following the build command template format:
- For SINGLE SESSION: Clear actionable instructions with file paths and acceptance criteria
- For SUB-AGENTS: Full sub-agent specifications with prompts, types, and synthesis instructions
- For AGENT TEAM: Full team structure, teammate prompts, task breakdown, coordination rules, and done criteria
- For HYBRID: Both research phase and implementation phase specifications
- For GSD: The specific GSD commands to run]

---

This is a fallback. Re-run /build after resolving the issue above for direct execution.
```

When generating fallback prompts, apply the same quality standards:
- Every agent prompt includes full context (file paths, architecture, constraints)
- No two agents edit the same file
- Task dependencies are explicit with no circular dependencies
- Sub-agent prompts specify return format
- Team prompts explain WHY coordination is needed
- Risk >= 4 includes plan approval requirement
- Prompts reference specific files and paths, not generic placeholders
- Done criteria are measurable

---

## Project Context Injection

When generating prompts for agents or teammates (in any execution path), inject relevant context from your project's planning docs:

- **CLAUDE.md** — Project instructions, constraints, pitfalls, tech stack (always include relevant sections)
- **Planning docs** — Architecture, requirements, frontend specs (if they exist in `.planning/`)
- **Package files** — `package.json`, `pyproject.toml`, etc. for dependency versions

Include specific constraint references, known pitfalls, and file paths in every agent prompt so they don't waste time discovering context. Agents work best with all necessary context upfront.

---

## Quality Checklist

Before executing any strategy, verify:

- [ ] Every agent/teammate prompt includes enough context to work independently (file paths, architecture decisions, constraints)
- [ ] No two teammates will edit the same file (prevents write conflicts)
- [ ] Task dependencies are explicit (no circular dependencies)
- [ ] Sub-agent prompts specify what format to return results in
- [ ] Team prompts explain WHY teammates need to coordinate (not just WHAT to do)
- [ ] If Risk >= 4, plan approval is required before implementation begins
- [ ] subagent_type matches the agent's actual work
- [ ] Prompts reference specific files and paths from the project, not generic placeholders
- [ ] Done criteria are measurable, not vague
- [ ] Relevant warnings about known issues are included in each prompt
- [ ] Tech stack constraints (especially what NOT to use) are included in each prompt
- [ ] File ownership boundaries are explicit — every agent knows which files they own and which files belong to others
