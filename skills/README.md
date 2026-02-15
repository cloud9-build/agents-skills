# Skills

Skills are specialized prompts that extend your AI coding assistant with new capabilities.

## Available Skills

| Skill | Commands | Description |
|-------|----------|-------------|
| [god-mode](./god-mode/) | `/gm`, `/gm-parallel`, `/gm-phase`, `/gm-guard`, `/gm-restore`, etc. | Structured parallel execution with plan tracking and quality gates |
| [workflow](./workflow/) | `/workflow` | Navigate the 5-stage workflow pipeline (start, status, next) |
| [braindump](./braindump/) | `/braindump` | Full planning pipeline — idea capture, plan/spec creation, board review, and spike identification |
| [spike](./spike/) | `/spike` | Time-boxed risk validation (prototype, benchmark, research) |
| [build](./build/) | `/build` | Analyze work and execute using optimal strategy (replaces /route) |
| [verify](./verify/) | `/verify` | Universal verification against acceptance criteria |
| [retro](./retro/) | `/retro` | Session retrospective — extract and apply lessons learned |
| [board-review](./board-review/) | `/board-review` | Convene expert review panel to score and critique documents |
| [handoff](./handoff/) | `/handoff` | Capture current state before clearing context |
| [blueprint](./blueprint/) | `/blueprint` | Generate visual blueprints (wireframe, architecture, flowchart) |
| [boards](./boards/) | *(resource)* | Board member profiles, creation prompts, and templates |
| ~~[route](./route/)~~ | ~~/route~~ | **Deprecated** — use `/build` instead |

## Skill Structure

Each skill follows this structure:

```
skill-name/
├── SKILL.md           # Main skill definition (required)
├── README.md          # Documentation
├── sub-command.md     # Additional commands
└── templates/         # Template files (optional)
```

### SKILL.md Format

```markdown
---
name: skill-name
description: Brief description shown in help
---

# Skill Title

[Full instructions for the AI]
```

The frontmatter defines:
- `name`: Skill identifier used in commands
- `description`: Shown when user asks for help

## Creating a New Skill

1. Copy `_TEMPLATE/SKILL.md` to `your-skill-name/SKILL.md`
2. Fill in the frontmatter (`name`, `description`) and all sections
3. Make it **project-agnostic** (no hardcoded paths or project names)
4. Add `README.md` documenting usage (optional)
5. Add sub-command files for additional commands (optional)
6. Add templates if needed (optional)
7. Test locally: `cp -r skills/your-skill-name ~/.claude/skills/`
8. Submit a pull request

See [_TEMPLATE/SKILL.md](./_TEMPLATE/SKILL.md) for a complete copy-paste starter.

## Best Practices

- Keep instructions clear and specific
- Define explicit file formats for any generated content
- Include error handling instructions
- Specify what tools/commands the AI should use
- Add quality gates for multi-step processes
