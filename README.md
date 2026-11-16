# NotesVault: Central Multi-Stack Developer Knowledge Base

Welcome to your central, automated technical notes repository. This vault is engineered to capture, organize, and cross-reference your learnings across any programming language, framework, database, infrastructure tool, or architecture pattern.

---

## 📂 Vault Structure

```text
NotesVault/
├── 00_Inbox/                # Landing zone for raw AI chat dumps, web clips, and video notes
├── 01_Languages/            # Systems, scripting, and OOP languages
│   ├── CSharp/
│   ├── Go/
│   ├── Python/
│   ├── Rust/
│   └── TypeScript/
├── 02_Frameworks/           # Application frameworks and SDKs
│   ├── DotNet/
│   ├── FastAPI/
│   ├── React/
│   └── SpringBoot/
├── 03_DevOps_Cloud/         # Containers, orchestration, cloud providers
│   ├── AWS_GCP/
│   ├── Docker/
│   ├── Kubernetes/
│   └── Terraform/
├── 04_Data_Storage/         # Databases, caches, and message streaming
│   ├── Kafka/
│   ├── PostgreSQL/
│   └── Redis/
├── 05_Architecture/         # High-level fundamentals & design paradigms
│   ├── Concurrency/
│   ├── DistributedSystems/
│   └── SystemDesign/
├── 06_Projects/             # Implementation logs from hands-on projects
├── 99_Templates/            # Standard schemas, prompt instructions & clipper settings
│   ├── Universal-Tech-Note.md
│   ├── AI-Chat-Prompt-Instructions.md
│   └── Browser-Extension-Setup.md
└── scripts/                 # Universal automation tools
    ├── quick-capture.ps1    # Saves clipboard AI notes directly into vault
    ├── web-capture.ps1      # Scrapes official docs/articles and formats into a note
    ├── video-capture.ps1    # Extracts video transcripts (YouTube) into a structured note
    └── note-sync.ps1        # Auto-detects code stack in git repos and logs learnings
```

---

## 🚀 The 4 Automated Learning Ingestion Channels

### 1. AI Chat Ingestion (Gemini & ChatGPT)
* Configure your prompt once via [AI-Chat-Prompt-Instructions.md](file:///D:/Desktop%20Projects/NotesVault/99_Templates/AI-Chat-Prompt-Instructions.md).
* In any conversation, type `#savenote`.
* Copy the response and run:
  ```powershell
  & "D:\Desktop Projects\NotesVault\scripts\quick-capture.ps1"
  ```

### 2. Website & Documentation Ingestion
* **Via Terminal CLI**:
  ```powershell
  & "D:\Desktop Projects\NotesVault\scripts\web-capture.ps1" -Url "https://go.dev/doc/effective_go" -Stack "Go"
  ```
* **Via 1-Click Browser Extension**: Use **MarkDownload** (configured with the template in [Browser-Extension-Setup.md](file:///D:/Desktop%20Projects/NotesVault/99_Templates/Browser-Extension-Setup.md)) to download clean Markdown straight into `00_Inbox/`.

### 3. YouTube & Video Tutorial Ingestion
* **Via Terminal CLI**:
  ```powershell
  & "D:\Desktop Projects\NotesVault\scripts\video-capture.ps1" -Url "https://www.youtube.com/watch?v=..." -Stack "Rust"
  ```
  *(Fetches title, video info, and full caption transcript automatically into `00_Inbox/`).*
* **Via Browser Extension**: Use the **YouTube Summary with ChatGPT** extension to grab timestamps and summaries in 1 click.

### 4. Hands-on Code & Git Commits
* Inside any git repository on your machine:
  ```powershell
  & "D:\Desktop Projects\NotesVault\scripts\note-sync.ps1"
  ```
* Sniffs the file extensions (`.cs`, `.go`, `.py`, `.rs`, `.tf`, `Dockerfile`) and logs your session learnings into that stack's `Practice-Log.md`.

---

## 📖 Opening Your Notes
* **Obsidian**: Open Obsidian -> **"Open folder as vault"** -> Select `D:\Desktop Projects\NotesVault`.
* **VS Code**: Run `code "D:\Desktop Projects\NotesVault"`.
