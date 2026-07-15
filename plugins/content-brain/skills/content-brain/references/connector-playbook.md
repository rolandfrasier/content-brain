# Connector Playbook

Purpose: a lookup table you consult to pick the best, safest way to pull in each kind of content. Match the source to a row, follow the recommended path, and do the "member action" note where the person has to do something themselves.

## How to use this

- Detect the source type from what they told you in the interview (a URL, an app name, "it's a folder on my Mac").
- Prefer the least-effort path that gets clean text: existing captions and RSS beat re-downloading and re-transcribing.
- Copy nothing until they have approved it (Phase 2 assembles the plan, Phase 4 runs it).
- **Secrets stay with them.** If a path needs an API key or token, the member enters it into their own environment (a shell variable or the tool's own login). Never write a key or password into the vault, a note, a script, or `state.json`. If you need one, tell them exactly where to paste it and confirm it is set, never store the value yourself.

---

## YouTube: channel, playlist, or single video

- **Detect:** a `youtube.com`, `youtu.be`, `@handle`, `/channel/`, `/playlist?list=`, or `/watch?v=` URL.
- **Path:** download audio + metadata + captions with yt-dlp; you turn the `.info.json` files into notes, then transcribe.
- **Tool:** `"${CLAUDE_PLUGIN_ROOT}"/scripts/ingest_youtube.sh <url> <vault>/wiki/sources/youtube`
- **Member action:** none for public content. For unlisted or members-only videos, they must give you the exact links (and yt-dlp may need their cookies, which they export themselves).

## Podcast

- **Detect:** an Apple Podcasts or Spotify show page, or "my podcast."
- **Path:** find the RSS feed, then transcribe the audio.
  1. From an Apple Podcasts page: use WebFetch on the page and look for the feed, or ask the host platform.
  2. From Spotify (which hides the feed): ask the member where else the show is listed, or search the show name plus "RSS feed."
  3. Run `"${CLAUDE_PLUGIN_ROOT}"/scripts/ingest_rss.sh <feed-url> <vault>/wiki/sources/podcast` to save the feed and list audio enclosures.
  4. Run `"${CLAUDE_PLUGIN_ROOT}"/scripts/transcribe.sh <audio-file-or-dir> <vault>/wiki/sources/transcripts` on the enclosures.
- **Member action:** if you cannot find the feed, ask: "Can you paste the RSS link for your show? It's usually in your podcast host's settings, like Buzzsprout or Libsyn."

## Newsletter: Substack / Beehiiv / Ghost / Mailchimp

- **Detect:** a newsletter domain, a `*.substack.com`, `*.beehiiv.com`, or "my newsletter."
- **Path:** most expose a public RSS feed.
  1. Try the feed first: Substack and Ghost are usually `<site>/feed`, Beehiiv `<site>/feed`. Run `"${CLAUDE_PLUGIN_ROOT}"/scripts/ingest_rss.sh <feed-url> <vault>/wiki/sources/articles`.
  2. If there is no feed, WebFetch the public archive page and each post into markdown.
  3. To recover past issues they SENT (not just public ones), the Gmail MCP can search their own outbox. Discover it via ToolSearch, then use `search_threads` / `get_thread`.
- **Member action:** if the archive is private, ask them to make it public briefly or to export from the platform. For Gmail, they must have Gmail connected as an MCP connector, only search their own mail, and only with their yes.

## Blog / website articles

- **Detect:** a personal or company site with articles.
- **Path:**
  1. Try `<site>/sitemap.xml` (or `/sitemap_index.xml`) to enumerate every article URL.
  2. Also try an RSS feed (`/feed`, `/rss`, `/feed.xml`).
  3. WebFetch each article URL and save it as clean markdown into `<vault>/wiki/sources/articles`.
- **Member action:** none, if the site is public. For a members-only blog, they supply the login or export.

## Google Docs / Google Drive

- **Detect:** a `docs.google.com` or `drive.google.com` link, or "my writing is in Google Docs."
- **Path:** use the Google Drive MCP. Discover it via ToolSearch, then `search_files` to find their docs, `get_file_metadata` to confirm, and `read_file_content` / `download_file_content` to pull the text.
- **Member action:** if Drive is not connected, say: "To reach your Google Docs I need you to connect Google Drive as a connector. Want me to wait while you do that?" If they would rather not connect it, ask them to export the docs (File > Download) to a local folder, then use `"${CLAUDE_PLUGIN_ROOT}"/scripts/local_scan.sh <folder>`.

## Notion

- **Detect:** a `notion.so` link or "my notes are in Notion."
- **Path (simplest):** ask them to export. In Notion: the `•••` menu > Export > Markdown & CSV, for the page or whole workspace. Then `"${CLAUDE_PLUGIN_ROOT}"/scripts/local_scan.sh <unzipped-export-folder>`.
- **Path (advanced):** the Notion API with their integration token, if they are comfortable creating one.
- **Member action:** run the export, or create a Notion integration and share the pages with it. If they use the token route, they paste it into their own environment, never into the vault.

## Dropbox / iCloud / OneDrive

- **Detect:** files live in a cloud drive.
- **Path:** if the drive is synced to a local folder (most are, e.g. `~/Dropbox`, `~/Library/Mobile Documents/...` for iCloud, `~/OneDrive`), treat it as a local folder and use `"${CLAUDE_PLUGIN_ROOT}"/scripts/local_scan.sh <folder>`. If it is online-only, they export or download a copy first.
- **Member action:** confirm the folder is fully downloaded (not just placeholders). For iCloud, files may need "Download Now" first. Consent required before any scan.

## Local files on their Mac

- **Detect:** "it's in a folder," "on my desktop," "in my Documents."
- **Path:** `"${CLAUDE_PLUGIN_ROOT}"/scripts/local_scan.sh <folder>`. It lists candidate files and copies nothing. Show them the list, let them pick, then ingest what they chose.
- **Member action:** they point you at the exact folder and say yes to the read-only scan first. Never scan a folder they have not named.

## X / Twitter

- **Detect:** an `x.com` / `twitter.com` handle or "my tweets."
- **Path:** have them request their data archive, then ingest it.
  1. Member action: on X, Settings > "Your account" > "Download an archive of your data" (this can take a day or more to arrive).
  2. When the archive lands, it is a zip containing `data/tweets.js` (or a CSV). Point `"${CLAUDE_PLUGIN_ROOT}"/scripts/local_scan.sh <unzipped-folder>` at it, then read the tweets file and turn posts into notes.
- **Member action:** request the archive early since it is slow; flag it in Phase 2 as a "kick this off now" item.

## LinkedIn

- **Detect:** a LinkedIn profile or "my LinkedIn posts."
- **Path:** have them request their export, then ingest it.
  1. Member action: LinkedIn > Settings & Privacy > "Data privacy" > "Get a copy of your data." Pick posts/articles. It arrives by email, often within minutes to a day.
  2. When it arrives, unzip and point `"${CLAUDE_PLUGIN_ROOT}"/scripts/local_scan.sh <folder>` at it; the posts come as CSV/HTML you turn into notes.
- **Member action:** request early; flag as a wait-for-export item in Phase 2.

## Books / PDFs / ebooks

- **Detect:** a book they wrote, PDFs, `.epub` files, manuscripts.
- **Path:** these are local files. After `local_scan.sh` finds them, extract text by format:
  - PDF: `pdftotext <file.pdf> <out.txt>` (from poppler), or macOS `textutil -convert txt <file.pdf>`.
  - Word `.docx`: `textutil -convert txt <file.docx>` (built into macOS).
  - EPUB: `ebook-convert <file.epub> <out.txt>` if Calibre is installed; if not, note the file for manual handling rather than guessing at its contents.
- **Member action:** they point you at the files and confirm they have the rights to them. If a format needs Calibre and it is missing, tell them and offer to move on: "Your EPUB needs a tool called Calibre to read. Want to install it, or should I skip these for now?"

## Courses / webinars / recorded calls: Vimeo, Wistia, Zoom, Riverside

- **Detect:** a course platform, webinar replay, or recorded-call link.
- **Path:**
  1. If the URL is one yt-dlp supports (many Vimeo, Wistia, and public replay links are), use `"${CLAUDE_PLUGIN_ROOT}"/scripts/ingest_youtube.sh <url> <vault>/wiki/sources/...` (it drives yt-dlp, which handles far more than YouTube).
  2. If the platform blocks download or needs a login, have them download the recording from their own account, then treat it as a local file: `"${CLAUDE_PLUGIN_ROOT}"/scripts/local_scan.sh <folder>` then `transcribe.sh`.
- **Member action:** for gated content, they download their own copies (Zoom cloud recordings, Riverside exports, course downloads) into a folder and point you at it.

---

## When nothing fits

If a source does not match any row, do not guess or fabricate. Tell the member plainly: "I don't have a clean automatic way to pull that one in. The reliable options are: export it to a folder, or give me a public link." Capture it as a member-action item and move on.
