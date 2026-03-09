#!/bin/sh
# Update index.md files in subfolders with lists of other files (in the same subfolder)

for dir in md/*/; do
  if [ -d "$dir" ]; then
    index_file="${dir}index.md"
    
    if [ -f "$index_file" ]; then
      dirname=$(basename "$dir")
      echo "Updating: $index_file"
      title=$(grep -m 1 '^#' "$index_file")
      new_content="$title

"
      
      # Add list of other files in the directory
      for file in "$dir"*.md; do
        if [ -f "$file" ]; then
          filename=$(basename "$file" .md)
          if [ "$filename" != "index" ]; then
            # Try to find the title (as markdown #) in the content
            file_title=$(grep -m 1 '^# ' "$file" | sed 's/^# //')
            
            # If still no title, use filename
            if [ -z "$file_title" ]; then
              file_title="$filename"
            fi
            
            # Try to extract date
            file_date=$(grep -m 1 '^date:' "$file" | sed 's/^date: *//')
            if [ -z "$file_date" ]; then
              file_date=$(grep -m 1 '^\*\*Date:\*\*' "$file" | sed 's/^\*\*Date:\*\* *//')
            fi
            
            # Build the list item
            if [ -n "$file_date" ]; then
              new_content="${new_content}- [$file_title](/$dirname/$filename/) ($file_date)
"
            else
              new_content="${new_content}- [$file_title](/$dirname/$filename/)
"
            fi
          fi
        fi
      done
      
      echo "$new_content" > "$index_file"
      echo "  Updated with file list"
    fi
  fi
done