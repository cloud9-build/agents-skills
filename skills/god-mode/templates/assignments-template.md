# Plan Assignments
**Updated:** [TIMESTAMP]

## Current Phase: [PHASE_NUMBER] - [PHASE_NAME]

| Plan | Wave | Assigned To | Status | Updated |
|------|------|-------------|--------|---------|

## Plan Statuses
- `available` — Ready to claim
- `assigned` — Claimed but not started
- `in_progress` — Being worked on
- `partial` — Partially complete, released
- `complete` — Finished
- `verified` — Complete and verified by guard
- `waiting` — Blocked by wave dependency

## Assignment Rules
- Wave 1 plans can start immediately
- Wave N+1 plans wait for Wave N completion
- One plan per session at a time
- Use `/gm-claim` to self-assign
- Use `/gm-assign` for coordinator assignment

## Wave Summary

| Wave | Total Plans | Complete | In Progress | Available | Waiting |
|------|-------------|----------|-------------|-----------|---------|

## Assignment History

| Time | Plan | From | To | Reason |
|------|------|------|-----|--------|
