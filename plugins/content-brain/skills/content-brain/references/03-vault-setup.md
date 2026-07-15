# Phase 3: Vault setup

Purpose: build their Obsidian vault, structured exactly like ours, and open it so they can watch their brain take shape.

By now the interview (Phase 1) and source discovery (Phase 2) are done, and `state.json` holds their profile, their pillars, and the approved ingestion plan. This phase creates the (still empty) vault and seeds it with their frameworks and brand. Nothing is ingested yet, that's Phase 4.

## 1. Read the vault path

Open `<vault>/.content-brain/state.json` and read `vault_path`, you set this back in Phase 0. Every command below writes inside that folder. If it's missing, something went wrong earlier; go back and re-confirm the path rather than guessing one.

## 2. Explain Obsidian in one friendly line

Before you build anything, tell them what they're about to see. One plain sentence:
> "Obsidian is a free app where every note is just a plain-text file sitting on your Mac. The notes link to each other to form one connected map of your work, and because it's all plain text it's yours forever, no cloud, no lock-in."

## 3. Scaffold the vault

Run the init script. It creates the folders and starter notes, and it's safe to run more than once (it keeps anything that already exists):

```
"${CLAUDE_PLUGIN_ROOT}"/scripts/vault_init.sh "<vault_path>"
```

It prints one `wrote` or `kept` line per file and finishes with:

```
VAULT_READY<TAB><vault_path>
```

Tell them what it made, in plain terms: a Home note, an index (the map of everything), a running log, and a set of `wiki/` folders, `sources/` for their content, `voice/` for their Voice DNA, `concepts/` for their frameworks, plus entities, systems, builds, and prompts.

## 4. Seed their frameworks (concepts)

Their pillars are the tags everything will hang on later, so create one note per pillar now. Read `interview.pillars` from `state.json`. For each pillar, draft a one-line description in their language, read it back, and let them confirm or fix it before you write:
> "Your first pillar is 'Owner Financing.' I'd describe it as: 'Buying and selling businesses using seller-held notes instead of bank loans.' Does that capture it, or want to tweak the wording?"

Then write `wiki/concepts/<Pillar>.md` with short frontmatter and the confirmed line:

```markdown
---
title: Owner Financing
type: concept
tags: []
---

Buying and selling businesses using seller-held notes instead of bank loans.
```

Use the pillar's real name for both the `title` and the filename. Repeat for every pillar. Don't invent pillars they didn't name.

## 5. Create their brand entity

Read `interview.profile` and write one note for their business in `wiki/entities/`. Capture the name, what it does, and who it's for:

```markdown
---
title: <Business Name>
type: entity
tags: []
---

**What it does:** <one line from their profile>
**Audience:** <who it's for>
```

Keep it to what they actually told you, don't add positioning or claims they didn't say.

## 6. Make sure Obsidian is installed

This is the moment Obsidian is actually needed, so confirm it's really here before you rely on it, even though Phase 0 should have installed it. Check both locations:

```
ls -d /Applications/Obsidian.app "$HOME/Applications/Obsidian.app" 2>/dev/null
```

If neither path exists, Obsidian isn't installed yet (the Phase 0 install may have been skipped or failed). Install it now, with consent, before going further:

- **Preferred:** `brew install --cask obsidian`
- **If that fails or Homebrew isn't available:** point them to the direct download and wait for them:
  > "Obsidian is the free app your brain lives in. Grab it from https://obsidian.md, open the download, drag Obsidian to your Applications folder, then tell me and I'll open your vault for you."

Do not move on until Obsidian is present.

## 7. Open the vault

Show them the result. Try:

```
open -a Obsidian "<vault_path>"
```

If Obsidian opens but doesn't show the vault, tell them how to point it there themselves: open Obsidian, choose "Open folder as vault," and pick the folder at `<vault_path>`. Once it's open, confirm it with them and walk their eyes to the `wiki/` folders in the left sidebar, especially `concepts/`, where their pillars now sit, and `sources/`, which fills up next.

## When this phase is done

1. Update `state.json`: set `phases.vault_setup` to
   `{ "done": true, "at": "<ISO timestamp now>", "notes": "<short summary, e.g. 'vault scaffolded; 5 pillars + brand entity seeded'>" }`.
2. Load `references/04-ingest.md` and begin Phase 4.
