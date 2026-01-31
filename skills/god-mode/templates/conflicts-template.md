# Conflict Detection Log
**Updated:** [TIMESTAMP]

## File Locks

Active locks prevent multiple sessions from modifying the same files.

| File | Locked By | Since | Plan |
|------|-----------|-------|------|

## Pending Notifications

Messages for sessions to see on next command.

| Session | Message | Time |
|---------|---------|------|

## Detected Conflicts

Overlapping modifications that need resolution.

| File | Sessions | Lines | Status | Detected |
|------|----------|-------|--------|----------|

## Conflict Statuses
- `detected` — Overlap found, needs resolution
- `resolving` — Being worked on
- `resolved` — Fixed and committed

## Resolution Log

| File | Sessions | Resolution | Resolved By | Time |
|------|----------|------------|-------------|------|

## Released Locks

| File | Session | Released | Duration |
|------|---------|----------|----------|
