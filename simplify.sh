#!/usr/bin/env bash

[[ -z "$1" ]] && exit 1

p="$( realpath "$1" )"

_simplify_file() {
  item="$1"
  [[ -f "$item" ]] || exit 1
  dir="$(dirname $item)"
    filename=$(basename -- "$item")
    extension="${filename##*.}"
    filename="${filename%.*}"

    newf="$dir/$(rhash).${extension}"
    while [[ -f "$newf" ]]; do
      newf="$dir/$(rhash).${extension}"
    done

    echo "$item -> $newf"
    mv "$item" "$newf"
}

_simplify_dir() {
  dir="$1"
  [[ -d "$dir" ]] || exit 1
  echo "simplifying pictures in '$dir'"

  for item in $dir/*; do
    _simplify_file "$item"
  done
}

[[ -d "$p" ]] && { _simplify_dir "$p"; exit 0; }
[[ -f "$p" ]] && { _simplify_file "$p"; exit 0; }

exit 1
