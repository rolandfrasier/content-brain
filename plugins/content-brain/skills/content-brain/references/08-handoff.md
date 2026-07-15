# Phase 8: Handoff

Purpose: show the member everything they now own and leave them a clear map they can use on their own. This is the final phase. When it's done, the run is complete.

Say things in your own warm words, the quoted lines are examples of tone.

## 1. Write the handoff note

Create `wiki/HANDOFF.md` and link it from `Home.md`. It's their map to what they now have. Include:

- **Counts by content type**, how many videos, articles, podcast episodes, books, etc. (use the real numbers from `state.json` and the vault).
- **Where each type lives**, the folder under `wiki/sources/` for each.
- **That it's all transcribed and tagged** to their own pillars, so it's searchable and connected.
- **Where the Voice DNA set lives**, `wiki/voice/`: Brand Voice DNA, Personal Voice DNA (if it was built), Written Voice, and Spoken Voice.

Keep it plain and skimmable, this is the note they'll come back to.

## 2. A short "how to use Obsidian" primer

They may be new to Obsidian, so give them a few friendly basics for a non-technical owner:

> "A few things to know about your new vault:
> - Open it in the Obsidian app any time, everything is right here on your Mac.
> - Use **search** (top of the sidebar) to find anything by word or phrase.
> - Click the **graph view** to see your whole brain as a web of connected notes.
> - Any `[[link]]` or `#tag` is clickable, follow them to jump between related pieces.
> - It's all plain text files that you own. Nothing's locked in; nothing leaves your machine."

## 3. A generic "what's next" paragraph

Give them one short, non-prescriptive paragraph. They now have a complete content brain, a foundation, and could, if they want, build their own content system on top of it. **Give no blueprint, no steps, and no mention of generating, scheduling, or posting mechanics.** Just point at the possibility and hand them the keys:

> "That's the foundation done, a complete, organized brain of everything you've made and how you sound. What you build on top of it from here is entirely up to you. It's yours."

## 4. Congratulate them: specifically

Use the real counts. Make it land:
> "This is a real milestone. You now have 214 videos, 96 articles, and 140 podcast episodes, all transcribed, tagged to your five pillars, and topped with your Voice DNA. Everything you've ever made, in one searchable place you own. Nicely done."

## When this phase is done

1. Update `<vault>/.content-brain/state.json`: set `phases.handoff` to
   `{ "done": true, "at": "<ISO timestamp now>", "notes": "<short summary>" }`, and mark the whole run complete (e.g. set a top-level `"complete": true` with the current timestamp).
2. **Do not load another phase, this is the end.**
