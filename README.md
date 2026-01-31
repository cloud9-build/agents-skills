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

## Available Skills

| Skill | Description |
|-------|-------------|
| **God Mode** | Structured parallel execution with plan tracking, context preservation, and quality gates |

---

## God Mode Commands

| Command | Purpose |
|---------|---------|
| `/gm` | Initialize god-mode for a project |
| `/gm-plan` | Create structured execution plan |
| `/gm-parallel` | Identify parallel work opportunities |
| `/gm-phase [N]` | Execute phase N |
| `/gm-guard [N]` | Verify phase N completion |
| `/gm-restore` | Restore context for new session |

### What God Mode Does

God Mode transforms how you work on complex projects:

- **Structured Planning** - Break work into phases with dependencies and quality gates
- **Parallel Execution** - Run multiple Claude sessions safely with conflict detection
- **Context Preservation** - Never lose progress when starting a new session
- **Quality Gates** - Automatic verification before moving between phases
- **Decision Logging** - Track all architecture choices for future reference

---

## Manual Installation

If you prefer not to run the curl command:

### For Claude Code (Global)

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

## Project Structure

```
agents-skills/
├── skills/           # Skill definitions
│   └── god-mode/     # Structured parallel execution
├── agents/           # Agent definitions (coming soon)
└── runtimes/         # Runtime-specific installers
    ├── claude-code/
    ├── opencode/
    └── gemini/
```

---

## Contributing

We welcome contributions. See [skills/README.md](skills/README.md) for how to create new skills.

---

## License

MIT
