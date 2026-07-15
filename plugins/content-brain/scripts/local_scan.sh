#!/usr/bin/env bash
# local_scan.sh <root-dir> — find candidate content files under a directory.
# LISTS ONLY. Copies nothing, moves nothing, touches nothing. The person must
# see and approve what was found before anything is ingested.
#
#   <root-dir>  a folder the person has explicitly pointed at (e.g. ~/Documents,
#               ~/Movies, a Dropbox folder). Never scan without their consent.
set -eu

ROOT="${1:-}"
if [ -z "$ROOT" ]; then
  echo "usage: local_scan.sh <root-dir>" >&2
  exit 1
fi
[ -d "$ROOT" ] || { echo "not a directory: $ROOT" >&2; exit 1; }

echo "Scanning (read-only): $ROOT"
echo ""

scan_group() {
  label="$1"; shift
  printf '== %s ==\n' "$label"
  # Build a find expression from the passed extensions.
  first=1
  set -- "$@"
  {
    find "$ROOT" -type f \( "$@" \) \
      ! -path '*/.*/*' ! -path '*/node_modules/*' ! -path '*/Library/*' \
      -print0 2>/dev/null
  } | while IFS= read -r -d '' f; do
    sz=$(stat -f '%z' "$f" 2>/dev/null || echo 0)
    printf '%10s  %s\n' "$sz" "$f"
  done | sort -rn | head -300
  echo ""
}

scan_group "Documents (writing)"  -iname '*.pdf' -o -iname '*.docx' -o -iname '*.doc' -o -iname '*.md' -o -iname '*.txt' -o -iname '*.rtf' -o -iname '*.pages'
scan_group "Books / ebooks"       -iname '*.epub' -o -iname '*.mobi' -o -iname '*.azw3'
scan_group "Video"                -iname '*.mp4' -o -iname '*.mov' -o -iname '*.m4v' -o -iname '*.mkv' -o -iname '*.webm' -o -iname '*.avi'
scan_group "Audio"                -iname '*.mp3' -o -iname '*.m4a' -o -iname '*.wav' -o -iname '*.aac' -o -iname '*.flac' -o -iname '*.aiff'
scan_group "Slides"               -iname '*.pptx' -o -iname '*.key'

echo "LOCAL_SCAN_DONE	$ROOT"
echo "(nothing was copied — this was a read-only list)"
