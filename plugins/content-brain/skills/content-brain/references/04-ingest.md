# Phase 4: Ingest

Purpose: run the ingestion plan you agreed on in Phase 2 and pull everything into the vault as organized, linked markdown plus media, one note per item, ready to be transcribed (Phase 5) and tagged (Phase 6).

Read the approved plan from `state.json` (the sources and connectors you resolved in Phase 2) and work it one source at a time.

## Before you start

- **Set expectations.** This is the long phase. Give them a rough sense of time based on how much they have, and tell them they can walk away:
  > "You've got about 200 YouTube videos and two podcast feeds. The downloads will take a while, maybe an hour, mostly unattended. Feel free to grab a coffee, I'll keep going and tell you where I land."
- **Consent is already captured.** You only touch what they approved in Phase 2. In particular, never copy anything off their local disk unless they said yes to that specific folder earlier. If a source wasn't approved, skip it.
- **Show progress.** After each source, tell them the running count:
  > "That's 214 YouTube notes and 63 podcast episodes in so far."

## Principles

- Work **source by source**, finish one before starting the next.
- Every ingested item becomes **one markdown note** with frontmatter. Leave a `tags: []` field empty; Phase 6 fills it against their pillars.
- **Dedupe** by source URL, file hash, or title + date. Never write the same item twice.
- **Never invent content.** Only write notes for things that actually downloaded or exist. If a fetch fails, say so and move on, don't fabricate a note.
- **Keep a per-item record** so a re-run skips what's already done (see "Track progress").

## YouTube

Run:
```
"${CLAUDE_PLUGIN_ROOT}"/scripts/ingest_youtube.sh <url> "<vault>/wiki/sources/youtube"
```
It downloads audio (`.m4a`), metadata (`.info.json`), captions (`.vtt`/`.srt`), and a thumbnail for each video, skipping anything already fetched. It ends with `YT_DONE<TAB><dest>`.

Then, for **each `.info.json`**, write a note at `wiki/sources/youtube/<date>-<slug>.md`:
```markdown
---
title: <video title>
type: youtube
source: <video url>
date: <YYYY-MM-DD upload date>
channel: <uploader>
duration: <hh:mm:ss>
video_id: <id>
tags: []
---

Downloaded files:
- Audio: [[<relative path to the .m4a>]]
- Captions: [[<relative path to the .vtt/.srt, if present>]]
```
Pull every field from the `.info.json` (title, uploader, upload_date, duration, id), don't guess them. Link to the actual downloaded audio and caption files by their real paths (the script saves them under a per-channel subfolder). Transcription happens in Phase 5, so there's no transcript yet.

## Podcast / RSS

Run:
```
"${CLAUDE_PLUGIN_ROOT}"/scripts/ingest_rss.sh <feed-url> "<vault>/wiki/sources/podcast"
```
It saves the raw feed to `feed.xml` and prints item links and audio enclosure URLs as hints. **Read `feed.xml` yourself as the authoritative source**, the printed greps are only a preview, not a full parser. It ends with `RSS_DONE<TAB><raw>`.

Write one note per episode at `wiki/sources/podcast/<date>-<slug>.md`:
```markdown
---
title: <episode title>
type: podcast
source: <episode page url>
date: <YYYY-MM-DD>
audio_url: <enclosure url>
tags: []
---

<episode description / show notes from the feed>
```
Keep the `audio_url`, Phase 5 uses it to fetch and transcribe the audio.

## Newsletter / blog articles

Two paths, depending on what Phase 2 resolved:
- **RSS:** run `ingest_rss.sh <feed-url> "<vault>/wiki/sources/articles"` and turn each item into a note.
- **Individual URLs:** fetch each with WebFetch (load it via ToolSearch first if it isn't available yet).

Write one clean note per article at `wiki/sources/articles/<date>-<slug>.md`:
```markdown
---
title: <article title>
type: article
source: <url>
date: <YYYY-MM-DD>
tags: []
---

<the full article text>
```
**Preserve the full text, never truncate the author's own words.** This corpus is what the Written Voice (Phase 7) is mined from, so completeness matters.

## Google Drive / Docs

If a Drive connector was approved, load the Drive MCP tools via ToolSearch (e.g. `mcp__claude_ai_Google_Drive__search_files`, `mcp__claude_ai_Google_Drive__read_file_content`). Find the docs they pointed you at, read each one, and write it as a markdown note in the right `sources/` subfolder (`articles/`, `books/`, or `transcripts/` as fits):
```markdown
---
title: <doc title>
type: <article|book|transcript>
source: <drive file id>
date: <YYYY-MM-DD>
tags: []
---

<the document text>
```

## Local files (only what they consented to)

Only for folders they explicitly approved in Phase 2. For each approved file:

- **Copy** the original into `wiki/sources/assets/` so the vault is self-contained, **except** very large media (big video/audio files), which you should leave in place and link by absolute path to avoid bloating the vault. Use your judgment on the size cutoff, and tell them which you did:
  > "I copied your documents into the vault and linked your 4 GB video files where they already sit."
- **Extract the text** so it's searchable and mineable later:
  - `.docx`, `.doc`, `.rtf` → `textutil -convert txt "<file>" -output "<out>.txt"`
  - `.pdf` → `pdftotext "<file>" "<out>.txt"` (fall back to `textutil -convert txt` if pdftotext isn't installed)
  - `.epub` → `ebook-convert "<file>" "<out>.txt"` (Calibre; skip if not installed)
- **Write one note per document** with the extracted text and frontmatter:
```markdown
---
title: <file name or doc title>
type: <book|article|transcript|asset>
source: <absolute path to the original>
date: <file date if known>
tags: []
---

<the extracted text>
```

## Dedupe

Before writing any note, check you haven't ingested the item already, match on source URL, file hash, or title + date. Skip duplicates silently rather than writing a second copy.

## Track progress

After each source finishes:
1. Update the counts in `Home.md` and `index.md` (e.g. under `## Sources`, list `youtube, 214`, `podcast, 63`).
2. Append a dated line to `log.md` (e.g. `2026-07-14, ingested 214 YouTube notes from @channel`).
3. Record what's done in `state.json` (e.g. per-source processed ids/hashes, or a simple done-list) so a re-run skips finished items and only picks up what's new.

## When this phase is done

1. Update `state.json`: set `phases.ingest` to
   `{ "done": true, "at": "<ISO timestamp now>", "notes": "<counts by type, e.g. 'youtube 214, podcast 63, articles 40, local 12'>" }`.
2. Give them the tally in plain English:
   > "Everything's in: 214 videos, 63 podcast episodes, 40 articles, and 12 documents, all as linked notes in your vault."
3. Load `references/05-transcribe.md` and begin Phase 5.
