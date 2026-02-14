# Prompt 2: Create Board Member Profile Documents

## Purpose

This prompt takes the advisory board designs from Prompt 1 and produces exhaustive, production-ready profile documents for every board member — each written by a domain-matched specialist sub-agent running in parallel via agent teams.

## When to Use

After the two advisory boards have been designed and approved. This prompt creates the reference documents that will be loaded as context whenever a board member is invoked during the project lifecycle.

## Prerequisites

- A completed PRD (e.g., `docs/prdv1.md`)
- The two advisory boards designed (output of Prompt 1)
- Agent teams capability available

---

## The Prompt

```
I need you to create detailed profile documents for every member of both advisory boards. These profiles will serve as the definitive reference for invoking each board member as an AI agent at any point during the project.

**Directory structure:**
- Create `docs/board/planning/` for Board 1 members
- Create `docs/board/execution/` for Board 2 members
- One markdown file per board member, named with kebab-case of their role (e.g., `cto.md`, `vp-sales.md`, `ai-rag-engineer.md`)
- Members who bridge both boards (CTO, PM/PO) get separate files in each directory, tailored to that board's context

**Use agent teams to run this in parallel.** For each board member:
1. Spawn a sub-agent whose specialist type matches the board member's domain (e.g., use a `security-engineer` agent to write the Security Engineer profile, a `compliance-auditor` to write the CCO profile, a `product-manager` to write the PM profile, an `ai-engineer` to write the AI/RAG Engineer profile, etc.)
2. Give each agent the full PRD context and their specific board member's role description
3. Run ALL agents in parallel — they are fully independent tasks

**Each profile document MUST include all 13 of these sections with deep, actionable, product-specific detail:**

1. **Role Title & Board Assignment** — Full title, which board(s) they sit on, authority level (veto power, sign-off requirements), reporting line, scope of ownership. Include a table format.

2. **Mission Statement** — Their core purpose on this board in 2-3 sentences. Must reference specific product architecture or challenges, not generic platitudes.

3. **Core Competencies & Expertise** — Detailed breakdown of their skills, knowledge areas, and technical/business domains. Organize into sub-sections. Every competency must map to something specific in the PRD (a technology, an integration, a compliance requirement, a business challenge). No generic skill lists.

4. **Decision Authority** — Three tiers: (a) Decisions they can make unilaterally, (b) Decisions requiring their sign-off, (c) Decisions they escalate. Use tables with concrete examples from the product context.

5. **Key Concerns for [Product Name]** — The specific risks, challenges, and issues they should be evaluating for THIS product. Each concern should be a deep-dive sub-section referencing specific architecture components, APIs, data flows, or business dynamics. This is the most important section — it must be deeply product-specific.

6. **Input Requirements** — What information, artifacts, and data they need to do their job effectively. Table format with: Input, Source, Format, Frequency.

7. **Output Deliverables** — What they produce. Include both the deliverable name and a description of its format, audience, and cadence. Where possible, include templates or examples.

8. **Interaction Model** — How to engage with this board member: when to consult them, what questions to ask, what format they expect, what wastes their time, mandatory review triggers. Include response time expectations.

9. **Red Flags They Watch For** — Specific warning signs this person is trained to spot. Organize by severity (Critical, High, Medium). Each red flag must include a product-specific example.

10. **Success Metrics** — Quantifiable measures of this board member's effectiveness. Split into leading indicators (during the phase) and lagging indicators (after the phase). Include specific targets where possible.

11. **Communication Style & Output Format** — How they communicate: technical depth level, preferred output formats (tables, memos, code, diagrams), terminology conventions, and any product-specific language they use.

12. **Relationship to Other Board Members** — How they interact with each other board member: collaboration points, tension points, override authority, information flow. Include what they provide to and receive from each relationship.

13. **System Prompt Template** — A complete, ready-to-use system prompt that can be copy-pasted to instantiate this board member as an AI agent. Must include: identity/persona, full product context baked in, authority definition, behavioral guidelines (8-12 specific rules), key concerns list, output format requirements, red lines/hard constraints, terminology conventions, and interaction expectations. This prompt should be self-contained — someone using it should not need to read any other document.

**Quality requirements:**
- Every section must reference specific elements from the PRD: table names, field names, API names, architecture patterns, workflow names, technology choices
- No generic filler. If a sentence could apply to any product, rewrite it to be specific to this product
- Include actual code examples, SQL schemas, API patterns, or configuration snippets where relevant (especially for technical Board 2 members)
- Include tables, matrices, and structured formats wherever they improve clarity
- The System Prompt Template (Section 13) should be 500+ words minimum — it must be comprehensive enough to fully instantiate the persona

**Agent team configuration:**
- Create one team for the entire operation
- Spawn all agents simultaneously with `run_in_background: true`
- Match each agent's `subagent_type` to the board member's domain:

  Board 1 (Planning):
  - CTO → `cloud-architect`
  - Product Manager → `product-manager`
  - CCO / Legal → `compliance-auditor` (NOTE: this agent type is read-only — if it cannot write files, use `general-purpose` as a fallback or have the orchestrator write the file from the agent's output)
  - VP Sales → `sales-engineer`
  - VP Finance → `business-analyst`
  - Head of Customer Success → `customer-success-manager`

  Board 2 (Execution):
  - CTO → `cloud-architect`
  - Product Owner → `product-manager`
  - Full-Stack Engineer → `fullstack-developer`
  - Backend Engineer → `backend-developer`
  - AI/RAG Engineer → `ai-engineer`
  - Security Engineer → `security-engineer`
  - Integration Engineer → `api-designer`
  - UX/UI Designer → `ui-designer`

- After all agents complete, verify all files exist with a glob check
- If any file is missing (e.g., read-only agent couldn't write), respawn with a `general-purpose` agent to write it

**Each agent's prompt must include:**
1. The full PRD content (or a comprehensive summary covering all sections)
2. The specific board member's role description and board context
3. The complete 13-section specification above
4. The exact file path to write to
5. An explicit instruction: "Make this EXHAUSTIVE and PRODUCTION-READY. No generic filler."
```

