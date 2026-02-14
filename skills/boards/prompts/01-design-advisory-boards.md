# Prompt 1: Design Advisory Boards from PRD

## Purpose

This prompt reads a Product Requirements Document and designs two advisory boards — a Planning board (business-heavy) and an Execution board (technical-heavy) — with justified seat selection based on the specific product being built.

## When to Use

Use this prompt at the start of any new product initiative, before any planning or development begins. It produces the organizational structure that will govern the project through planning and execution.

---

## The Prompt

```
Read the PRD at docs/prdv1.md thoroughly. Based on the product described, design two advisory boards.

**Board 1: Strategic Planning & Business Advisory Board**
- Purpose: Evaluates the WHAT and WHY before any code is written. Validates market fit, business viability, compliance risk, resource allocation, and technical feasibility.
- Composition: Business-heavy. Must include the CTO (as technical feasibility gate-keeper) and a Product Manager (as roadmap owner). The remaining seats should be filled with business-oriented roles that are specifically relevant to THIS product's domain, market, regulatory environment, cost structure, and go-to-market challenges.
- The CTO and Product Manager must bridge to Board 2 (they carry over).

**Board 2: Technical Execution & Delivery Board**
- Purpose: Validates the HOW and builds it. Takes the approved plan and turns it into architecture, sprints, and shipped code.
- Composition: Technical-heavy. Must include the CTO (now shifted to architecture oversight) and the Product Owner (the PM shifted to sprint-level execution). The remaining seats should be filled with every technical specialist role needed to actually build THIS specific product based on its tech stack, architecture, integrations, and non-functional requirements.

**For each board:**
1. List every seat with the role title
2. Explain WHY that specific role is critical for THIS product (not generic reasons — tie it directly to the PRD's architecture, tech stack, compliance needs, integrations, cost drivers, or user experience challenges)
3. Define what each person is responsible for on their board
4. Show how the two boards hand off to each other (the CTO and PM/PO bridge)

**Selection criteria:**
- Every seat must be justified by something specific in the PRD — a technology choice, an integration, a compliance requirement, a cost driver, a UX challenge, or a market positioning need
- Do not add generic roles. Every person must earn their seat based on this product's unique characteristics
- Consider: What could go wrong if this role were missing from the board? If the answer is "not much," the role doesn't belong

**Output format:**
- Structured table for each board with Role, Responsibility, and Justification columns
- A visual handoff diagram showing how Board 1 flows into Board 2
- Clear indication of which roles bridge both boards and how their focus shifts
```

---

## Expected Output

- Two fully designed advisory boards with 5-8 members each
- Product-specific justification for every seat
- Clear handoff model between planning and execution
- Visual diagram of the board structure and bridge roles

## Key Behaviors This Prompt Triggers

1. **Forces PRD analysis first** — the AI must deeply read the PRD before designing boards
2. **Prevents generic answers** — "tie it directly to the PRD" eliminates boilerplate roles
3. **Demands justification** — "What could go wrong if missing?" forces real evaluation
4. **Establishes the bridge** — CTO and PM/PO carrying over ensures continuity
5. **Separates concerns** — business vs. technical boards with clear handoff
