# Phase 7: Voice DNA

**Purpose:** distill how this person actually sounds into a small set of durable notes, so every future word can be checked against their real voice instead of a generic one. This is the centerpiece of the whole build.

You now have their corpus ingested, transcribed, and tagged. That corpus is the evidence. Your job is to read it, draft their voice on file, and walk them through confirming it. **Never invent a trait, phrase, or example that the corpus does not actually show.** If the evidence is thin somewhere, say so and build only what's supported.

You are producing up to **four** cross-linked notes in `wiki/voice/`:

1. **Brand Voice DNA**, how the business sounds
2. **Personal Voice DNA**, how the person sounds as themselves (only if they told you these differ)
3. **Written Voice**, how they write (mined from their text)
4. **Spoken Voice**, how they talk (mined from their transcripts), a genuinely different instrument

Written and spoken are kept separate on purpose. People do not write the way they talk. The pace, the phrases, the sentence shapes are different, and the whole point is to capture both truthfully.

---

## How this phase works

For each note: **gather the evidence → analyze it → draft the note → walk them through it → finalize.** Show them what you found and let them correct it. Their confirmation is what makes the file trustworthy.

Tell them up front, warmly: *"This is the part that makes everything sound like you and not like a robot. I'm going to read back through everything you've made, pull out how you actually write and how you actually talk, and then check it with you."*

---

## Step 1: Written Voice

**Gather.** Pull the text corpus: everything under `wiki/sources/articles/`, `wiki/sources/books/`, and any extracted documents. Use their real, self-written prose, not transcripts (those are Spoken Voice).

**Analyze honestly, from the actual text:**
- **Sentence shape**, typical length, how much they vary it, short-punch vs long-winding.
- **Structure**, how they open a piece, how they build, how they close. Do they lead with a story, a claim, a question, a number?
- **Punctuation habits**, describe what they *actually* do (lists, dashes, parentheticals, one-line paragraphs, ALL CAPS for emphasis). Report their habits truthfully; do not impose anyone else's rules on their voice.
- **Transitions and connective tissue**, the words they reach for to move between ideas ("Here's the thing", "But", "So", "Look").
- **Vocabulary and register**, plain vs technical, formal vs casual; a reading-grade feel (roughly, from sentence and word length, don't overstate precision).
- **Rhetorical moves**, the reveal, the contrast, the confession, the direct address, the rule-of-three, whatever recurs.

**Draft** `wiki/voice/Written Voice.md` with frontmatter `type: voice` and sections for each of the above, each backed by **8-12 real quoted lines pulled verbatim from their writing** (cite the source note with a [[wikilink]]). The quotes are the proof, they matter more than your adjectives.

**Walk them through it.** Show the headline findings and 3-4 example quotes. Ask: *"Does this feel like how you write? Anything I've overstated or missed?"* Fold in their corrections.

If there is little or no written content, say so plainly and note that Written Voice is light for now and will grow as they add writing.

---

## Step 2: Spoken Voice

**Gather.** Pull the transcripts under `wiki/sources/transcripts/`. For pace, you also need durations of the underlying media.

**Compute words per minute (real number, not a guess):**
- Word count of a transcript: `wc -w "<transcript>.txt"`.
- Duration of its media: from the YouTube `.info.json` `duration` field, or run `ffprobe -v quiet -show_entries format=duration -of csv=p=0 "<media-file>"` (seconds).
- WPM = words ÷ (seconds ÷ 60). Do this across several representative pieces and report a typical range (e.g. "about 165-180 wpm"). Most conversational speakers land somewhere around 130-190 wpm, but report their real measured number, never an assumption.

**Analyze from the transcripts:**
- **Signature openers**, how they start talking / start an answer.
- **Recurring phrases and verbal tics**, the expressions that show up again and again (quote the real ones, with counts if you can, e.g. "'ask me how I know' appears 14 times").
- **Filler and rhythm**, their natural filler words, pauses, the cadence of how a spoken sentence runs.
- **How they walk to a point**, do they set up with a number and pay it off? Tell a mini-story then land the lesson? Ask then answer?
- **Energy and register when speaking** vs writing, often looser, faster, more digressive.

**Draft** `wiki/voice/Spoken Voice.md` (`type: voice`) with the WPM figure up top, then each section backed by **verbatim quoted phrases** from real transcripts ([[wikilink]] the source). Note which phrases are frequent vs one-offs.

**Walk them through it.** Play back the standout findings, the WPM number and their top signature phrases usually land well. *"These are the phrases you actually reach for out loud, sound right? Any you'd never want in your name?"* Fold in corrections.

If there is no audio/video, say so and skip Spoken Voice for now, noting it can be built later once they have recordings.

---

## Step 3: Brand Voice DNA

This is how the **business** sounds in public. Synthesize from their content *and* the interview profile (`interview.profile`, `interview.pillars` in state.json).

**Draft** `wiki/voice/Brand Voice DNA.md` (`type: voice`) covering:
- **Positioning**, who they help and what they stand for, in a line.
- **Audience**, who they're talking to.
- **Core messages**, the handful of things the brand says over and over (tie each to a [[pillar]] concept note where relevant).
- **Signature vocabulary**, the words and phrases that are theirs; the words they avoid.
- **Tone**, 3-5 adjectives, each with a real example.
- **Do / Don't**, concrete guardrails drawn from how they actually show up (e.g. "Do lead with a real number. Don't use hype adjectives.").

Keep every claim grounded in real examples from the corpus. **Walk them through it** and let them sharpen the do/don't list, that's the part they'll have the strongest opinions on.

---

## Step 4: Personal Voice DNA (conditional)

**Only build this if** `interview.personal_voice_differs` is true. If their personal and brand voice are the same, skip it and say so, one honest Brand Voice note is better than two padded ones.

If they differ, draft `wiki/voice/Personal Voice DNA.md` (`type: voice`) describing how they sound as *themselves*, the looser, off-brand, this-is-just-me register, drawn mostly from casual spoken moments and any personal writing. Contrast it explicitly with the brand voice ("Brand is X; personally they're more Y"). Walk them through it.

---

## Step 5: Wire it together

- Cross-link the four notes to each other and link each from `index.md` under the Voice section (the starter `index.md` already lists them).
- Add a one-line pointer in `Home.md` to the Voice set.
- Make sure every voice trait that cites the corpus uses a real [[wikilink]] to the source note, so a reader can click straight to the evidence.

---

## When this phase is done

Update `<vault>/.content-brain/state.json`: set `phases.voice_dna` to `{ "done": true, "at": "<ISO>", "notes": "built: written, spoken, brand[, personal]; wpm ~<n>" }`. Note which of the four you built and which you skipped and why.

Then load `references/08-handoff.md` and begin the final phase.
