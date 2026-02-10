# Skills

Skills are specialized prompts that extend your AI coding assistant with new capabilities.

## Available Skills

| Skill | Commands | Description |
|-------|----------|-------------|
| [god-mode](./god-mode/) | `/gm`, `/gm-plan`, `/gm-parallel`, `/gm-phase`, `/gm-guard`, `/gm-restore` | Structured parallel execution with plan tracking and quality gates |
| [route](./route/) | `/route` | Analyze any task and output the optimal execution prompt using sub-agents, agent teams, or both |

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

1. Create a directory under `skills/`
2. Add `SKILL.md` with frontmatter and instructions
3. Add `README.md` documenting usage
4. Add sub-command files for additional commands
5. Add templates if needed
6. Submit a pull request

## Best Practices

- Keep instructions clear and specific
- Define explicit file formats for any generated content
- Include error handling instructions
- Specify what tools/commands the AI should use
- Add quality gates for multi-step processes
