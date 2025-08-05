#!/usr/bin/env bash

set -e

# -- utils --

msg() {
  printf "\033[32;1m%s\033[m %s\n" "$PROMPT" "$*"
}

ok() {
  >&2 printf "\033[34;1m%s \033[mok: %s\n" "$PROMPT" "$*"
}

warn() {
  >&2 printf "\033[33;1m%s \033[mwarning: %s\n" "$PROMPT" "$*"
}

die() {
  >&2 printf "\033[31;1m%s \033[merror: %s\n" "$PROMPT" "$*"
  exit 1
}

confirm() {
  >&2 printf "\033[33;1m%s \033[mconfirm? %s" "$PROMPT" "$CONFIRM_PROMPT"
  read -n 1 -r ans
  [[ ! "$ans" =~ ^[Yy]$ ]] && {
    >&2 printf '%s\n' 'Exiting.'
      exit 1
    }
  echo
}

ask() {
  >&2 printf "\033[33;1m%s \033[(y/N) %s" "$PROMPT" "$CONFIRM_PROMPT"
  read -n 1 -r ans
  echo
  [[ ! "$ans" =~ ^[Yy]$ ]] && {
    return 1
  }
}

has() {
  if ! command -v "$1" &>/dev/null; then
    return 1
  fi
}

## -- main --

[[ -z "$1" ]] && {
  die "no path provided"
}

p="$( realpath "$1" )"

_simplify_file() {
  item="$(realpath "$1")"
  [[ -f "$item" ]] || return 1
  dir="$(dirname "$item")"
  basename=$(basename -- "$item")
  extension="${basename##*.}"
  filename="${basename%.*}"

  newname="$(rhash -H "$item" | cut -d ' ' -f1)"

  [[ "$newname" == "$filename" ]] && {
    ok "skipping, name already set to hash ($filename)"
    return 0
  }

  newf="$dir/${newname}.${extension}"
  [[ -f "$newf" ]] && {
    warn "(conflict) file exists ($filename): $newname"
    return 1
  }

  ok "$item -> $newf"
  mv "$item" "$newf"
}

_simplify_dir() {
  dir="$1"
  [[ -d "$dir" ]] || exit 1
  msg "simplifying files in '$dir'"

  for item in "$dir"/*; do
    _simplify_file "$item"
  done
}

has rhash || die "rhash could not be found"

[[ -d "$p" ]] && { _simplify_dir "$p" && exit 0 || exit 1; }
[[ -f "$p" ]] && { _simplify_file "$p" && exit 0 || exit 1; }

die "path not found"
