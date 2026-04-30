#!/usr/bin/env bash
#
# encode_videos.sh — Convert raw demo videos into web-friendly looping mp4s
# and extract a poster frame for each.
#
# Usage:
#   bash scripts/encode_videos.sh [INPUT_DIR]
#
# Defaults INPUT_DIR to ./raw_videos
# Outputs to ./static/videos/  and  ./static/images/<name>.png
#
# Optional env vars:
#   DURATION=8   max length in seconds (default 8)
#   WIDTH=720    target width in px (default 720, height auto)
#   CRF=24       libx264 quality, 18=best 28=worst (default 24)

set -euo pipefail

SRC="${1:-./raw_videos}"
DST_VID="./static/videos"
DST_IMG="./static/images"
DURATION="${DURATION:-8}"
WIDTH="${WIDTH:-720}"
CRF="${CRF:-24}"

if ! command -v ffmpeg >/dev/null; then
  echo "ffmpeg not found."
  echo "  macOS:  brew install ffmpeg"
  echo "  Linux:  sudo apt install ffmpeg"
  exit 1
fi

if [ ! -d "$SRC" ]; then
  echo "Input folder '$SRC' does not exist."
  echo "Create it and drop your raw .mov / .mp4 / .avi videos in, then re-run."
  exit 1
fi

mkdir -p "$DST_VID" "$DST_IMG"
shopt -s nullglob nocaseglob

count=0
for f in "$SRC"/*.{mov,mp4,avi,m4v,mkv}; do
  base=$(basename "$f")
  name="${base%.*}"
  out="$DST_VID/${name}.mp4"
  poster="$DST_IMG/${name}.png"

  echo "→ $base"
  echo "  → $out"
  ffmpeg -y -hide_banner -loglevel warning \
    -i "$f" \
    -t "$DURATION" \
    -vf "scale=${WIDTH}:-2" \
    -c:v libx264 -crf "$CRF" -preset slow \
    -an \
    -movflags +faststart \
    "$out"

  echo "  → $poster"
  ffmpeg -y -hide_banner -loglevel warning \
    -i "$out" -vframes 1 -q:v 2 "$poster"

  count=$((count + 1))
done

if [ "$count" -eq 0 ]; then
  echo "No video files found in '$SRC' (looked for .mov .mp4 .avi .m4v .mkv)."
  exit 1
fi

echo
echo "Done. Encoded $count video(s)."
echo "  Videos:  $DST_VID/"
echo "  Posters: $DST_IMG/"
