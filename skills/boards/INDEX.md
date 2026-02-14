# Board Member Index

> **Purpose**: Manifest for `/board-review` panel selection. Read this file to recommend reviewers.

---

## Workflow Board (`workflow/`)

Project-agnostic board members that apply universal lenses to any plan, regardless of domain.

| ID | Role | File | Domain Tags |
|----|------|------|-------------|
| W-OPS | Operator | `workflow/operator.md` | `execution, staffing, sequencing, scope, shipping, capacity, dependencies, rollback` |
| W-ECON | Economist | `workflow/economist.md` | `roi, unit-economics, cost, opportunity-cost, payback, margin, tco, value-quantification` |
| W-CUST | Customer Advocate | `workflow/customer.md` | `user-value, adoption, demand-signal, jobs-to-be-done, personas, discoverability, time-to-value` |
| W-ARCH | Architect | `workflow/architect.md` | `technical-debt, leverage, simplification, maintenance, reusability, coupling, reversibility` |
| W-CONT | Contrarian | `workflow/contrarian.md` | `assumptions, fragility, scenarios, de-risk, failure-modes, exit-criteria, blind-spots` |

---

## Project-Specific Boards

Project-specific board members live in your project's `docs/board/` directory.
Generate them using the prompts in `prompts/`:

1. Run the "Design Advisory Boards" prompt with your PRD
2. Run the "Create Board Member Profiles" prompt to generate full profiles
3. Add them to your project's `docs/board/INDEX.md`

See `templates/` for example profiles showing the expected depth and structure.

---

## Selection Guidance

### Workflow Board Usage

The Workflow Board provides general-purpose lenses that apply to any project. Use these members to challenge plans from foundational perspectives.

**Best practice**: Include **1-2 workflow members** alongside **2-3 specialized members** (if you have project-specific boards) for balanced reviews.

**Common combinations**:
- **W-OPS + W-ECON** — Scope and cost challenge (good for phase plans, sprint plans)
- **W-CUST + W-CONT** — Demand and assumption challenge (good for new features, MVPs)
- **W-ARCH + [project CTO/architect]** — Technical sustainability and architecture review
- **W-CONT + any specialist** — Always useful to expose blind spots

**When to use each**:
- **W-OPS (Operator)** → Any plan with execution risk (staffing, dependencies, timeline)
- **W-ECON (Economist)** → Any plan with cost or ROI questions
- **W-CUST (Customer)** → Any user-facing feature or product decision
- **W-ARCH (Architect)** → Any technical design or feature that adds complexity
- **W-CONT (Contrarian)** → Any plan with unvalidated assumptions or high uncertainty

---

## By Document Type (Workflow Members)

| Document Type | Recommended Panel |
|---------------|-------------------|
| **PRD / Product Spec** | W-CUST, W-ECON, W-CONT, [project PM if available] |
| **Architecture / Technical Design** | W-ARCH, W-OPS, [project CTO/engineer if available] |
| **Business Case / Pricing** | W-ECON, W-CUST, [project finance if available] |
| **Sprint / Execution Plan** | W-OPS, W-ARCH, [project engineers if available] |
| **Full Project Plan** | W-OPS, W-ECON, W-CONT, [project leads if available] |
| **New Feature (MVP)** | W-CUST, W-ECON, W-CONT |
| **Phase Plan** | W-OPS, W-ARCH, W-ECON |

---

## Selection Rules

1. **Recommend 3-4 members** per review
2. **If project-specific boards exist** (in `docs/board/`): mix specialized + workflow members: 2-3 specialized + 1-2 workflow
3. **If only workflow members available**: select 3-4 workflow members
4. **Match domain tags** from the document content to member tags
5. **Always present recommendations** to the user before proceeding — they may add or remove members

---

## Domain Tag Reference (Workflow Board)

| Domain | Description |
|--------|-------------|
| `execution` | Can-we-ship-this assessments, staffing reality |
| `staffing` | Team capacity, skill gaps, resource allocation |
| `sequencing` | Task ordering, critical path, parallelization |
| `scope` | Feature boundaries, MVP definition |
| `shipping` | Delivery feasibility, rollout planning |
| `capacity` | Team workload, availability, context switching |
| `dependencies` | Task blocking, handoff risk |
| `rollback` | Reversibility, undo plans, failure recovery |
| `roi` | Return on investment analysis |
| `unit-economics` | Revenue per unit, cost per action |
| `cost` | Infrastructure and operational cost projection |
| `opportunity-cost` | Alternative use of resources |
| `payback` | Time to recover investment |
| `margin` | Gross/net margin analysis |
| `tco` | Total cost of ownership (3-year view) |
| `value-quantification` | Metric-based value assessment |
| `user-value` | Does this solve a real user problem? |
| `adoption` | Feature adoption, engagement metrics |
| `demand-signal` | Evidence of user need (tickets, requests, churn) |
| `jobs-to-be-done` | User jobs and outcomes |
| `personas` | User archetypes |
| `discoverability` | How users find features |
| `time-to-value` | Steps/time to first value delivery |
| `technical-debt` | Code maintainability, future cost |
| `leverage` | Reusability, compounding value |
| `simplification` | Complexity reduction, clarity |
| `maintenance` | Ongoing support burden |
| `reusability` | Primitive vs. one-off solutions |
| `coupling` | System integration points, fragility |
| `reversibility` | Ability to undo, rollback cost |
| `assumptions` | Unstated beliefs, hypothesis validation |
| `fragility` | Hidden risks, breaking points |
| `scenarios` | Failure modes, edge cases |
| `de-risk` | Risk mitigation, validation plans |
| `failure-modes` | Ways plans can fail |
| `exit-criteria` | Kill conditions, stop signals |
| `blind-spots` | Unknown unknowns, missing perspectives |
