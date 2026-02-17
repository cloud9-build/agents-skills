---
name: sync-master
description: Sync masterCLAUDE.md between current project and agents-skills canonical repo
argument-hint: "[to-canonical|from-canonical|auto]"
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
---

# /sync-master: Cross-Project Knowledge Sync

## Trigger
User runs `/sync-master [direction]` in a Claude Code terminal.

## Purpose

Synchronizes `masterCLAUDE.md` between the current project and the canonical version in the agents-skills repo. This ensures all team members and new projects benefit from lessons learned via `/retro`.

## Workflow Pattern

```
Project masterCLAUDE.md  ←→  agents-skills/masterCLAUDE.md
   (working copy)              (canonical/shared)
        ↓                              ↓
  Updates via /retro            Team pulls from Git
```

## Input

The user has provided this argument: `$ARGUMENTS`

**Valid arguments:**
- `to-canonical` - Sync FROM current project TO agents-skills (after adding lessons via /retro)
- `from-canonical` - Sync FROM agents-skills TO current project (when starting work or updating)
- `auto` or empty - Detect which file is newer and suggest sync direction

## Step 1: Locate Files

Find both masterCLAUDE.md files:

1. **Project file:** Look for `masterCLAUDE.md` in current working directory
2. **Canonical file:** Search for agents-skills repo and locate `masterCLAUDE.md`

```bash
# Find agents-skills repo
find ~/Documents/GitHub -maxdepth 1 -type d -name "agents-skills" 2>/dev/null
```

If either file is missing, report the issue and stop.

## Step 2: Compare Files

Check if files are identical:

```bash
# Compare checksums
md5 path/to/project/masterCLAUDE.md path/to/agents-skills/masterCLAUDE.md
```

**If identical:**
- Report "✅ Files already in sync - no action needed"
- Show last update date from both files
- Stop

**If different:**
- Proceed to Step 3

## Step 3: Show Diff and Determine Direction

Display the differences:

```bash
# Show unified diff
diff -u path/to/canonical/masterCLAUDE.md path/to/project/masterCLAUDE.md
```

**Analyze the diff to determine:**
1. Which file has more content (line count)
2. Which file has more recent update log entries (check ## Update Log section)
3. Whether project has NEW lessons not in canonical

**Based on $ARGUMENTS:**

### `to-canonical` (Explicit sync to agents-skills)
- Show diff highlighting new lessons being added to canonical
- Confirm: "This will update agents-skills/masterCLAUDE.md with your project's lessons. Continue?"
- If yes → Copy project → canonical → Proceed to git operations

### `from-canonical` (Explicit sync from agents-skills)
- Show diff highlighting lessons from canonical
- Confirm: "This will update your project's masterCLAUDE.md with canonical lessons. Continue?"
- If yes → Copy canonical → project → Done (no git operations)

### `auto` or empty (Auto-detect)
Analyze the Update Log section to recommend direction:

```bash
# Extract last update date from each file
grep -A 1 "## Update Log" file | tail -1
```

**Recommendation logic:**
- If project has newer date in Update Log → Recommend `to-canonical`
- If canonical has newer date → Recommend `from-canonical`
- If dates are equal but line counts differ → Ask user which direction
- Show both options with clear explanations

## Step 4: Perform Sync

After user confirms direction:

1. **Backup the target file** (safety first):
   ```bash
   cp target/masterCLAUDE.md target/masterCLAUDE.backup.md
   ```

2. **Copy the file:**
   ```bash
   cp source/masterCLAUDE.md target/masterCLAUDE.md
   ```

3. **Verify copy succeeded:**
   ```bash
   md5 source/masterCLAUDE.md target/masterCLAUDE.md
   ```

4. **Report success:**
   ```markdown
   ✅ Sync completed
   📄 Source: [source-path]
   📄 Target: [target-path]
   🔒 Backup: [backup-path]
   ✅ Checksums match
   ```

5. **Proceed to Step 5 if target was canonical**

## Step 5: Git Operations (If syncing to canonical)

**Only if target was agents-skills/masterCLAUDE.md:**

Check git status:
```bash
cd path/to/agents-skills
git status --porcelain masterCLAUDE.md
```

**If masterCLAUDE.md shows as modified:**

Extract new lesson summary from Update Log:
```bash
# Get the most recent update entry
grep -A 1 "^- \*\*$(date +%Y-%m-%d)" path/to/agents-skills/masterCLAUDE.md | tail -1
```

Offer to commit and push:
```markdown
## Ready to Share with Team

The canonical masterCLAUDE.md has been updated with new lessons.

**New lessons added:**
[Show recent Update Log entry]

**Would you like to:**
1. ✅ **Commit and push now** (recommended - share with team immediately)
2. 📋 **Just commit locally** (push later manually)
3. ⏸️ **Skip git operations** (you'll commit manually)

**Commit message:**
"sync: Add lessons from [current-project-dir-name]"
```

**If user chooses option 1 (commit + push):**
```bash
cd path/to/agents-skills
git add masterCLAUDE.md
git commit -m "sync: Add lessons from [project-name]"
git push origin main
```

**If user chooses option 2 (commit only):**
```bash
cd path/to/agents-skills
git add masterCLAUDE.md
git commit -m "sync: Add lessons from [project-name]"
```

Report the commit hash and status.

## Step 6: Summary Report

Display final status:

```markdown
## ✅ Sync Complete

**Direction:** [project-name] → agents-skills (canonical updated)
**Files synced:** ✅ Checksums match (MD5: [hash])
**Backup created:** [backup-path]
**Git status:**
  - Committed: [commit-hash]
  - Pushed: [yes/no]

### Next Steps

📝 Continue adding lessons to your project via `/retro`
🔄 Run `/sync-master to-canonical` after accumulating new insights
📥 Run `/sync-master from-canonical` when starting new sessions to get latest team lessons

### Team Sharing

**Canonical location:** `~/Documents/GitHub/agents-skills/masterCLAUDE.md`

**Team members pull latest:**
```bash
cd ~/Documents/GitHub/agents-skills
git pull
```

**Starting new projects:**
```bash
cp ~/Documents/GitHub/agents-skills/masterCLAUDE.md ./masterCLAUDE.md
```
```

## Error Handling

### agents-skills repo not found
1. Search common locations: `~/Documents/GitHub`, `~/projects`, `~/code`, `~/dev`
2. If not found, ask user for repo location
3. Offer to clone from `https://github.com/cloud9-build/agents-skills.git`:
   ```bash
   cd ~/Documents/GitHub
   git clone https://github.com/cloud9-build/agents-skills.git
   ```

### Git operations fail
- Show specific error message
- Suggest manual resolution steps
- Confirm file was still copied successfully (sync happened, just git failed)

### Files can't be compared
- Check file permissions: `ls -la [file]`
- Check if locked by iCloud: `lsattr [file]` (if available)
- Report specific error and suggest manual sync

### Backup already exists
- Timestamp backups: `masterCLAUDE.backup.[timestamp].md`
- Keep last 3 backups, delete older ones

## Implementation Notes

- **Always creates backup** before overwriting (can be restored if needed)
- **Preserves file permissions** and attributes during copy
- **Idempotent** - safe to run multiple times (will detect "already synced")
- **Project-agnostic** - works in any project with masterCLAUDE.md
- **Respects user confirmation** before any destructive operations
- **Git-aware** - checks for uncommitted changes before operations

## Example Usage

**After adding lessons via /retro:**
```
/sync-master to-canonical
```

**When starting a work session:**
```
/sync-master from-canonical
```

**Auto-detect and recommend:**
```
/sync-master
```
or
```
/sync-master auto
```
