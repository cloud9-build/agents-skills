# Cloud9 Agents & Skills

**Your AI assistant, supercharged.** One install gives your Claude Code (or OpenCode/Gemini CLI) a complete development workflow — from idea to shipped feature.

---

## Install (1 minute)

Paste this into your terminal and hit Enter:

```bash
curl -fsSL https://raw.githubusercontent.com/cloud9-build/agents-skills/main/install.sh | bash
```

It will ask you two questions:

**Question 1: Which tool do you use?**
- Pick **Claude Code** (most of us use this)
- Or pick OpenCode, Gemini CLI, or all three

**Question 2: Where should it install?**

| Option | What it means | Best for |
|--------|--------------|----------|
| **Global** | Works in every project on your machine | Most people — install once, done forever |
| **Local** | Only works in the current project folder | When you want the whole team to share via git |

That's it. Close your terminal, open a new one, and the commands are ready.

---

## What You Get

### The 5-Stage Pipeline

Think of this as a recipe for building anything — from a small feature to a whole project. Each stage has one command. You don't need to memorize them; just start with `/braindump` and it guides you through the rest.

```
  Your idea
     |
     v
 /braindump -----> Asks you 5 questions, writes a plan, gets it reviewed
     |
     v
 /spike ---------> Tests risky parts before you commit (optional, auto-suggested)
     |
     v
 /build ---------> Does the actual work
     |
     v
 /verify --------> Checks that everything works against the original plan
     |
     v
 /retro ---------> Captures what we learned so we don't repeat mistakes
```

### Helper Commands

These work anytime, not just during the pipeline:

| Command | What it does |
|---------|-------------|
| `/workflow` | Shows you where you are in the pipeline and what to do next |
| `/board-review` | Gets expert reviewers to score and critique any document |
| `/blueprint` | Draws a quick visual sketch of an idea (wireframe + architecture + flowchart) |
| `/handoff` | Saves your current progress so someone else (or future you) can pick up where you left off |
| `/sync-master` | Syncs masterCLAUDE.md lessons between your project and the canonical repo (share learning with team) |
| `/supabase-pagination` | Critical pattern guide for avoiding 1000-row limit bugs in Supabase queries |

### Parallel Execution (Advanced)

For power users running multiple Claude windows on the same project:

| Command | What it does |
|---------|-------------|
| `/gm` | Turns on God Mode — coordinates multiple terminals safely |
| `/gm-status` | Shows what each terminal is working on |
| `/gm-sync` | Merges work from all terminals and checks for conflicts |

See [God Mode docs](skills/god-mode/README.md) for the full command list.

---

## How to Use Each Command

### `/braindump <idea>` — Start here

**When:** You have an idea for something to build, big or small.

