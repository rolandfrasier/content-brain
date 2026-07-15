#!/usr/bin/env bash
# ingest_youtube.sh <url> <dest-dir>
# Downloads a YouTube video, playlist, or whole channel as audio + metadata +
# captions. Idempotent via a download archive. Claude turns the .info.json
# files into organized notes afterward.
#
#   <url>       a video, playlist, or channel URL (e.g. https://youtube.com/@name)
#   <dest-dir>  usually <vault>/wiki/sources/youtube
set -eu

URL="${1:-}"
DEST="${2:-}"
if [ -z "$URL" ] || [ -z "$DEST" ]; then
  echo "usage: ingest_youtube.sh <url> <dest-dir>" >&2
  exit 1
fi
command -v yt-dlp >/dev/null 2>&1 || { echo "yt-dlp not found — run preflight.sh --install first" >&2; exit 2; }

mkdir -p "$DEST"
ARCHIVE="$DEST/.yt-dlp-archive.txt"

echo "Downloading audio + captions + metadata from: $URL"
echo "Destination: $DEST"
echo "(already-downloaded items are skipped automatically)"
echo ""

yt-dlp \
  --download-archive "$ARCHIVE" \
  --ignore-errors \
  --no-overwrites \
  --extract-audio --audio-format m4a --audio-quality 0 \
  --write-info-json \
  --write-thumbnail \
  --write-subs --write-auto-subs --sub-langs "en.*" --sub-format "vtt/srt/best" \
  --restrict-filenames \
  -o "$DEST/%(uploader)s/%(upload_date>%Y-%m-%d)s - %(title).120B [%(id)s].%(ext)s" \
  "$URL"

echo ""
echo "YT_DONE	$DEST"
