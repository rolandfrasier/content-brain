# Phase 1: Interview

Purpose: understand the person, capture their frameworks and pillars (these become the tag vocabulary later), decide whether their personal voice differs from their brand voice, and map exactly where all their content lives.

**How to run this whole phase:**
- **One question at a time.** Never stack questions or hand them a form. Ask, wait, listen.
- **Keep questions concrete and easy.** "Which platforms do you post on?" beats "describe your content strategy."
- **Reflect back what you heard** after each section, so they can correct you: "So your audience is early-stage founders, did I get that right?"
- Move at their pace. This is a conversation, not an intake.

Work through sections A, B, C, D in order.

## A. Who they are

Get name, business, and audience, one question at a time.

Ask, in turn:
> "First, what should I call you?"

then:
> "In a sentence or two, what does your business do?"

then:
> "And who's it for, who's your audience?"

**If they have a website, offer to read it** so they don't have to type much:
> "Do you have a website? If you share the link, I can read it and pull the basics myself, you just tell me what I got wrong."

If they give a URL, use WebFetch to read it, then confirm what you learned back to them in plain terms:
> "Okay, from your site it looks like you help [X] do [Y]. Accurate?"

Never state anything the site didn't actually say. If the fetch fails or is thin, just ask them directly.

## B. Their content pillars and frameworks

Capture the 3 to 7 big themes or named frameworks they're known for. This list is important, later phases tag every piece of content against it, so get it right.

Explain simply what you're after:
> "Most people who make content come back to a handful of core themes, or have named frameworks they teach. What are the big ideas you keep returning to? Anywhere from three to seven."

**If you read their website in section A, draft a candidate list first** and have them confirm or edit it, rather than making them start from a blank page:
> "From your site, it looks like your main themes might be: [theme 1], [theme 2], [theme 3]. Which of these feel right, and what am I missing?"

Refine until they're happy. Read the final list back and confirm it's the one to lock in.

## C. Voice check

Decide whether the way they talk as a PERSON differs from their BRAND voice. This one answer decides whether Phase 7 builds a separate Personal Voice DNA, so ask it clearly.

Say:
> "Quick one about voice. Some people sound exactly the same whether it's the brand talking or them personally. Others have a polished brand voice and a looser, more casual way they talk as themselves. Which are you, same voice, or noticeably different?"

If they're unsure, give an example to help: "For instance, is your LinkedIn more buttoned-up than how you'd text a friend about the same idea?"

Record their answer as a simple yes/no: does the personal voice differ from the brand voice?

## D. Content inventory

Map where all their content lives and what type it is. Walk them through it **one channel at a time**, don't dump the whole list on them. Capture handles, URLs, and rough locations. **Do NOT access, download, or open anything yet**, this is only mapping. Access comes in Phase 2, with consent.

Go type by type. For each, ask whether they have it and, if so, where:

**Text**
> "Let's map your writing. Do you have a blog or write articles anywhere?"

Then, one at a time as relevant: a newsletter (Substack, Beehiiv, or another), LinkedIn, X/Twitter, any published books, any PDFs or guides. Capture the handle or URL for each.

**Video**
> "Now video. Are you on YouTube?"

Then, as relevant: online courses, webinars, Vimeo, recorded calls or Zoom sessions. Capture channel URLs or where the files sit.

**Audio / podcast**
> "Do you have a podcast?"

If yes, ask which host it's on (Apple, Spotify, Buzzsprout, Libsyn, etc.) and whether they happen to know the RSS feed URL, reassure them it's fine if they don't, you can find it later.

**On their computer**
Ask plainly:
> "Last one, is there content just sitting on your computer? Folders of videos, documents, recordings, anything like that?"

If yes, ask roughly where (e.g. "a Videos folder on my desktop"), a rough location is enough for now. Don't open or scan it.

Reflect the whole inventory back once you've walked through all four:
> "Here's what I've got for where your content lives: [list]. Anything I missed?"

## Persist everything captured

Write everything from this phase into `<vault>/.content-brain/state.json` (the `vault_path` was set in Phase 0). Add an `interview` object at the top level alongside `vault_path`, `started`, and `phases`. Note: only the `.content-brain/` folder exists right now, the real vault folders arrive in Phase 3, so writing here is correct.

Shape:

```json
{
  "interview": {
    "profile": {
      "name": "<their name>",
      "business": "<one-line what the business does>",
      "audience": "<who it's for>",
      "website": "<url or null>"
    },
    "pillars": ["<pillar 1>", "<pillar 2>", "..."],
    "personal_voice_differs": true,
    "inventory": [
      { "type": "text",    "where": "Substack",  "detail": "https://... / handle" },
      { "type": "video",   "where": "YouTube",   "detail": "channel URL" },
      { "type": "audio",   "where": "podcast",   "detail": "host + RSS if known" },
      { "type": "local",   "where": "Mac",       "detail": "rough folder location" }
    ]
  }
}
```

Fill in real values. Use `null` for anything they don't have. Keep it small and human-readable.

## When this phase is done

1. Update `<vault>/.content-brain/state.json`: set `phases.interview` to
   `{ "done": true, "at": "<ISO timestamp now>", "notes": "<short summary, e.g. '5 pillars, personal voice differs, 4 content sources'>" }`.
2. Load `references/02-source-discovery.md` and begin Phase 2.
