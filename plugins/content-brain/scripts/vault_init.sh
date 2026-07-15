#!/usr/bin/env bash
# vault_init.sh <vault-path> — scaffold a Content Brain vault, structured like ours.
# Idempotent: creates only what's missing, never overwrites existing notes.
set -eu

VAULT="${1:-}"
if [ -z "$VAULT" ]; then
  echo "usage: vault_init.sh <vault-path>" >&2
  exit 1
fi

mkdir -p "$VAULT"
mkdir -p \
  "$VAULT/wiki/sources" \
  "$VAULT/wiki/sources/youtube" \
  "$VAULT/wiki/sources/podcast" \
  "$VAULT/wiki/sources/articles" \
  "$VAULT/wiki/sources/books" \
  "$VAULT/wiki/sources/transcripts" \
  "$VAULT/wiki/sources/assets" \
  "$VAULT/wiki/voice" \
  "$VAULT/wiki/concepts" \
  "$VAULT/wiki/entities" \
  "$VAULT/wiki/systems" \
  "$VAULT/wiki/builds" \
  "$VAULT/wiki/prompts" \
  "$VAULT/.content-brain"

# write_if_absent <path> <<'EOF' ... EOF
write_if_absent() {
  target="$1"
  if [ -e "$target" ]; then
    echo "kept   $target"
  else
    cat > "$target"
    echo "wrote  $target"
  fi
}

write_if_absent "$VAULT/Home.md" <<'EOF'
# Home

This is your content brain. Everything you have ever made lives here, organized,
searchable, and linked.

- [[index]] — the map of what's inside
- `wiki/sources/` — all your ingested content
- `wiki/voice/` — your Voice DNA
- `wiki/concepts/` — your frameworks and pillars
EOF

write_if_absent "$VAULT/index.md" <<'EOF'
# Index

A living map of your content brain. Sections fill in as content is ingested.

## Sources
_(ingested content by type)_

## Voice
- [[Brand Voice DNA]]
- [[Personal Voice DNA]]
- [[Written Voice]]
- [[Spoken Voice]]

## Concepts
_(your frameworks and pillars)_
EOF

write_if_absent "$VAULT/log.md" <<'EOF'
# Log

A running record of what was built and when.
EOF

write_if_absent "$VAULT/CLAUDE.md" <<'EOF'
# Operating notes for this vault

This is a personal content brain built with Content Brain.

- Every note is plain-text markdown. Notes link with [[wikilinks]] and carry #tags.
- `wiki/sources/` holds ingested content, one note per item, with frontmatter
  (type, source, date, tags).
- `wiki/voice/` holds the Voice DNA set. Treat it as the source of truth for
  how this person sounds.
- Never invent content, quotes, numbers, or client stories that are not already
  in this vault.
EOF

# Minimal Obsidian marker so the folder opens as a vault without extra config.
mkdir -p "$VAULT/.obsidian"
write_if_absent "$VAULT/.obsidian/app.json" <<'EOF'
{}
EOF

echo "VAULT_READY	$VAULT"
