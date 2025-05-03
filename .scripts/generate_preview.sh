#!/usr/bin/env zsh

# NOTE: this script should be run from the wallpapers root directory.

nb_note="""
## N.B.

I did not create any of these wallpapers. If you are the original creator and would like for me
to remove your work, please let me know."""

generate_file() {
  echo "# $dir"
  for filename in $(fd '.*\.(jpg|jpeg|png)' -t f); do
    printf "\n![%s](./%s)\n" "$filename" "$filename"
  done
}

main() {
  echo "# wallpapers" > README.md
  echo "$nb_note" >> README.md

  for dir in $(ls -1d */); do
    item="${dir%/}"
    echo "\n[$item](./$item/README.md)\n" >> README.md
    pushd $item
    generate_file "$item" > README.md
    popd
  done
}

main $@

# useful for inspecting readme after creation e.g. $ ./generate_preview.sh vim
[ -n "$1" ] && $1 README.md

exit 0
