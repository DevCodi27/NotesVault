import os
import sys
import re
import json
import urllib.request
import urllib.parse
from datetime import datetime
from pathlib import Path

VAULT_ROOT = Path(os.environ.get("NOTES_VAULT", r"D:\Desktop Projects\NotesVault"))
INBOX_DIR = VAULT_ROOT / "00_Inbox"

def extract_video_id(url: str) -> str:
    """Extract YouTube video ID from various URL formats."""
    patterns = [
        r'(?:v=|\/)([0-9A-Za-z_-]{11}).*',
        r'youtu\.be\/([0-9A-Za-z_-]{11})',
        r'embed\/([0-9A-Za-z_-]{11})'
    ]
    for pattern in patterns:
        match = re.search(pattern, url)
        if match:
            return match.group(1)
    return ""

def get_video_info_and_transcript(video_id: str):
    """Fetch video metadata and caption track using standard web requests."""
    url = f"https://www.youtube.com/watch?v={video_id}"
    req = urllib.request.Request(
        url,
        headers={"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"}
    )
    
    try:
        with urllib.request.urlopen(req, timeout=10) as response:
            html = response.read().decode('utf-8', errors='ignore')
    except Exception as e:
        return None, f"Failed to load video page: {e}"

    # Extract Title
    title_match = re.search(r'<title>(.*?)</title>', html)
    raw_title = title_match.group(1).replace(" - YouTube", "").strip() if title_match else f"Video_{video_id}"
    clean_title = re.sub(r'[\\/*?:"<>|]', "", raw_title)

    # Search for captions in player response
    transcript_text = ""
    caption_match = re.search(r'"captionTracks":\s*(\[.*?\])', html)
    
    if caption_match:
        try:
            caption_tracks = json.loads(caption_match.group(1))
            # Prefer English, fallback to first available
            track_url = None
            for track in caption_tracks:
                if 'en' in track.get('languageCode', ''):
                    track_url = track.get('baseUrl')
                    break
            if not track_url and caption_tracks:
                track_url = caption_tracks[0].get('baseUrl')

            if track_url:
                with urllib.request.urlopen(track_url, timeout=10) as sub_res:
                    sub_xml = sub_res.read().decode('utf-8', errors='ignore')
                    # Parse xml text lines
                    lines = re.findall(r'<text[^>]*>(.*?)</text>', sub_xml)
                    cleaned_lines = [urllib.parse.unquote(re.sub(r'<[^>]+>', '', l)).replace("&amp;", "&").replace("&#39;", "'").replace("&quot;", '"') for l in lines]
                    transcript_text = " ".join(cleaned_lines)
        except Exception:
            pass

    return {
        "title": clean_title,
        "video_id": video_id,
        "url": url,
        "transcript": transcript_text
    }, None

def main():
    if len(sys.argv) < 2:
        print("Usage: python video-capture.py <YouTube_URL> [Stack_Name]")
        sys.exit(1)

    url = sys.argv[1]
    stack = sys.argv[2] if len(sys.argv) > 2 else "General"
    video_id = extract_video_id(url)

    if not video_id:
        print(f"[ERROR] Could not extract valid YouTube video ID from: {url}")
        sys.exit(1)

    print(f"Fetching video info for ID: {video_id}...")
    info, err = get_video_info_and_transcript(video_id)
    if err:
        print(f"[ERROR] {err}")
        sys.exit(1)

    title = info["title"]
    slug = re.sub(r'[^\w\s-]', '', title).strip().replace(" ", "-")[:60]
    out_file = INBOX_DIR / f"video-{slug}.md"
    today = datetime.now().strftime("%Y-%m-%d")

    transcript = info.get("transcript", "")
    has_transcript = bool(transcript.strip())

    content = f"""---
topic: "{title}"
stack: "{stack}"
category: "Video_Learning"
tags: ["{stack.lower()}", "video-notes", "youtube"]
source_type: "Video"
source_ref: "{url}"
date: {today}
status: "seeded"
---

# 📺 Video Notes: {title}

- **Source URL**: [{url}]({url})
- **Recorded Date**: {today}
- **Assigned Stack**: `{stack}`

---

## 1. Key Takeaways & Architecture Concepts
<!-- Summarize the core lessons learned from this video -->

## 2. Demonstrated Code Snippets & Configurations
```text
// Paste or extract code patterns shown in the video
```

## 3. Practical Gotchas & Tips Mentioned
- 

## 4. Full Extracted Transcript / Timestamps
"""

    if has_transcript:
        content += f"\n<details>\n<summary>Click to view raw video transcript</summary>\n\n{transcript}\n\n</details>\n"
    else:
        content += "\n*(Auto-transcript was not publicly available for this video; record manual notes or use browser extension)*\n"

    INBOX_DIR.mkdir(parents=True, exist_ok=True)
    with open(out_file, "w", encoding="utf-8") as f:
        f.write(content)

    print(f"\n[SUCCESS] Video note created at:")
    print(f"  {out_file}")
    if has_transcript:
        print("  -> Transcript successfully extracted and attached!")

if __name__ == "__main__":
    main()
