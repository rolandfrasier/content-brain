# Phase 5: Transcribe

Purpose: turn all their ingested audio and video into searchable text, so every spoken word becomes something they can find, tag, and mine for voice later.

Work through these steps in order. Say things in your own warm words, the quoted lines are examples of tone, not a script to read verbatim.

## 1. Sort out Whisper (only if you deferred it)

If you deferred the Whisper install back in Phase 0, check now whether any of their media actually lacks captions. A lot of content, especially YouTube, comes with captions already, and those are instant and free.

- If everything has captions, you don't need Whisper at all. Say so and move on to step 2.
- If some media has no captions, offer to install Whisper now, and be honest that it's a large one-time download:
  > "A few of your videos don't have captions, so to read those I'd need Whisper, the tool that turns speech into text. It's a big one-time download (2 to 3 GB). The captioned stuff I can do without it. Want me to grab Whisper now so we get everything, or skip it and just do the captioned ones for today?"

If they say yes, install it with `"${CLAUDE_PLUGIN_ROOT}"/scripts/preflight.sh --install`, then come back here. If they'd rather skip, that's fine, the captioned items still get done.

## 2. Run the transcriber over each media folder

For every folder that holds audio or video, run `transcribe.sh`. Point it at the source folder and send the output to the shared `transcripts` folder. For example:

```
"${CLAUDE_PLUGIN_ROOT}"/scripts/transcribe.sh "<vault>/wiki/sources/youtube" "<vault>/wiki/sources/transcripts" small
```

Do the same for `podcast/` and any other folder with media in it.

How it behaves:
- It **prefers existing captions**, those convert to text instantly and for free.
- It only runs **Whisper on items that have no captions**.
- The model argument is optional. Default `small` is a good balance of speed and accuracy for spoken word. `tiny` and `base` are faster but rougher; `medium` and `large` are more accurate but slower and heavier. Mention these if they ask, but `small` is a fine default.

## 3. Set expectations honestly

Big libraries can take a while. Tell them the truth before you start so nobody's watching a spinner:
> "Anything with captions is a second or two each. Anything I have to transcribe with Whisper runs somewhere around real-time, a rough fraction of the clip's length depending on the model and how fast your Mac is, so a big back catalog can take a while. Good news: you can walk away. It saves as it goes, skips anything already done, and if we stop and restart it just picks up where it left off."

## 4. Write a transcript note and link it back to the source

For each `.txt` the script produces in `wiki/sources/transcripts/`:

- Create or attach a transcript note in `wiki/sources/transcripts/` holding the **full transcript text, never truncate it**. Preserve every word.
- **Link it from the matching source note** so they travel together: add a `transcript:` link to the source note (in its frontmatter, or in the body) pointing at the transcript note, e.g. `transcript: "[[<source-stem> transcript]]"`.

This two-way connection is what lets them jump from a video straight to its words and back.

## 5. Report the counts

When the run finishes, give them a plain-English tally:
> "Done. That's 118 pulled straight from captions, 46 transcribed with Whisper, and 3 skipped. Here are the 3 that didn't go through, so we can retry them: [list]."

List any failures by name so they can retry. A failure is not the end, the run is resumable, so retrying just re-attempts the ones that didn't finish.

## When this phase is done

1. Update `<vault>/.content-brain/state.json`: set `phases.transcribe` to
   `{ "done": true, "at": "<ISO timestamp now>", "notes": "<counts, e.g. '118 from captions, 46 whispered, 3 failed'>" }`.
2. Load `references/06-tag.md` and begin Phase 6.
