#!/usr/bin/env bash
# transcribe.sh <file-or-dir> <dest-dir> [whisper-model]
# Turns audio/video into plain-text transcripts.
#   1. If a caption file (.vtt/.srt) sits next to the media, it is converted to
#      text (free, instant) instead of re-transcribing.
#   2. Otherwise Whisper transcribes the audio.
# Writes one .txt per item into <dest-dir>. Skips items already transcribed.
#
#   [whisper-model]  tiny|base|small|medium|large  (default: small — a good
#                    speed/accuracy balance for spoken-word content)
set -u

SRC="${1:-}"
DEST="${2:-}"
MODEL="${3:-small}"
if [ -z "$SRC" ] || [ -z "$DEST" ]; then
  echo "usage: transcribe.sh <file-or-dir> <dest-dir> [whisper-model]" >&2
  exit 1
fi
mkdir -p "$DEST"

MEDIA_EXT='mp3 m4a wav aac flac ogg opus mp4 mov mkv webm avi m4v'

# caption_to_text <caption-file> <out-txt>: strip vtt/srt to plain prose.
caption_to_text() {
  # Drop cue numbers, timestamps, WEBVTT header and blank lines; collapse.
  sed -E \
    -e '/-->/d' \
    -e '/^WEBVTT/d' \
    -e '/^[0-9]+$/d' \
    -e 's/<[^>]+>//g' \
    "$1" | awk 'NF' | awk '!seen[$0]++' > "$2"
}

transcribe_one() {
  f="$1"
  base="$(basename "$f")"
  stem="${base%.*}"
  out="$DEST/$stem.txt"
  if [ -e "$out" ]; then echo "skip   $out (already done)"; return 0; fi

  dir="$(dirname "$f")"
  # Prefer an adjacent caption file.
  for cap in "$dir/$stem".vtt "$dir/$stem".srt "$dir/$stem".*.vtt "$dir/$stem".*.srt; do
    if [ -e "$cap" ]; then
      caption_to_text "$cap" "$out"
      echo "caption $out (from $(basename "$cap"))"
      return 0
    fi
  done

  # No captions — use Whisper.
  if command -v whisper >/dev/null 2>&1; then
    echo "whisper $f (model=$MODEL) ..."
    whisper "$f" --model "$MODEL" --output_format txt --output_dir "$DEST" --verbose False >/dev/null 2>&1 \
      && echo "done   $out" \
      || echo "FAILED $f (whisper error)"
  else
    echo "SKIP   $f — no captions and Whisper not installed (run preflight.sh --install)"
  fi
}

if [ -d "$SRC" ]; then
  # Walk the directory for media files.
  # shellcheck disable=SC2086
  for ext in $MEDIA_EXT; do
    find "$SRC" -type f -iname "*.$ext" 2>/dev/null
  done | sort -u | while IFS= read -r f; do
    [ -n "$f" ] && transcribe_one "$f"
  done
elif [ -e "$SRC" ]; then
  transcribe_one "$SRC"
else
  echo "not found: $SRC" >&2
  exit 1
fi

echo "TRANSCRIBE_DONE	$DEST"
