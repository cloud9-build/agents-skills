---
name: blueprint
description: Generate a visual blueprint (wireframe, architecture, flowchart) and plain-language explanation for any idea
argument-hint: "<your idea>"
allowed-tools:
  - Read
  - Glob
  - Grep
---

# /blueprint: Visual Blueprint Generator

## Trigger
User runs `/blueprint <idea>` in a Claude Code terminal.

## Purpose
Generate three ASCII visual diagrams and a plain-language explanation for any idea, feature, or system concept. Helps teams align on what they're building before writing code.

## Input

The user has provided this idea: `$ARGUMENTS`

If `$ARGUMENTS` is empty, ask the user to describe their idea and stop.

## Step 1: Gather Context

Before generating the blueprint, check if the project has planning docs that provide relevant context:
- Look for project definition files (e.g., `PROJECT.md`, `README.md`)
- Look for frontend specs or architecture docs
- Only read files that are relevant to the idea

If no planning docs exist, proceed with the idea as described.

## Step 2: Visual Planning

Deliver all three visuals in order:

### 1. UI Wireframe

Create a low-fidelity ASCII wireframe mapping the screen layout. Show panels, buttons, inputs, and content areas using box-drawing characters. Label every element clearly.

```
Example:
+--------------------------------------------------+
| [ Logo ]              [ Search... ]    [ Avatar ] |
+--------------------------------------------------+
| Sidebar    |  Main Content Area                   |
|            |                                      |
| > Nav 1    |  +-------------------------------+   |
| > Nav 2    |  | Card Title                    |   |
| > Nav 3    |  | Description text here...      |   |
|            |  | [Action Button]               |   |
|            |  +-------------------------------+   |
+--------------------------------------------------+
```

### 2. System Architecture Diagram

Show the main modules and services as labeled boxes with connections between them. Include databases, APIs, external services, and the user. Use ASCII box art.

```
Example:
+--------+     +----------+     +-----------+
| Client | --> | API      | --> | Database  |
+--------+     +----------+     +-----------+
                    |
                    v
               +-----------+
               | External  |
               | Service   |
               +-----------+
```

### 3. Logic Flowchart

Show how data moves through the system step-by-step with arrows. Include decision points (yes/no branches), user actions, and system responses.

```
Example:
[User Action]
      |
      v
  <Decision?>
   /       \
  YES       NO
  |          |
  v          v
[Result]  [Fallback]
```

## Step 3: Plain-Language Explanation

Immediately after the three visuals, explain the entire concept. Rules:
- Use simple, non-technical language. Zero coding jargon.
- Short, punchy sentences. One idea per sentence.
- Follow a logical flow: what is it, who uses it, how it works, what happens at each step.
- Focus on WHAT we are building and HOW it works logistically — not how it's coded.
- The reader should be able to see and understand the full blueprint without any technical background.

## Output Format

```
## Blueprint: <Idea Title>

### UI Wireframe
<ascii wireframe>

### System Architecture
<ascii architecture diagram>

### Logic Flow
<ascii flowchart>

### How It Works
<plain-language explanation>
```
