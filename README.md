# Content Brain

A Claude Code plugin that builds a person their own **content brain** from scratch: an Obsidian vault holding everything they've ever made, ingested, transcribed, tagged to their own frameworks, and topped with a full Voice DNA set.

One command, an interview, and a guided pipeline that does the technical work for a non-technical owner, on their own Mac.

> **What this is:** the foundation. It builds everything a content system would read *from*.
> **What this is not:** a content system. It never generates, schedules, or publishes anything. When it finishes, the owner has a complete brain and is free to build whatever they want on top of it.

## Install (for members)

Hand members [`GETTING-STARTED.md`](./GETTING-STARTED.md).

> **Printable handout:** [`docs/Content-Brain-Getting-Started.pdf`](./docs/Content-Brain-Getting-Started.pdf) · using both tools together: [`docs/Using-Them-Together.pdf`](./docs/Using-Them-Together.pdf)
> **How it works (human-readable):** the complete skill (orchestrator + all nine phases) as a single PDF: [`docs/ContentBrainSKILL.pdf`](./docs/ContentBrainSKILL.pdf).
 The short version, from inside Claude Code, run these three one at a time:

```
/plugin marketplace add rolandfrasier/content-brain
```

```
/plugin install content-brain@dragonfly
```

```
/content-brain
```

> Members install from `rolandfrasier/content-brain`.

## What it does

Nine phases, run in order, resumable at any point:

| # | Phase | What happens |
|---|-------|--------------|
| 0 | Preflight | Checks and installs free tools (Homebrew, ffmpeg, yt-dlp, Whisper, Obsidian) |
| 1 | Interview | Who they are, their pillars/frameworks, where their content lives |
| 2 | Source discovery | Resolves the best ingestion path per source, produces an approved plan |
| 3 | Vault setup | Scaffolds an Obsidian vault structured like ours, opens it |
| 4 | Ingest | Pulls all content in as organized, linked markdown + media |
| 5 | Transcribe | Captions or Whisper over every audio/video, timestamp-aligned |
| 6 | Tag | Tags all content against the owner's own frameworks |
| 7 | Voice DNA | Brand, Personal, Written, and Spoken voice, the centerpiece |
| 8 | Handoff | A summary of what they own and a map to it |

## The Voice DNA set

Four cross-linked notes in `wiki/voice/`:

- **Brand Voice DNA**, how the business sounds
- **Personal Voice DNA**, how the person sounds as themselves (only if it differs)
- **Written Voice**, mined from their text (sentence shape, habits, transitions)
- **Spoken Voice**, mined from their transcripts (words per minute, signature phrases, cadence)

Written and spoken are kept separate on purpose. People don't write the way they talk.

## Layout

```
.claude-plugin/marketplace.json        # marketplace "dragonfly", lists the plugin
plugins/content-brain/
  .claude-plugin/plugin.json
  skills/content-brain/
    SKILL.md                           # the orchestrator
    references/                         # one file per phase, loaded on demand
  scripts/                             # preflight, vault_init, ingest, transcribe, local_scan
GETTING-STARTED.md                     # the one-page handout for members
```

## Design notes

- **Consent-gated.** Nothing is scanned, downloaded, or copied without the owner saying yes to that specific thing. Their content stays on their machine.
- **No graphify.** The "graph" is Obsidian's native linked-notes view; graphify is not bundled.
- **Per-member tags.** The tag vocabulary is the owner's own frameworks, discovered in the interview. Nothing from any other person's system travels in the plugin.
- **Resumable.** Progress lives in `<vault>/.content-brain/state.json`; re-running continues where it left off.

Built for the Dragonfly Mastermind.
