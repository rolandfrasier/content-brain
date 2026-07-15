# Phase 0: Preflight

Purpose: get the member's Mac ready with the free tools we need, and decide where their vault will live.

Work through these steps in order. Say things in your own warm words, the quoted lines are examples of tone, not a script to read verbatim. Always ask before you install or touch anything.

## 1. Greet and set expectations

Introduce what you're building together in two plain sentences, then tell them what this first step is.

Say something like:
> "We're going to build you a 'content brain', one tidy place on your Mac that holds everything you've ever made (posts, videos, podcasts), all searchable and organized, plus a profile of how you sound. I'll do the technical parts and explain each one as we go."
>
> "First I need to get a few small, free tools onto your Mac. This part takes about 10 to 20 minutes, most of it just waiting while things download, you can grab a coffee once it's running."

Reassure them: everything stays on their own machine, and you'll ask before doing anything.

## 2. Decide where the vault will live

This matters, every later step reads and writes to this folder, so pin it down now.

Ask where they'd like their content brain to live, and offer a sensible default:
> "Where should your content brain live on your Mac? If you're not sure, a good default is a folder in your Documents. What's your name or brand called? I'll put it at `~/Documents/<that> Content Brain`."

Once they choose (or accept the default), confirm the full path back to them in plain terms ("So it'll live at ... , sound good?").

Then create the tracking folder and an initial state file. Substitute the chosen path for `<vault>`:

- Run: `mkdir -p "<vault>/.content-brain"`
- Write `<vault>/.content-brain/state.json` with this starting content (fill in the real path and the current time in ISO 8601):

```json
{
  "vault_path": "<vault>",
  "started": "<ISO timestamp now>",
  "phases": {}
}
```

Hold onto `vault_path`, every later phase uses it. Note for your own tracking: the actual vault folders (Home.md, wiki/, etc.) do NOT exist yet; Phase 3 builds them. Right now only the hidden `.content-brain/` folder exists, and that's correct.

## 3. Check what's already installed (with consent)

Tell them you'd like to look at what's already on their Mac, a read-only check that installs nothing yet.

Say:
> "Let me take a quick look at what your Mac already has. This just checks, it won't install or change anything. Okay to run it?"

After they say yes, run:

```
"${CLAUDE_PLUGIN_ROOT}"/scripts/preflight.sh
```

It prints one line per tool in this shape:

```
STATUS<TAB>tool<TAB>state<TAB>detail
```

where `state` is one of `ok`, `missing`, `installed`, or `failed`. Parse each line. The tools it reports are: `brew`, `ffmpeg`, `yt-dlp`, `python3`, `whisper`, `obsidian`.

## 4. Report what you found, in plain English

Tell them which tools are already present and which are missing. When you name a tool, give it one friendly line so they know why it's there:

- **Homebrew**, the free installer that fetches the other tools for you.
- **ffmpeg**, handles audio and video files behind the scenes.
- **yt-dlp**, downloads your videos so we can bring them in.
- **python3**, a small helper that Whisper needs to run.
- **Whisper**, turns speech into text. It's a large one-time download (about 2 to 3 GB) and it's only needed if some of your content has no captions.
- **Obsidian**, the free app that holds your brain and lets you browse it.

Keep it upbeat: "Good news, you already have most of this. We just need two more."

## 5. Install anything missing (with consent, Whisper optional)

If nothing is missing, skip to step 6. Otherwise, list exactly what you'd like to install and ask permission first:
> "You're missing ffmpeg and yt-dlp. These are free and safe, and Homebrew will fetch them. This is the part that takes a few minutes. Want me to go ahead?"

If Homebrew itself needs installing, warn them it may ask for their Mac password, that's normal and it's their own computer asking.

After they say yes, run:

```
"${CLAUDE_PLUGIN_ROOT}"/scripts/preflight.sh --install
```

**Offer to defer Whisper.** Whisper is the heavy one. If it's missing, give them the choice:
> "One of these, Whisper, is a big download (2 to 3 GB) and it's only needed later, for any videos or audio that don't already have captions. Lots of content comes with captions, so we can skip it for now and grab it later only if we actually need it. Install it now, or hold off?"

If they'd rather wait, note that Whisper is deferred to Phase 5 and don't install it now.

## 6. Re-check and handle any failures

Run the check again to confirm the installs took:

```
"${CLAUDE_PLUGIN_ROOT}"/scripts/preflight.sh
```

Report the updated results. Then:

- **If everything now shows `ok` or `installed`:** tell them they're all set and move on.
- **If a tool shows `failed`:** stay calm and don't treat it as the end of the road. The `detail` field on that STATUS line is a one-line manual command (e.g. `brew install ffmpeg`). Share it plainly:
  > "One tool didn't install cleanly. You can finish it yourself by pasting this one line into your Terminal: `brew install ffmpeg`. Want to try that, or shall I?"
- **Offer to continue without it where possible.** If Whisper is the one that failed or was deferred, reassure them we can keep going and only come back to transcription later:
  > "No problem, we can build everything else and only revisit transcription once your content's in. Captions will cover a lot on their own."

Only the missing tool's own feature is affected (e.g. no Whisper just means transcription waits). Don't block the whole pipeline on one optional tool.

## When this phase is done

1. Update `<vault>/.content-brain/state.json`: set `phases.preflight` to
   `{ "done": true, "at": "<ISO timestamp now>", "notes": "<short summary, e.g. 'ffmpeg, yt-dlp, obsidian ok; whisper deferred'>" }`.
2. Load `references/01-interview.md` and begin Phase 1.
