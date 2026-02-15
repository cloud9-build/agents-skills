# TEAM-MANIFEST.md Template

**Purpose:** Coordinate agent teams working on Mode C (Heavy) tasks. Tracks which agents are working on what, their status, and coordination notes.

---

## When to Use

- **Mode C (Heavy) tasks only** — 15+ files, 3+ systems, agent team required
- **Not needed for Mode A/B** — Single session or sub-agents don't need coordination tracking

---

## Template

Copy this template to `.planning/workflow-state/TEAM-MANIFEST.md` when spawning an agent team:

```markdown
# Agent Team Manifest: [Task Name]

**Task ID:** [e.g., Phase 53, Feature X]
**Coordination Mode:** [Parallel / Sequential / Hybrid]
**Started:** [YYYY-MM-DD]
**Status:** [Active / Paused / Complete]

---

## Team Members

### 1. [Agent Name] ([Role/Type])
- **Agent ID:** [auto-generated ID from TeamCreate]
- **Assigned files:** `path/to/file1.ts`, `path/to/file2.ts`
- **Responsibilities:** [What this agent is building/fixing]
- **Status:** [Not Started / In Progress / Blocked / Complete]
- **Last update:** [YYYY-MM-DD HH:MM]
- **Blockers:** [Dependencies on other agents, if any]

### 2. [Agent Name] ([Role/Type])
- **Agent ID:** [auto-generated ID]
- **Assigned files:** `path/to/file3.tsx`, `path/to/file4.tsx`
- **Responsibilities:** [What this agent is building/fixing]
- **Status:** [Not Started / In Progress / Blocked / Complete]
- **Last update:** [YYYY-MM-DD HH:MM]
- **Blockers:** [Dependencies on other agents, if any]

### 3. [Agent Name] ([Role/Type])
- **Agent ID:** [auto-generated ID]
- **Assigned files:** `supabase/migrations/*.sql`
- **Responsibilities:** [What this agent is building/fixing]
- **Status:** [Not Started / In Progress / Blocked / Complete]
- **Last update:** [YYYY-MM-DD HH:MM]
- **Blockers:** [Dependencies on other agents, if any]

---

## Coordination Notes

### Integration Points
- [Agent A] outputs → [Agent B] inputs: [describe handoff]
- [Agent B] outputs → [Agent C] inputs: [describe handoff]

### Shared Dependencies
- [File/module that multiple agents touch]: [How conflicts are resolved]

### Communication Protocol
- [How agents sync: file comments, shared docs, main session orchestration]

---

## Progress Tracker

| Agent | Files | Status | % Complete | Blockers |
|-------|-------|--------|------------|----------|
| Agent A | 5 | In Progress | 60% | Waiting on API spec from Agent B |
| Agent B | 3 | Complete | 100% | None |
| Agent C | 8 | Not Started | 0% | Blocked by Agent A completion |

---

## Completion Criteria

**Team task is complete when:**
- [ ] All agents report status = Complete
- [ ] Integration tests pass across all work streams
- [ ] Main session has merged all agent outputs
- [ ] No outstanding blockers

---

## Handoff to Main Session

When all agents complete:
1. Main session reviews all agent outputs
2. Resolves any integration conflicts
3. Runs full test suite
4. Updates HANDOFF.md with final state
5. Archives TEAM-MANIFEST.md (append `-COMPLETE` to filename)

---

**Last updated:** [YYYY-MM-DD HH:MM]
```

---

## Real Example

```markdown
# Agent Team Manifest: Phase 53 Group Revenue Splitting

**Task ID:** Phase 53
**Coordination Mode:** Sequential (DB → Backend → Frontend)
**Started:** 2026-02-14
**Status:** Active

---

## Team Members

### 1. DB-Agent (data-engineer)
- **Agent ID:** agent-abc123
- **Assigned files:** `supabase/migrations/023_*.sql`, `lib/types/group-mappings.ts`
- **Responsibilities:** Create dim_group_mappings table, migration script, Zod schemas
- **Status:** Complete
- **Last update:** 2026-02-14 10:30
- **Blockers:** None

### 2. Backend-Agent (backend-developer)
- **Agent ID:** agent-def456
- **Assigned files:** `lib/api/channel-mix-data.ts`, `app/api/channel-mix/route.ts`
- **Responsibilities:** Update aggregate_channel_mix RPC, ingestion pipeline Stage 4.5
- **Status:** In Progress
- **Last update:** 2026-02-14 11:45
- **Blockers:** Waiting on DB migration to be applied in Supabase dashboard

### 3. Frontend-Agent (frontend-developer)
- **Agent ID:** agent-ghi789
- **Assigned files:** `components/AuditReservationCard.tsx`, `components/TacticalGrid.tsx`
- **Responsibilities:** Add visual indicators for group revenue, amber badge styling
- **Status:** Not Started
- **Last update:** 2026-02-14 09:00
- **Blockers:** Blocked by Backend-Agent (needs API contract)

---

## Coordination Notes

### Integration Points
- DB-Agent outputs (schema + types) → Backend-Agent inputs (API implementation)
- Backend-Agent outputs (API contract) → Frontend-Agent inputs (component rendering)

### Shared Dependencies
- `lib/types/group-mappings.ts`: DB-Agent creates, Backend-Agent consumes, Frontend-Agent imports

### Communication Protocol
- Sequential handoff via HANDOFF.md updates
- Main session orchestrates, checks each agent's completion before spawning next

---

## Progress Tracker

| Agent | Files | Status | % Complete | Blockers |
|-------|-------|--------|------------|----------|
| DB-Agent | 3 | Complete | 100% | None |
| Backend-Agent | 5 | In Progress | 40% | Migration not applied yet |
| Frontend-Agent | 4 | Not Started | 0% | Waiting on API contract |

---

## Completion Criteria

**Team task is complete when:**
- [x] DB-Agent: Migration + types created
- [ ] Backend-Agent: Ingestion pipeline updated
- [ ] Frontend-Agent: Visual indicators implemented
- [ ] Integration test: Full flow from ingestion → API → UI passes
- [ ] Main session: Code review, commit, push

---

**Last updated:** 2026-02-14 11:45
```

---

## Best Practices

1. **Update frequently** — Each agent should update their status after major milestones
2. **Be specific about blockers** — "Waiting on Agent B" is vague; "Waiting on API schema from Agent B's auth.ts" is actionable
3. **Track % complete conservatively** — Better to under-estimate than over-estimate
4. **Archive when done** — Rename to `TEAM-MANIFEST-COMPLETE.md` to preserve history

---

## When NOT to Use

- **Mode A (Trivial) tasks** — Single session, no coordination needed
- **Mode B (Moderate) tasks** — Sub-agents work independently, no team coordination
- **Solo work** — If you're not spawning multiple agents, skip this

---

**See also:**
- [execution-modes.md](./execution-modes.md) — Mode selection guide
- [baseline-metrics.md](./baseline-metrics.md) — Track workflow performance
- `/handoff` skill — Create HANDOFF.md for context clearing
