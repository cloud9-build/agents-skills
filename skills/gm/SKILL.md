---
name: gm
description: Initialize God Mode parallel session coordination for a GSD project. Creates session tracking files and registers this terminal.
---

# /gm: Initialize God Mode

## Trigger
User runs `/gm` in a Claude Code terminal.

## Purpose
Initialize parallel session coordination for a GSD project. This sets up the infrastructure for multiple Claude terminals to work on the same project simultaneously without conflicts.

## Prerequisites
- A GSD project must exist (`.planning/PROJECT.md`)
- If no GSD project exists, prompt user to run `/gsd:new-project` first

## Process

### Step 1: Verify GSD Project
1. Check for `.planning/PROJECT.md` - if missing:
   ```
   No GSD project found.

   Run /gsd:new-project first to create a project, then use God Mode
   to coordinate parallel terminals.
   ```
2. Read `.planning/STATE.md` to understand current project state

### Step 2: Initialize Parallel Directory
1. Create `.planning/parallel/` directory if it doesn't exist
2. Initialize tracking files:
   - `sessions.md` - Active terminal sessions
   - `assignments.md` - Which session has which plan
   - `conflicts.md` - File conflict detection log

### Step 3: Register This Session
1. Generate a unique session ID (e.g., `gm-001`)
2. Add entry to `sessions.md`:
   ```markdown
   | gm-001 | Terminal 1 | - | idle | [now] | [now] |
   ```

### Step 4: Output Status
```
God Mode initialized for [PROJECT_NAME]
Session ID: gm-001

Current phase: [N] - [Phase Name]
Plans in phase: [X]
Parallelizable (same wave): [Y]

Run /gm-parallel to see which plans can run simultaneously.
Run /gm-claim [plan] to assign work to this terminal.
```

## Session Tracking Format

### sessions.md
```markdown
# Parallel Sessions
**Updated:** [timestamp]

## Active Sessions

| Session ID | Terminal | Plan | Status | Started | Last Ping |
|------------|----------|------|--------|---------|-----------|
| gm-001 | Terminal 1 | 01-01 | in_progress | 2024-01-15 10:00 | 2024-01-15 10:30 |
| gm-002 | Terminal 2 | 01-02 | blocked | 2024-01-15 10:05 | 2024-01-15 10:25 |
```

### assignments.md
```markdown
# Plan Assignments
**Updated:** [timestamp]

## Current Phase: 01 - Foundation

| Plan | Wave | Assigned To | Status |
|------|------|-------------|--------|
| 01-01 | 1 | gm-001 | in_progress |
| 01-02 | 1 | gm-002 | in_progress |
| 01-03 | 2 | - | waiting (wave 1 incomplete) |
```

### conflicts.md
```markdown
# Conflict Detection Log
**Updated:** [timestamp]

## File Locks

| File | Locked By | Since | Plan |
|------|-----------|-------|------|

## Detected Conflicts

None currently.
```

## Available Commands After Initialization

| Command | Purpose |
|---------|---------|
| `/gm-parallel` | Show which plans can run in parallel |
| `/gm-claim [plan]` | Claim a plan for this terminal |
| `/gm-status` | Show all active sessions |
| `/gm-sync` | Check for conflicts and merge work |
| `/gm-guard` | Verify completion with conflict check |
| `/gm-restore` | Restore context for new session |
