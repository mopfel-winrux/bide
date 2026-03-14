#!/bin/bash
# Optimize generated assets: resize to 128x128 (or 512x128 for wide), output as PNG
# Requires: imagemagick
#
# Usage: ./scripts/optimize-assets.sh

set -e

SRC="$(dirname "$0")/../assets/generated"
DST="$(dirname "$0")/../ui/public/img"

WIDE_DIRS="area-bg dungeon-bg"

mkdir -p "$DST"

for category in "$SRC"/*/; do
  catname=$(basename "$category")
  mkdir -p "$DST/$catname"

  count=0
  for src in "$category"*.png; do
    [ -f "$src" ] || continue
    base=$(basename "$src" .png)
    out="$DST/$catname/$base.png"

    # Skip if already converted and newer than source
    if [ -f "$out" ] && [ "$out" -nt "$src" ]; then
      continue
    fi

    # Wide images get 512x128, everything else 128x128
    if echo "$WIDE_DIRS" | grep -qw "$catname"; then
      convert "$src" -resize 512x128 "$out" 2>/dev/null
    else
      convert "$src" -resize 128x128 "$out" 2>/dev/null
    fi

    count=$((count + 1))
  done

  total=$(ls "$DST/$catname"/*.png 2>/dev/null | wc -l)
  [ $count -gt 0 ] && echo "$catname: converted $count new ($total total)"
done

echo ""
echo "Output: $DST"
du -sh "$DST" 2>/dev/null
