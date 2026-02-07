# Agents

Agents are specialized AI configurations optimized for specific tasks. Unlike skills (which are user-invoked commands), agents are spawned programmatically as subagents to handle focused work.

## Available Agents

| Agent | Description |
|-------|-------------|
| *None yet* | See [TEMPLATE.md](./TEMPLATE.md) to create the first one |

## Agent vs Skill

| | **Skill** | **Agent** |
|---|---|---|
| **Triggered by** | User typing `/skill-name` | Spawned by Task tool with `subagent_type` |
| **Lives in** | `skills/<name>/SKILL.md` | `agents/<name>.md` |
| **Good for** | Workflows, commands, multi-step processes | Specialized roles (reviewer, writer, tester) |

**Quick rule:** If the user invokes it directly, it's a skill. If it runs in the background as a specialist, it's an agent.

## Agent File Format

Each agent is a single `.md` file in this directory with YAML frontmatter:

```markdown
---
name: agent-name
description: One-line description
tools: [Read, Write, Edit, Bash, Glob, Grep]
---

# Agent Name

## Role
## When to Use
## Capabilities
## Instructions
## Example Usage
```

See [TEMPLATE.md](./TEMPLATE.md) for a complete copy-paste starter.

### Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Agent identifier (lowercase, hyphenated) |
| `description` | Yes | One-line description |
| `tools` | Yes | List of tools the agent needs access to |

## Creating a New Agent

1. Copy `TEMPLATE.md` to `your-agent-name.md`
2. Fill in the frontmatter and all sections
3. Make it **project-agnostic** (no hardcoded paths or project names)
4. Test locally: `cp agents/your-agent-name.md ~/.claude/agents/`
5. Submit a pull request

## Best Practices

- Keep the Role section to 1-2 sentences
- List concrete scenarios in When to Use (not vague descriptions)
- Write Instructions as if you're briefing a new team member
- Include the exact output format the agent should produce
- Only request tools the agent actually needs