**What happens:**
1. Claude asks you 5 questions about your idea (just answer in plain English)
2. It writes two files: a **PLAN** (strategy) and a **SPEC** (checklist of what "done" looks like)
3. It picks 3-4 expert reviewers and they score the plan (see [Board Review](#board-review-system) below)
4. If anything looks risky, it flags it for testing
5. You decide: move forward, edit the plan, or stop

**Example:**
```
/braindump Add a dashboard that shows document expiration dates
```

That's all you type. Claude handles the rest.

---

### `/spike` — Test before you commit

**When:** There's a technical risk you want to validate before building the whole thing. Usually auto-suggested by `/braindump` — you rarely need to run this manually.

**What happens:**
- Claude runs a quick experiment (30 min max) to test the risky part
- Writes a result: PASS (safe to build), PIVOT (change approach), or BLOCK (don't build this)

**Example:**
```
/spike Can the API handle 100 concurrent users under 500ms?
```

---

### `/build <task>` — Do the work

**When:** You're ready to build. Either after braindump/spike, or directly for simple tasks like bug fixes.

**What happens:**
1. Claude analyzes the work and picks the best approach:
   - **Single session** — for small fixes (1-3 files)
   - **Multiple agents** — for bigger work that can be done in parallel
   - **Agent team** — for work that needs coordination between specialists
   - **Full project mode** — for phased project work with dependencies
2. You confirm the approach
3. Claude executes it

**Examples:**
```
/build Fix the login button not responding on mobile
/build Implement the notification system from SPEC.md
```

---

### `/verify <phase>` — Check the work

**When:** After building. Usually auto-triggered — you don't need to remember this one.

**What happens:**
- Claude goes through every item in the SPEC checklist
- Runs automated tests where possible
- Lists manual checks you need to do yourself
- Writes a pass/fail report

---

### `/retro` — Learn from it

**When:** After verifying. Also usually auto-triggered.

**What happens:**
- Claude reviews what happened during the build
- Proposes lessons learned (one at a time — you approve or skip each one)
- Saves approved lessons so the team doesn't repeat the same mistakes

---

### `/workflow` — Where am I?

**When:** You forgot where you left off, or you want to know what's next.

**Example:**
```
/workflow status   — shows which stages are done
/workflow next     — tells you the next command to run
```

---

### `/board-review <file>` — Get expert feedback

**When:** You want a structured critique of any document — a plan, architecture doc, PRD, proposal, anything.

**What happens:**
1. Claude recommends 3-4 reviewers from the board
2. You confirm or swap reviewers
3. Each reviewer scores the document on their criteria (1-10)
4. They discuss: where they agree, where they disagree, unique insights
5. You get a composite score and specific recommendations
6. Verdict: APPROVED, APPROVED WITH CONDITIONS, or REVISE AND RESUBMIT

**Example:**
```
/board-review .planning/phases/notifications/PLAN.md
```

---

### `/blueprint <idea>` — Sketch it visually

**When:** You want to see what something looks like before committing to it. Great for aligning with the team.

**What happens:**
- Draws a **UI wireframe** (screen layout)
- Draws a **system architecture** (how the pieces connect)
- Draws a **logic flowchart** (how data moves step by step)
- Writes a plain-English explanation anyone can understand

**Example:**
```
/blueprint Employee onboarding portal with document upload
```

---

### `/handoff` — Save your spot

**When:** You're stopping work and want to make sure nothing gets lost. Maybe you're done for the day, or handing off to someone else.

**What happens:**
- Writes a HANDOFF.md file with:
  - What's done so far
  - What the next step is
  - Important context and decisions made
  - Warnings about tricky spots

**Example:**
```
/handoff
```

---

## Board Review System

The board review system gives you structured feedback from AI "expert reviewers" — each with a different perspective. Think of it like presenting to a panel of advisors.

### What installs automatically (5 reviewers)

These ship with the install and work on any project:

| Reviewer | Their focus | When they're useful |
|----------|-----------|-------------------|
| **The Operator** | Can we actually build and ship this? | Plans with timeline, staffing, or dependency risks |
| **The Economist** | Is this worth the money and time? | Plans with cost or ROI questions |
| **The Customer Advocate** | Do real users actually want this? | User-facing features, product decisions |
| **The Architect** | Will this hold up long-term? | Technical designs, anything that adds complexity |
| **The Contrarian** | What are we missing? What if we're wrong? | Plans with unvalidated assumptions or high stakes |

### Adding project-specific reviewers (optional)

The 5 reviewers above are general-purpose. For deeper, domain-specific feedback, you can create custom board members tailored to your project:

1. Open the prompt file at `skills/boards/prompts/01-design-advisory-boards.md`
2. Give it your project's PRD or requirements doc
3. It designs two boards: a Planning Board (business-focused) and an Execution Board (technical)
4. Run the second prompt (`02-create-board-member-profiles.md`) to generate full reviewer profiles
5. Save them in your project's `docs/board/` folder

After that, `/board-review` finds both your project reviewers AND the 5 built-in ones, and mixes them for balanced feedback.

See `skills/boards/templates/` for examples of what a full reviewer profile looks like.

---

## When to Use What

| Situation | What to do |
|-----------|-----------|
| "I have an idea for a new feature" | `/braindump <idea>` |
| "I need to fix a bug" | `/build Fix <description>` |
| "I want feedback on my plan" | `/board-review <file>` |
| "I want to see what this would look like" | `/blueprint <idea>` |
| "I'm stopping for the day" | `/handoff` |
| "Where did I leave off?" | `/workflow status` |
| "What should I do next?" | `/workflow next` |
| "I just finished building, now what?" | `/verify` then `/retro` (usually auto) |
| "My Supabase query isn't returning all rows" | `/supabase-pagination` |
| "I'm implementing data comparisons" | `/supabase-pagination` (check for pagination needs) |

---

## Troubleshooting

### Commands not showing up?

1. **Restart your terminal** — new skills only load when you start a fresh session
2. **Check the install worked** — type `/workflow` and you should see the pipeline overview
3. **Still nothing?** Try the manual install below

### Manual install (if the curl command doesn't work)

```bash
git clone https://github.com/cloud9-build/agents-skills.git /tmp/agents-skills
mkdir -p ~/.claude/skills
cp -r /tmp/agents-skills/skills/* ~/.claude/skills/
rm -rf /tmp/agents-skills
```

Replace `~/.claude` with `~/.opencode` or `~/.gemini` if you use a different tool.

### Need help?

Ask in the team channel or open an issue on this repo.

---

## For Contributors

Want to add a new skill? See [skills/README.md](skills/README.md) for the format and structure.

---

## License

MIT
