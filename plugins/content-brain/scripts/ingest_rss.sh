#!/usr/bin/env bash
# ingest_rss.sh <feed-url> <dest-dir>
# Pulls a podcast / newsletter RSS or Atom feed. Saves the raw feed and lists
# every item link + audio enclosure so Claude can turn them into notes and,
# for podcasts, hand the audio URLs to transcribe.sh.
#
#   <feed-url>  an RSS/Atom URL (podcast host, Substack, Beehiiv, Apple Podcasts)
#   <dest-dir>  usually <vault>/wiki/sources/podcast  or  .../articles
set -eu

FEED="${1:-}"
DEST="${2:-}"
if [ -z "$FEED" ] || [ -z "$DEST" ]; then
  echo "usage: ingest_rss.sh <feed-url> <dest-dir>" >&2
  exit 1
fi

mkdir -p "$DEST"
RAW="$DEST/feed.xml"

echo "Fetching feed: $FEED"
curl -fsSL --retry 3 -A "content-brain/0.1" "$FEED" -o "$RAW"
echo "Saved raw feed: $RAW"
echo ""

# Surface the useful bits for Claude. These greps are best-effort hints, not a
# parser — Claude reads feed.xml for the authoritative structure.
echo "== item links =="
grep -oE '<link[^>]*>[^<]+</link>|<link[^>]*href="[^"]+"' "$RAW" | \
  grep -oE 'https?://[^"<]+' | sort -u | head -500

echo ""
echo "== audio enclosures =="
grep -oE '<enclosure[^>]*url="[^"]+"' "$RAW" | \
  grep -oE 'https?://[^"]+' | sort -u | head -500

echo ""
echo "RSS_DONE	$RAW"
