#!/bin/sh

# Note: Pay attention to markdown nested folders

# List files in md/ root (excluding special files)
for file in md/*.md; do
  [ -f "$file" ] || continue
  filename=$(basename "$file" .md)
  [[ $filename == "index" || $filename == "sitemap" ]] && continue
  echo "- [$filename](/$filename/)"
done

# Top-level subdirectories only (depth 1), each as a fresh top-level item
find md -mindepth 1 -maxdepth 1 -type d | sort | while read dir; do
  dirname=$(basename "$dir")
  [[ $dirname == "temp" || $dirname == "." ]] && continue

  echo "- [$dirname](/$dirname/)"

  # Files directly in this dir
  for file in "$dir"/*.md; do
    [ -f "$file" ] || continue
    filename=$(basename "$file" .md)
    [[ $filename == "index" ]] && continue
    echo "  - [$filename](/$dirname/$filename/)"
  done

  # Nested subdirectories
  find "$dir" -mindepth 1 -type d | sort | while read subdir; do
    subdirname=$(basename "$subdir")
    rel="${subdir#md/}"
    depth=$(echo "$rel" | tr -cd '/' | wc -c)
    indent=$(printf '%0.s  ' $(seq 0 $((depth - 1))))
    urlpath="/${rel}/"
    echo "${indent}- [$subdirname]($urlpath)"

    for file in "$subdir"/*.md; do
      [ -f "$file" ] || continue
      filename=$(basename "$file" .md)
      [[ $filename == "index" ]] && continue
      echo "${indent}  - [$filename](${urlpath}${filename}/)"
    done
  done
done