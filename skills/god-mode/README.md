# God Mode

Structured parallel execution framework for complex AI-assisted projects.

## Overview

God Mode transforms how you work on complex projects with AI coding assistants. Instead of ad-hoc prompts, it provides:

- **Phased Planning** - Break work into phases with dependencies
- **Quality Gates** - Verify completion before moving forward
- **Parallel Execution** - Safely run multiple sessions simultaneously
- **Context Preservation** - Never lose progress between sessions
- **Decision Tracking** - Log all architecture choices

## Commands

| Command | Description |
|---------|-------------|
| `/gm` | Initialize god-mode for a project |
| `/gm-plan` | Create structured execution plan |
| `/gm-parallel` | Identify parallel work opportunities |
| `/gm-phase [N]` | Execute phase N |
| `/gm-guard [N]` | Verify phase N completion |
| `/gm-restore` | Restore context for new session |

## Quick Start

1. Start a new project or navigate to existing one
2. Run `/gm` to initialize
3. Run `/gm-plan` to create your execution plan
4. Run `/gm-phase 1` to start Phase 1
5. Continue through phases

## Generated Files

God Mode creates a `.gm/` directory with:

```
.gm/
├── plan.md           # Phased task breakdown
├── context.md        # Current state for session restoration
├── decisions.md      # Architecture decision log
├── issues.md         # Blockers and deferred work
└── progress.md       # Progress tracking
```

## Parallel Work

For tasks that can run simultaneously:

1. Run `/gm-parallel` to identify opportunities
2. Open multiple terminals
3. Paste the generated prompts
4. Each terminal works on its assigned task
5. Run `/gm-guard` when all complete

## Session Restoration

When starting a new session:

1. Run `/gm-restore`
2. Review the state summary
3. Continue where you left off

## Best Practices

- Keep prompts focused (one task per terminal)
- Update tracking files immediately after each task
- Run `/gm-guard` before moving between phases
- Log all architecture decisions
- Don't skip quality gates
