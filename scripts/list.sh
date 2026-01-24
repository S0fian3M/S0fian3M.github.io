#!/bin/sh

# Note: Pay attention to markdown nested folders

# List files in md/ root (excluding special files)
for file in md/*.md; do
  if [ -f "$file" ]; then
    filename=$(basename "$file" .md)
    if [[ $filename != "index" ]] && [[ $filename != "sitemap" ]]; then
      echo "- [$filename](/$filename/)"
    fi
  fi
done

# List subdirectories in md/
for dir in md/*/; do
  if [ -d "$dir" ]; then
    dirname=$(basename "$dir")
    echo "- [$dirname](/$dirname/)"
    
    # List files within subdirectory
    for file in "$dir"*.md; do
      if [ -f "$file" ]; then
        filename=$(basename "$file" .md)
        if [[ $filename != "index" ]]; then
          echo "  - [$filename](/$dirname/$filename/)"
        fi
      fi
    done
  fi
done