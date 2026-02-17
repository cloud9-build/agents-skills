# masterCLAUDE.md

Cross-project knowledge base for Claude Code sessions. Lessons here apply to ANY project, not just the current one. Copy this file to new projects to carry forward learnings.

---

## Tool & Framework Lessons

### iCloud Drive Creates Phantom Duplicate Files

Projects stored in iCloud Drive (`~/Library/Mobile Documents/com~apple~CloudDocs/`) are subject to sync conflict resolution that silently creates duplicate files with ` 2`, ` 3` suffixes (e.g., `file.sql` → `file 2.sql`). These affect any tool that scans directories for files (Supabase CLI, build tools, test runners). Periodically audit with:
```bash
find . -name "* [0-9].*" -not -path "./.git/*" | head -20
```

---

## Workflow Improvements

### How to Present Instructions to Users

**CRITICAL:** When presenting implementation options or instructions to users, follow these formatting patterns to clearly distinguish what Claude Code can do autonomously vs what requires manual user action.

#### Pattern 1: Lead with Automation Options

Always start by stating what Claude Code can do autonomously BEFORE offering manual alternatives:

```
✅ GOOD:
"I can implement these validation checks now using the Edit tool to modify processor.ts.
Would you like me to:
1. ✨ Implement all three validation checks now (recommended - I'll do the work)
2. 📋 Create a detailed step-by-step plan for you to implement manually
3. 🤖 Hand off to a specialized backend agent"

❌ BAD:
"Ready to start Layer 3? I can:
- Implement the validation checks now
- Create a detailed plan for you to review first
- Hand off to a specialized backend agent"
```

**Why?** The ✨ emoji signals autonomous work. Users should know upfront if they can just say "yes" and Claude will handle it.

#### Pattern 2: Separate Automated vs Manual Work

When explaining what will happen, use clear visual separators:

```markdown
## 🤖 What Claude Code Will Do Automatically

✅ Modify lib/ingestion/processor.ts to add circuit breaker
✅ Add distribution logging after delta computation
✅ Add snapshot existence check
✅ Run TypeScript compiler to verify no errors
✅ Create git commit with changes

## 👤 What You'll Need to Do Manually (If Choosing Manual Path)

⚠️ **Manual implementation is NOT recommended** - Claude Code can do this work for you.

If you choose to implement manually, follow these steps:

**Step 1: Open processor.ts in your editor**
File location: `lib/ingestion/processor.ts`

**Step 2: Add circuit breaker code after line 585**
Copy and paste this code after the delta computation:

\`\`\`typescript
// Circuit breaker: Check pickup ratio
const pickupRatio = deltas.length / ledgerRows.length;
if (pickupRatio > 0.10) {
  console.warn(`⚠️ HIGH PICKUP RATIO: ${(pickupRatio * 100).toFixed(2)}%`);
  console.warn(`   Deltas: ${deltas.length} / Ledger: ${ledgerRows.length}`);
}
\`\`\`

**Step 3: Save the file**
Press Cmd+S (Mac) or Ctrl+S (Windows/Linux)

**Step 4: Verify TypeScript compilation**
Open a terminal in your project directory and run:
\`\`\`bash
npx tsc --noEmit
\`\`\`
```

#### Pattern 3: Terminal Commands with Explicit Context

When providing terminal commands, ALWAYS include the complete context:

```markdown
❌ BAD:
"Run `npm test` to verify"

✅ GOOD:
**Verify tests pass:**
1. Open a new terminal in your project root (`/path/to/project`)
2. Copy and paste this command:
   \`\`\`bash
   npm test
   \`\`\`
3. Press Enter
4. Wait for tests to complete - you should see "All tests passed"
```

#### Pattern 4: File Locations with IDE Links

Always provide both the relative path AND the line number when referencing code:

```markdown
❌ BAD:
"Modify the processor file"

✅ GOOD:
"Modify [lib/ingestion/processor.ts:585](lib/ingestion/processor.ts#L585) - the line after delta computation"
```

#### Pattern 5: Decision Points - Always Recommend Automation

When offering choices, make the automated path the default and explain why:

```markdown
## How Would You Like to Proceed?

**🎯 Recommended:** Let me implement this now (5 minutes)
- I'll modify the necessary files
- Run validation
- Create a git commit
- No manual work required from you

**Alternative Options:**
- 📋 Create a detailed manual implementation guide (if you prefer to code it yourself)
- 🤖 Delegate to a specialized backend subagent (if I'm busy with other work)
- ⏸️  Pause and review the approach first (if you want to discuss strategy)

What's your preference?
```

#### When to Use These Patterns

**Always use these patterns when:**
- Presenting implementation options for a task
- Explaining what will happen during execution
- Providing manual fallback instructions
- Offering choices between automation and manual work

**Pattern enforcement:**
- If presenting work that Claude Code CAN do → Lead with autonomous option, make it the recommended default
- If presenting work that REQUIRES manual steps → Provide explicit, copy-pasteable instructions with terminal context
- If uncertain whether Claude can automate → Ask the user first, then provide formatted options

#### Quick Reference

| Emoji | Meaning |
|-------|---------|
| ✨ | Claude Code will do this autonomously |
| 👤 | Manual user action required |
| 🤖 | Subagent will handle this |
| ⚠️ | Important manual step - follow carefully |
| ✅ | Task Claude Code will complete |
| 📋 | Documentation/plan output |

---

## Update Log

- **2026-02-16**: Added comprehensive instruction presentation patterns (lead with automation, separate manual vs automated work, explicit terminal commands, decision point formatting)
- **2026-02-15**: Added iCloud Drive phantom duplicate files lesson
- **2026-02-14**: Created skeleton for `/retro` skill integration
