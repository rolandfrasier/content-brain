# Phase 6: Tag

Purpose: connect every piece of content to the member's own frameworks, so the vault becomes one navigable graph instead of a pile of files. When this is done, they can click a pillar and see everything they've ever made about it.

This phase touches a lot of files. Work in batches, show progress as you go, and skip anything already tagged, it's resumable.

## 1. Load their pillars and concept notes

Read the member's pillars from `state.json` (`interview.pillars`), and open their concept notes in `wiki/concepts/`. These pillars are the tag vocabulary, the whole point is to connect content back to *their* frameworks, not any generic scheme.

## 2. Tag every source and transcript note

Go through every note in `wiki/sources/` (including the transcript notes). For each one:

- **Read it** so you know what it's actually about.
- Decide which **1 to 3 pillars** it genuinely belongs to. Add them as tags in the note's frontmatter: `tags: [pillar-a, pillar-b]`.
- Add a **few free keywords** drawn from the actual content, real topics, names, and terms that appear in the piece.
- Add a **wikilink** from the note to each relevant concept note, e.g. `[[<Pillar>]]`, so Obsidian's graph view draws the connection.

**Never assign a pillar the content doesn't actually support.** If a piece only fits one pillar, give it one. If it fits none cleanly, leave it untagged rather than forcing it. Honest tags keep the graph trustworthy.

## 3. Mark notable moments in long transcripts (optional)

For long transcripts, you may add a short list of **3 to 6 notable moments**, a rough timestamp and a one-line description each, but only where the transcript clearly supports it. This makes the archive searchable at a glance ("where did I talk about pricing?").

Keep it honest and short. **Do not fabricate** moments, quotes, or timestamps. If the transcript doesn't clearly show it, don't list it.

## 4. Update the concept notes

For each concept note in `wiki/concepts/`, add a short summary or a backlinks-style list of what content now supports it, which videos, articles, and episodes touch that pillar. Obsidian shows backlinks automatically too, but a short human summary at the top makes each pillar note a real hub.

## 5. Refresh the index and log

- Update `index.md` so it maps their sources by pillar, a reader should be able to scan it and see what they've made under each theme.
- Append a short progress line to `log.md`.

## When this phase is done

1. Update `<vault>/.content-brain/state.json`: set `phases.tag` to
   `{ "done": true, "at": "<ISO timestamp now>", "notes": "<short summary, e.g. '164 notes tagged across 5 pillars'>" }`.
2. Load `references/07-voice-dna.md` and begin Phase 7.
