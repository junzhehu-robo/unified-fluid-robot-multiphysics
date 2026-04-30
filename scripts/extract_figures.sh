#!/usr/bin/env bash
#
# extract_figures.sh — Convert paper PDF figures to PNG for the project page.
#
# Usage:
#   bash scripts/extract_figures.sh [INPUT_DIR]
#
# Defaults INPUT_DIR to ./paper_figures
# Output PNGs land in ./static/images/
#
# Optional env var:
#   DPI=300   resolution (default 300, suitable for retina displays)

set -euo pipefail

SRC="${1:-./paper_figures}"
DST="./static/images"
DPI="${DPI:-300}"

if ! command -v pdftoppm >/dev/null; then
  echo "pdftoppm not found."
  echo "  macOS:  brew install poppler"
  echo "  Linux:  sudo apt install poppler-utils"
  exit 1
fi

if [ ! -d "$SRC" ]; then
  echo "Input folder '$SRC' does not exist."
  echo "Create it and drop your paper PDF figures in, then re-run."
  exit 1
fi

mkdir -p "$DST"
shopt -s nullglob nocaseglob

count=0
for f in "$SRC"/*.pdf; do
  base=$(basename "$f" .pdf)
  base_lc=$(echo "$base" | tr '[:upper:]' '[:lower:]')
  out="$DST/${base_lc}.png"
  tmp="$DST/${base_lc}_tmp"

  echo "→ $base.pdf  →  $out"
  pdftoppm -r "$DPI" -png "$f" "$tmp"

  # pdftoppm appends -1 (or -01 etc.) for single page outputs
  if   [ -f "${tmp}-1.png"  ]; then mv "${tmp}-1.png"  "$out"
  elif [ -f "${tmp}-01.png" ]; then mv "${tmp}-01.png" "$out"
  else
    # Multi-page PDF — keep all pages with -1, -2, ...
    for p in ${tmp}-*.png; do
      newname="${p/_tmp-/-page}"
      mv "$p" "$newname"
    done
  fi

  count=$((count + 1))
done

if [ "$count" -eq 0 ]; then
  echo "No PDFs found in '$SRC'."
  exit 1
fi

echo
echo "Done. Converted $count PDF(s) into $DST/"
echo
echo "Hint: rename outputs to match what index.html expects, e.g.:"
echo "    figure3_physics_comparison.png  →  method_overview.png"
echo "    figure7_hardware_setup.png      →  hardware_setup.png"
echo "    figure8_*_error_comparison.png  →  rmse_bars.png   (you may want to combine the 3 in image editor)"
echo "    figure9_eel_forward_swimming_timepoints.png → undulation_timeline.png"
echo "    figure11_optimal_head_xy_trajectory.png      → cstart_trajectories.png"
