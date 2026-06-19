#!/bin/sh
# Update index.md files in subfolders with lists of other files (in the same subfolder)

find md -mindepth 1 -type d | while read dir; do
  index_file="${dir}/index.md"
  [ -f "$index_file" ] || continue

  dirname=$(basename "$dir")
  [[ $dirname == "temp" ]] && continue

  # Build URL path relative to site root
  urlpath="/${dir#md/}/"

  echo "Updating: $index_file"
  title=$(grep -m 1 '^#' "$index_file")
  new_content="$title
"

  for file in "$dir"/*.md; do
    [ -f "$file" ] || continue
    filename=$(basename "$file" .md)
    [ "$filename" = "index" ] && continue

    file_title=$(grep -m 1 '^# ' "$file" | sed 's/^# //')
    [ -z "$file_title" ] && file_title="$filename"

    file_date=$(grep -m 1 '^date:' "$file" | sed 's/^date: *//')
    if [ -z "$file_date" ]; then
      file_date=$(grep -m 1 '^\*\*Date:\*\*' "$file" | sed 's/^\*\*Date:\*\* *//')
    fi

    if [ -n "$file_date" ]; then
      new_content="${new_content}- [$file_title](${urlpath}${filename}/) ($file_date)
"
    else
      new_content="${new_content}- [$file_title](${urlpath}${filename}/)
"
    fi
  done

  echo "$new_content" > "$index_file"
  echo "  Updated with file list"
done