#!/bin/sh
# Code is adapted from Ilo Mimuki: https://codeberg.org/mimuki/pages/src/branch/main/scripts/generate_html.sh

if [[ $PWD != *github.io* ]] ; then
  echo You\'re in $PWD, that seems wrong. Exiting.
  exit
fi

if [[ $1 != *.md ]] ; then
  echo You\'re trying to generate HTML from $1, that seems wrong.	Exiting.
  exit
fi

file=$(basename $1)
file=${file%\.md}

parent=$(dirname $1)
depth=$(echo "$parent" | tr -cd '/' | wc -c)
base_depth=1
extra_depth=$((depth - base_depth))
parentHref=""

for i in $(seq 1 $extra_depth); do
  parentHref="${parentHref}../"
done

[ -z "$parentHref" ] && parentHref="./"

echo "file:        " $file
echo "parent:      " $parent


if [[ $file == "index" ]]; then
  file="${parent##*/}"
  if [[ $parent == "./md" ]] || [[ $parent == "md" ]]; then
    output="index.html"
  else
    output="${parent#./md/}"/index.html
  fi
  
  if [[ $parent == "md" ]]; then
    # it's the site index, which is special
    parentHref="./sitemap/"
  fi
else
  if [[ $parent == "./md" ]] || [[ $parent == "md" ]]; then
    # Files directly in md/ go to root
    output="$file"/index.html
  else
    output="${parent#./md/}"/"$file"/index.html
  fi
	
  if [[ $parent == "./md" ]] || [[ $parent == "md" ]]; then
    parentHref="./"  # Changed from "../"
  fi
fi

pandoc --verbose --from markdown-implicit_figures-smart --wrap=preserve \
	-V "date:$(date '+%Y-%m-%d')" \
	-V "file_date:$(stat -f %Sm -t '%B %-d, %Y' $1)" \
	--template default $1 --css /style.css -o $PWD/$output

echo "output to $PWD/$output"

# Sign the thing that makes lots of bold statements about who I am (comment from ilo Mimuki, but I may keep it as it is)
if [[ $1 == *keys* || $PWD == *keys* ]] ; then
  gpg --detach-sig --armor --yes $PWD/$output
  gpg --verify $PWD/$output.asc $PWD/$output
  echo ""
fi


