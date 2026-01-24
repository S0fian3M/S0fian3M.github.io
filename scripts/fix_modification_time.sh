#!/bin/sh

for file in $(git ls-tree -r -t --full-name --name-only HEAD)
do
  touch -t $(git log --pretty=format:%cd --date=format:%Y%m%d%H%m.%S -1 HEAD -- "$file") "$file"
done

