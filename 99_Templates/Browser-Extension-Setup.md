# Browser Extensions for 1-Click Note Taking (Web & Video)

If you prefer **zero-terminal, 1-click capture** directly while browsing docs or watching video tutorials on Chrome, Edge, or Brave:

---

## 1. Official Documentation & Web Articles (MarkDownload)

**MarkDownload** converts any web page (Microsoft Learn, Go docs, MDN, StackOverflow, Medium) into clean, ad-free Markdown with syntax-highlighted code blocks.

### Quick Setup:
1. Install **[MarkDownload - Markdown Web Clipper](https://chromewebstore.google.com/detail/markdownload-markdown-web/pcmpcfapbekmbjjkdalclhumgahdekbe)** from the Chrome Web Store.
2. Open the extension **Options**:
   * **Default download folder**: Set to `NotesVault/00_Inbox` (or your browser's default download folder).
   * **Template**: Paste this custom frontmatter template:
     ```markdown
     ---
     topic: "{pageTitle}"
     stack: "General"
     category: "Web_Documentation"
     tags: ["documentation", "web-notes"]
     source_type: "Documentation"
     source_ref: "{pageUrl}"
     date: {date:YYYY-MM-DD}
     status: "seeded"
     ---

     # 🌐 {pageTitle}

     - **Source URL**: [{pageUrl}]({pageUrl})

     ---

     ## 1. Key Takeaways & Architecture Concepts
     <!-- Summarize the core takeaway -->

     ## 2. Clipped Content & Code
     {article}
     ```
3. **Usage**:
   * When reading documentation, click the MarkDownload extension icon -> click **Download**.
   * It drops the clean Markdown file straight into `00_Inbox/`.

---

## 2. YouTube & Video Courses (Glasp / YouTube Summary)

Extract transcripts and summaries with code timestamps directly on YouTube without leaving the video player.

### Quick Setup:
1. Install **[YouTube Summary with ChatGPT & Claude](https://chromewebstore.google.com/detail/youtube-summary-with-chat/nmmicjeknamkfloonkhhcjmomieiodli)** or **[Glasp](https://glasp.co/)**.
2. **How to Use**:
   * Open any YouTube tutorial (e.g. "Go Concurrency in 10 Minutes" or "Docker Deep Dive").
   * Look at the top right of the video player: click the **"Transcript & Summary"** box.
   * Click the **Copy Transcript** button or the **AI Summary** button (which sends the transcript to Gemini/ChatGPT).
   * In the chat, type `#savenote`.
   * Run `quick-capture.ps1` to save it directly into `NotesVault`.
