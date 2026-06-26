#!/usr/bin/env bash
# pdf_to_png.sh — convert a vector figure (PDF/EPS) to a complete, high-res PNG.
#
# Usage:
#   ./pdf_to_png.sh <input.pdf> <output.png> [max-width-px]
# Example:
#   ./pdf_to_png.sh tex/figures/teaser.pdf html/images/teaser.png 1400
#
# Why this exists:
#   `sips -s format png foo.pdf` CROPS/CLIPS vector PDFs (often the left edge),
#   producing a figure that looks complete but is silently cut off.
#   This script renders the WHOLE figure, trying tools in order of reliability:
#     1) qlmanage  (macOS Quick Look — renders the full bounding box)
#     2) pdftoppm  (poppler, if installed)
#     3) magick/convert (ImageMagick, if installed)
#     4) sips      (last resort — may crop; a warning is printed)
#
# IMPORTANT: after conversion, open the PNG and verify nothing is cut off
# (titles, left/right columns, edges).

set -euo pipefail

IN="${1:?need input PDF/EPS path}"
OUT="${2:?need output PNG path}"
MAXW="${3:-1400}"

[ -f "$IN" ] || { echo "input not found: $IN" >&2; exit 1; }
mkdir -p "$(dirname "$OUT")"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

made=""

# 1) qlmanage (macOS) — renders the full figure, no crop
if command -v qlmanage >/dev/null 2>&1; then
  # render large, then downscale to MAXW; -s sets the max dimension
  if qlmanage -t -s "$((MAXW*2))" -o "$TMP" "$IN" >/dev/null 2>&1 \
     && [ -f "$TMP/$(basename "$IN").png" ]; then
    cp "$TMP/$(basename "$IN").png" "$OUT"
    made="qlmanage"
  fi
fi

# 2) pdftoppm (poppler)
if [ -z "$made" ] && command -v pdftoppm >/dev/null 2>&1; then
  pdftoppm -png -r 200 -singlefile "$IN" "$TMP/out" >/dev/null 2>&1 \
    && cp "$TMP/out.png" "$OUT" && made="pdftoppm"
fi

# 3) ImageMagick
if [ -z "$made" ]; then
  for mg in magick convert; do
    if command -v "$mg" >/dev/null 2>&1; then
      "$mg" -density 200 "$IN" -background white -flatten "$OUT" >/dev/null 2>&1 \
        && made="$mg" && break
    fi
  done
fi

# 4) sips (last resort — may crop)
if [ -z "$made" ] && command -v sips >/dev/null 2>&1; then
  sips -s format png "$IN" --out "$OUT" >/dev/null 2>&1 && made="sips(⚠ may crop)"
fi

[ -n "$made" ] || { echo "no converter available (need qlmanage/pdftoppm/magick/sips)" >&2; exit 1; }

# Downscale to MAXW if wider (keeps aspect ratio, never upscales beyond source)
if command -v sips >/dev/null 2>&1; then
  W=$(sips -g pixelWidth "$OUT" 2>/dev/null | awk '/pixelWidth/{print $2}')
  if [ -n "${W:-}" ] && [ "$W" -gt "$MAXW" ]; then
    sips -Z "$MAXW" "$OUT" >/dev/null 2>&1 || true
  fi
fi

DIM=$(sips -g pixelWidth -g pixelHeight "$OUT" 2>/dev/null | awk '/pixel/{printf "%s ", $2}')
echo "✓ $OUT  (${DIM}px, via $made)"
[ "${made#sips}" != "$made" ] && echo "  ⚠ used sips — OPEN the PNG and check the figure isn't cropped."
echo "  → Always verify the PNG shows the complete figure before using it."
