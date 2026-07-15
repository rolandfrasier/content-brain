# Phase 2: Source Discovery + Connector Resolution

Purpose: turn the interview's list of where their content lives into a concrete, approved ingestion plan. In this phase you decide HOW each source will be pulled in and get their sign-off. You do not ingest anything yet. The only actions allowed here are light, read-only checks.

Say something like: "Now I'll figure out the best way to pull each of these in, and do a few quick, harmless checks. I won't download or copy anything until you've seen the plan and said go."

## Step 1: Read the inventory

Open the vault's progress file at `<vault>/.content-brain/state.json` and read `interview.inventory`. That is the list of content homes the member gave you (each with a type and a location: a URL, an app, a folder). Work through it item by item.

## Step 2: Resolve each source

For every inventory item, consult `references/connector-playbook.md` and pick the path. Then do a quick, SAFE verification only, enough to know the path will work. Copy nothing.

Safe checks you may run:
- **YouTube:** confirm the handle or playlist resolves with a dry listing, e.g. `yt-dlp --flat-playlist --skip-download <url>` (lists titles, downloads nothing). Note the rough count.
- **RSS / newsletter / podcast:** check the feed URL exists (a WebFetch or a `curl -fsI`). Confirm it looks like a feed before committing to it.
- **Blog:** check for `/sitemap.xml` or a feed so you know how many articles exist.
- **Google Drive / Gmail:** confirm the connector is actually connected (discover the tool via ToolSearch). If it is not, that becomes a member-action item, not a check you force.
- **Local folder:** only with explicit consent, run `"${CLAUDE_PLUGIN_ROOT}"/scripts/local_scan.sh <folder>` so they can SEE what is there before deciding. It lists and copies nothing. See Step 4.

Do not download, transcribe, or read account content in this phase. If a check is not clearly harmless, skip it and note the item as "will confirm at ingest."

## Step 3: Flag member-action items

Some paths need the member to do something that takes time or a decision. Pull these out and list them clearly and early so they can start now while you keep working:

- **Exports that take time:** X/Twitter archive (can be a day+), LinkedIn data copy, Notion export, course/Zoom downloads.
- **A connector to link:** Google Drive or Gmail not yet connected.
- **A key or token to supply:** e.g. Notion API. Remind them the key goes into their own environment, never the vault or a script, and you will tell them exactly where to paste it.

Present these as a short "kick these off now" checklist. Example:

> "A few of these need a quick move from you before I can pull them in:
> 1. X/Twitter: request your archive now (Settings > Download an archive) so it's ready by the time we get there.
> 2. Google Drive: connect it as a connector when you have a sec, or export those docs to a folder.
> Everything else I can handle. Want to start these while I map out the rest?"

## Step 4: Local folders need explicit consent

Before you run even the read-only `local_scan.sh` on a folder, ask for a clear yes for that exact folder:

> "You mentioned your writing is in `~/Documents/Writing`. Can I do a read-only look inside just to list what's there? I won't open, move, or copy a single file, just show you the list."

After they agree, run `"${CLAUDE_PLUGIN_ROOT}"/scripts/local_scan.sh <folder>`, then show them the result and let them decide what is in and what is out. Never scan a folder they did not name.

## Step 5: Assemble the plan and get approval

Build a plain table of every source. Keep it skimmable:

| Source | Type | Path | Rough volume | Prerequisite |
|--------|------|------|--------------|--------------|
| @theirchannel | YouTube | ingest_youtube.sh | ~180 videos | none |
| Their podcast | Podcast | RSS + transcribe | ~60 episodes | find feed URL |
| Substack | Newsletter | RSS (/feed) | ~40 posts | none |
| ~/Documents/Writing | Local text | local_scan.sh | 220 files found | consent given |
| X archive | Social | archive import | unknown | member requesting export |

Present it and ask for approval in plain terms:

> "Here's the full plan for what I'd pull in and how. Look it over. Anything here you'd rather leave out? Anything I missed? Nothing gets touched until you say go."

Let them drop anything they do not want. Adjust the table to match their choices.

## Step 6: Save the approved plan

Write the approved plan into `state.json` under `ingestion_plan` (an array of the sources with their path, destination subfolder, rough volume, and any prerequisite/member-action status). Keep it small and human-readable so a later resume can pick it straight up.

## When done

1. Mark source discovery complete in `state.json`:
   ```json
   "source_discovery": { "done": true, "at": "<ISO>", "notes": "N sources approved, M awaiting member export" }
   ```
2. Load `references/03-vault-setup.md` and begin Phase 3.

Tell them what is next: "Plan's locked in. Next I'll set up your Obsidian vault, the home everything lands in, and then start pulling your content in."
