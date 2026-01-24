#!/bin/sh
# Generate HTML for all markdown files
# I added this script as I'm starting from scratch

#./scripts/fix_modification_time.sh
./scripts/update_indexes.sh
./scripts/list.sh > md/sitemap.md

for mdfile in ./md/*.md; do
  if [ -f "$mdfile" ]; then
    echo "Processing: $mdfile"
    ./scripts/generate_html.sh "$mdfile"
    echo "---"
  fi
done

for mdfile in ./md/**/*.md; do
  if [ -f "$mdfile" ]; then
    echo "Processing: $mdfile"
    ./scripts/generate_html.sh "$mdfile"
    echo "---"
  fi
done