---

## Expected Output

```
docs/board/
├── planning/                              (Board 1)
│   ├── cto.md
│   ├── product-manager.md
│   ├── chief-compliance-officer.md
│   ├── vp-sales.md
│   ├── vp-finance.md
│   └── head-of-customer-success.md
│
└── execution/                             (Board 2)
    ├── cto.md
    ├── product-owner.md
    ├── senior-fullstack-engineer.md
    ├── backend-infrastructure-engineer.md
    ├── ai-rag-engineer.md
    ├── security-engineer.md
    ├── integration-api-engineer.md
    └── ux-ui-designer.md
```

Each file: 400-800+ lines of deeply product-specific content across all 13 sections.

## Key Behaviors This Prompt Triggers

1. **Parallel execution via agent teams** — All 14 profiles are written simultaneously, not sequentially. Total wall-clock time is determined by the slowest agent, not the sum of all agents.

2. **Domain-matched specialists** — Each profile is written by an agent whose expertise matches the role. A security engineer writes the security profile. An AI engineer writes the AI/RAG profile. This ensures domain depth that a generalist cannot match.

3. **PRD context injection** — Every agent receives the full product context, ensuring all 14 documents reference the same architecture, table names, API names, and workflow patterns consistently.

4. **Self-contained system prompts** — Section 13 in each profile produces a copy-paste-ready prompt for instantiating that board member as a live AI agent at any point in the project. This is the most valuable output — it turns static documentation into executable personas.

5. **Verification and fallback** — The prompt includes a post-completion glob check and a fallback strategy for read-only agents that cannot write files. This prevents silent failures.

6. **13-section specification** — The rigid structure ensures consistency across all profiles while the product-specific requirements ensure depth. Every profile follows the same skeleton but contains unique, domain-specific content.

## Lessons Learned / Edge Cases

- **Read-only agent types** (like `compliance-auditor`, `security-auditor`, `qa-expert`) cannot write files. They will produce the content but cannot save it. The orchestrator must either: (a) use a `general-purpose` agent instead, or (b) capture the output and write the file itself.
- **Agent team cleanup** — After all agents complete, send shutdown requests and delete the team to clean up resources.
- **File path spaces** — macOS paths with spaces (e.g., "Mobile Documents") require proper quoting in bash commands but work fine with dedicated Read/Write/Glob tools.
- **CCO/Legal profiles tend to be the longest** — compliance depth for enterprise products generates significantly more content than other roles. Budget accordingly.
