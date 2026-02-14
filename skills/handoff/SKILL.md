---
name: handoff
description: Capture current state before clearing context. Writes HANDOFF.md to the active phase folder.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
---

# Context Handoff

The user is about to clear context. Your job is to capture everything needed to resume work seamlessly in a new session.

## Step 1: Determine the Active Phase

1. Read `.planning/STATE.md` to identify the current phase number and status.
2. Read `.planning/ROADMAP.md` to confirm the phase folder path.
3. The HANDOFF.md should be written to: `.planning/phases/phase-{N}/HANDOFF.md` where `{N}` is the current phase number.
4. If the phase folder doesn't exist, create the file at `.planning/HANDOFF.md` as a fallback.

## Step 2: Gather Context

Review the conversation history and current session to answer these four questions thoroughly:

### 1. Current State
- What phase/feature/task were we working on?
- What has been completed in this session?
- What files were created or modified?
- Are there any uncommitted changes? (Check git status in your memory of the session)

### 2. Next Step
- What is the immediate next action to take?
- What task or subtask is next in sequence?
- Are there any decisions that were made but not yet implemented?

### 3. Context Needed on Resume
- What files should be read first when resuming?
- What architectural decisions or constraints are relevant?
- Any non-obvious context that isn't captured in code or docs?
- Any in-progress debugging, error patterns, or workarounds discovered?

### 4. Warnings
- Any gotchas, edge cases, or traps to watch out for?
- Any dependencies or blockers that may have changed?
- Any technical debt introduced that needs addressing?
- Any commands or actions to avoid?

## Step 3: Write the Handoff

Write the HANDOFF.md file using this format:

```markdown
# Handoff — Phase {N}: {Phase Name}

**Session date:** {today's date}
**Status:** {in-progress | blocked | completing}

## Current State

{Thorough description of where things stand}

### Completed This Session
- {bullet list of what was done}

### Modified Files
- {bullet list of files changed with brief description}

## Next Step

{Clear, specific description of the immediate next action}

## Context for Resume

{What the next session needs to know — files to read, decisions made, non-obvious context}

### Key Files to Read First
1. {file path} — {why}
2. {file path} — {why}

## Warnings

{Gotchas, blockers, things to avoid}
```

## Step 4: Confirm

After writing the file, tell the user:
- Where the HANDOFF.md was saved
- A one-line summary of the next step
- Confirm it's safe to clear context
