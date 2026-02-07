---
name: your-skill-name
description: One-line description shown in help and command lists
---

# /your-skill-name [args]: Human-Readable Title

## Trigger
When user runs `/your-skill-name [arg]`.

## Arguments
- `[required-arg]` — Description of the required argument
- `--optional-flag` — Description of the optional flag

## Purpose
What this skill does and why it's useful. 1-2 sentences max.

## Prerequisites
- What must exist before this runs (files, config, project state, etc.)

## Process

### Step 1: Validate Inputs
1. Check prerequisites exist
2. Parse and validate arguments

If prerequisites missing:
```
Error: [prerequisite] not found.

To fix: [action to take]
```

### Step 2: Core Action
1. What Claude should do first
2. What Claude should do next
3. How to handle the result

### Step 3: Output Results
Present results to the user.

## Output Format

**Success:**
```
[Example of successful output the user will see]
```

**Error:**
```
[Example of error output]

Options:
1. [Recovery action]
2. [Alternative action]
```

## Error Handling
- If [condition] → [action]
- If prerequisite missing → [suggest fix]
- If unexpected state → [fallback behavior]
