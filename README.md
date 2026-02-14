# Cloud9 Agents & Skills

**Anti-Gravity for AI Development**

Supercharge your AI coding assistant with battle-tested skills and agents. One command, instant productivity boost.

---

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/cloud9-build/agents-skills/main/install.sh | bash
```

The installer will guide you through:
1. **Choose Runtime** - Claude Code, OpenCode, Gemini CLI, or all
2. **Choose Location** - Global (all projects) or Local (current project only)

---

## Manual Installation

If you prefer not to run the curl command:

### For Claude Code (Global - Recommended)

```bash
git clone https://github.com/cloud9-build/agents-skills.git /tmp/agents-skills
mkdir -p ~/.claude/skills
cp -r /tmp/agents-skills/skills/* ~/.claude/skills/
rm -rf /tmp/agents-skills
```

### For Claude Code (Local Project)

```bash
git clone https://github.com/cloud9-build/agents-skills.git /tmp/agents-skills
mkdir -p .claude/skills
cp -r /tmp/agents-skills/skills/* .claude/skills/
rm -rf /tmp/agents-skills
```

### For OpenCode (Global)

```bash
git clone https://github.com/cloud9-build/agents-skills.git /tmp/agents-skills
mkdir -p ~/.opencode/skills
cp -r /tmp/agents-skills/skills/* ~/.opencode/skills/
rm -rf /tmp/agents-skills
```

### For Gemini CLI (Global)

```bash
git clone https://github.com/cloud9-build/agents-skills.git /tmp/agents-skills
mkdir -p ~/.gemini/skills
cp -r /tmp/agents-skills/skills/* ~/.gemini/skills/
rm -rf /tmp/agents-skills
```

---

## Available Skills

### 5-Stage Workflow Pipeline

| Stage | Command | Description |
|-------|---------|-------------|
| 1. Plan | `/braindump <idea>` | Interview, write PLAN.md + SPEC.md, auto board review, risk identification |
| 2. Validate | `/spike` | Time-boxed experiments to test risky assumptions (30 min each) |
| 3. Build | `/build <phase>` | Analyze work, pick strategy (single/agents/team/GSD), execute |
| 4. Verify | `/verify <phase>` | Test against SPEC.md acceptance criteria |
| 5. Learn | `/retro` | Extract lessons, update CLAUDE.md + masterCLAUDE.md |

### Supporting Tools

| Command | Description |
|---------|-------------|
| `/workflow` | Navigate the pipeline (start, status, next recommended action) |
| `/board-review <path>` | Convene 3-4 expert reviewers to score and critique any document |
| `/handoff` | Capture current state before clearing context |
| `/blueprint <idea>` | Quick visual exploration (wireframe, architecture, flowchart) |

### Parallel Execution

| Command | Description |
|---------|-------------|
| `/gm` | Initialize God Mode for parallel terminal coordination |
| `/gm-parallel` | Show which plans can run in parallel |
| `/gm-claim [plan]` | Claim a plan for this terminal |
| `/gm-status` | Show all active sessions |
| `/gm-sync` | Check for conflicts and merge work |
| *+ 5 more /gm- commands* | See [God Mode docs](skills/god-mode/README.md) |

---

## God Mode Commands

God Mode coordinates multiple Claude Code terminals working on the same GSD project simultaneously.

| Command | Purpose |
|---------|---------|
| `/gm` | Initialize God Mode for a project |
| `/gm-parallel` | Show which plans can run in parallel |
| `/gm-claim [plan]` | Claim a plan for this terminal |
| `/gm-status` | Show all active sessions |
| `/gm-sync` | Check for conflicts and merge work |
| `/gm-guard` | Verify completion with conflict check |
| `/gm-restore` | Restore context for new session |
| `/gm-release` | Release a claimed plan |
| `/gm-assign` | Assign a plan to another session |
| `/gm-phase [N]` | Execute a phase with coordination |

### What God Mode Does

God Mode transforms how you work on complex projects:

- **Structured Planning** - Break work into phases with dependencies and quality gates
- **Parallel Execution** - Run multiple Claude sessions safely with conflict detection
- **Context Preservation** - Never lose progress when starting a new session
- **Quality Gates** - Automatic verification before moving between phases
- **Wave-Based Work** - Organize plans into waves that can run in parallel

### Prerequisites

God Mode requires a GSD project. Run `/gsd:new-project` first to set up the project structure.

---

## 5-Stage Workflow Pipeline

One command starts the full development cycle. You only stop at 3 gates to make decisions.

```
/braindump <idea>  →  Interview  →  PLAN.md + SPEC.md  →  Board Review  →  GATE 1
    →  /spike (if risks)  →  GATE 2  →  /build  →  GATE 3  →  /verify  →  /retro
```

### How It Works

1. **`/braindump <idea>`** — 5-question interview, auto-generates PLAN.md + SPEC.md, runs board review
2. **`/spike`** — Tests risky assumptions (auto-triggered or standalone). PASS/PIVOT/BLOCK per risk.
3. **`/build <phase>`** — Scores the work on 5 dimensions, picks the best strategy, then executes it
4. **`/verify <phase>`** — Checks built work against SPEC.md criteria (automated + manual)
5. **`/retro`** — Extracts lessons, applies to CLAUDE.md with per-item confirmation

### Board Review System

19 expert reviewers across 3 categories score your plans:
- **5 Workflow Board members** ship with this repo (Operator, Economist, Customer, Architect, Contrarian)
- **Project-specific boards** are generated per-project using included prompts
- Board creation prompts in `skills/boards/prompts/` help you design custom boards from your PRD

### When to Skip Stages

| Situation | What To Do |
|-----------|-----------|
| Major feature with unknowns | Full pipeline: `/braindump <idea>` |
| Bug fix or config change | Skip to `/build <description>` |
| Prototype or throwaway code | Skip verify and retro |

---

## Route (Deprecated)

`/route` has been replaced by `/build`. The `/build` command includes the same 5-dimension analysis plus actual execution. See the [5-Stage Workflow Pipeline](#5-stage-workflow-pipeline) section above.

---

## Project Structure

```
skills/
├── workflow/           # /workflow - Pipeline navigator
│   ├── SKILL.md
│   └── README.md       # Full 5-stage documentation
├── braindump/          # /braindump - Stage 1: Plan
│   └── SKILL.md
├── spike/              # /spike - Stage 2: Validate
│   └── SKILL.md
├── build/              # /build - Stage 3: Build (replaces /route)
│   └── SKILL.md
├── verify/             # /verify - Stage 4: Verify
│   └── SKILL.md
├── retro/              # /retro - Stage 5: Learn
│   └── SKILL.md
├── board-review/       # /board-review - Expert panel review
│   └── SKILL.md
├── handoff/            # /handoff - Context preservation
│   └── SKILL.md
├── blueprint/          # /blueprint - Visual idea planning
│   └── SKILL.md
├── boards/             # Board member profiles (resource)
│   ├── INDEX.md
│   ├── workflow/       # 5 generic reviewers
│   ├── prompts/        # Board creation tools
│   └── templates/      # Example profiles
├── god-mode/           # God Mode hub
│   ├── SKILL.md
│   ├── README.md
│   └── templates/
├── gm*/                # God Mode sub-commands (10 skills)
│   └── SKILL.md
└── route/              # Deprecated → use /build
    └── SKILL.md
```

**Important:** Each skill command needs its own directory with a `SKILL.md` file. This is how Claude Code discovers and loads skills.

---

## Verification

After installation, verify skills are loaded by starting a new Claude Code session. You should see the skills in the available commands list.

To test the workflow:
```
/workflow
```

If you see the pipeline overview, the workflow skills are installed correctly.

To test God Mode:
```
/gm
```

If you see "No GSD project found", the skill is working correctly - it just needs a GSD project first.

---

## Troubleshooting

### Skills not showing up?

1. Make sure each skill has its own directory: `~/.claude/skills/gm/SKILL.md`
2. Restart Claude Code after installing
3. Check the directory structure matches the layout above

### Curl returns 404?

Use the manual installation method with `git clone` instead.

---

## Contributing

We welcome contributions. See [skills/README.md](skills/README.md) for how to create new skills.

---

## License

MIT
