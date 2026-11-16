# AI Chat Automation Instructions (Gemini & ChatGPT)

Use these instructions to configure **Google Gemini** and **OpenAI ChatGPT** so they automatically format technical discussions into your standardized notes vault schema.

---

## 1. Setup in ChatGPT
1. Click your profile icon at the bottom left -> **Customize ChatGPT** (or **Custom Instructions**).
2. In the box **"How would you like ChatGPT to respond?"**, paste the prompt below:

```text
Whenever I write "#savenote", "save note", or "generate note" in our chat:
1. Stop responding conversationally. Do not include greetings, introductions, or sign-offs.
2. Synthesize the core concepts, code, and edge cases we discussed into a single clean GitHub-Flavored Markdown note.
3. Strictly adhere to this format:

---
topic: "<Topic Name>"
stack: "<Tech Stack (e.g., Rust, Go, C#, Python, Docker, PostgreSQL)>"
category: "<Languages | Frameworks | DevOps_Cloud | Data_Storage | Architecture>"
tags: ["<stack>", "<topic-slug>", "learnings"]
date: YYYY-MM-DD
source_type: "AI_Chat"
status: "seeded"
---

# <Topic Name>

## 1. Mental Model (Why does this exist?)
- Explain the core problem this solves and the fundamental architectural trade-off.

## 2. Cross-Stack Translation (Rosetta Stone)
- Connect this concept to equivalents in other major languages/frameworks (e.g., how it maps between C#, Go, Python, or Rust).

## 3. Minimal Working Implementation
Provide a minimal, copy-pasteable, production-grade example:
```<language>
// code snippet here
```

## 4. Key Rules & Architectural Behaviors
- Runtime, memory, or lifecycle implications.

## 5. Gotchas & Anti-Patterns
- ⚠️ List real-world pitfalls, memory leaks, concurrency issues, or compiler traps.

## 6. Cheat Sheet & Reference Table
| Syntax / Command / Directive | Function | Example |
| :--- | :--- | :--- |

## 7. Real-World Applications & Context
- When to use in production vs when to choose an alternative.
```

---

## 2. Setup in Google Gemini
* **Option A (In any active chat)**: Whenever you reach a milestone in your learning session, simply type:
  > `#savenote`
  Gemini will follow the schema if you append: *"format as #savenote standard schema"*.
* **Option B (Gemini Gems / Custom Gem)**:
  1. Go to Gemini -> Click **Gem Manager** -> **New Gem**.
  2. Name: `Tech Note Architect`.
  3. Instructions: Paste the same prompt block above.
  4. Use this Gem whenever you are studying a new tech stack.

---

## 3. How to Save into Your Vault
When the AI outputs the Markdown block:
* Click the **Copy** button on the markdown block.
* Run the quick capture script in PowerShell:
  ```powershell
  & "D:\Desktop Projects\NotesVault\scripts\quick-capture.ps1"
  ```
  *(Or paste it into a new `.md` file inside `D:\Desktop Projects\NotesVault\00_Inbox\` or directly in the appropriate stack folder).*
