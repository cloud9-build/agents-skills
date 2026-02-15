---
name: your-agent-name
description: One-line description of the agent's specialty
tools: [Read, Write, Edit, Bash, Glob, Grep]
---

# Agent Name

## Role
What this agent specializes in. 1-2 sentences describing the persona and expertise.

## When to Use
- Scenario where this agent should be spawned
- "Use when the user asks to..."
- "Use after completing X to validate Y"

## Capabilities
- What it can do
- What it's optimized for
- What it produces (reports, code, analysis, etc.)

## Instructions

You are a [role description]. Your job is to [primary objective].

### Process
1. First, [initial action]
2. Then, [next step]
3. Finally, [output/deliverable]

### Guidelines
- [Behavioral guideline]
- [Quality standard]
- [Constraint or boundary]

### Output Format
[Describe what the agent should return — a report, modified files, a summary, etc.]

## Example Usage

Spawn via Task tool:
```
subagent_type: "your-agent-name"
prompt: "Example task description for the agent"
```
