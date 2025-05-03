#!/usr/bin/env bash

[[ -z "$1" ]] && exit 1

p="$( realpath "$1" )"

_simplify_file() {
  item="$(realpath "$1")"
  [[ -f "$item" ]] || exit 1
  dir="$(dirname "$item")"
  basename=$(basename -- "$item")
  extension="${basename##*.}"
  filename="${basename%.*}"

  newname="$(rhash -H "$item" | cut -d ' ' -f1)"

  [[ "$newname" == "$filename" ]] && exit 1

  newf="$dir/${newname}.${extension}"
  # while [[ -f "$newf" ]]; do
  #   newf="$dir/$(rhash).${extension}"
  # done

  echo "$item -> $newf"
  mv "$item" "$newf"
}

_simplify_dir() {
  dir="$1"
  [[ -d "$dir" ]] || exit 1
  echo "simplifying pictures in '$dir'"

  for item in "$dir"/*; do
    _simplify_file "$item"
  done
}

if ! command -v rhash 2>&1 >/dev/null
then
  echo "rhash could not be found"
  exit 1
fi

[[ -d "$p" ]] && { _simplify_dir "$p"; exit 0; }
[[ -f "$p" ]] && { _simplify_file "$p"; exit 0; }

exit 1
