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

| Skill | Description |
|-------|-------------|
| **God Mode** | Structured parallel execution with plan tracking, context preservation, and quality gates |

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

## Project Structure

```
skills/
├── gm/                 # /gm - Initialize God Mode
│   └── SKILL.md
├── gm-parallel/        # /gm-parallel - Show parallelizable work
│   └── SKILL.md
├── gm-claim/           # /gm-claim - Claim a plan
│   └── SKILL.md
├── gm-status/          # /gm-status - Show session status
│   └── SKILL.md
├── gm-sync/            # /gm-sync - Synchronize sessions
│   └── SKILL.md
├── gm-guard/           # /gm-guard - Verify completion
│   └── SKILL.md
├── gm-restore/         # /gm-restore - Restore context
│   └── SKILL.md
├── gm-release/         # /gm-release - Release a plan
│   └── SKILL.md
├── gm-assign/          # /gm-assign - Assign plan to session
│   └── SKILL.md
├── gm-phase/           # /gm-phase - Execute a phase
│   └── SKILL.md
├── gm-plan/            # /gm-plan - Deprecated (use GSD)
│   └── SKILL.md
└── god-mode/           # Main documentation
    ├── SKILL.md
    ├── README.md
    └── templates/
```

**Important:** Each skill command needs its own directory with a `SKILL.md` file. This is how Claude Code discovers and loads skills.

---

## Verification

After installation, verify skills are loaded by starting a new Claude Code session. You should see the skills in the available commands list.

To test:
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
