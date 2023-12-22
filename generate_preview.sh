#!/usr/bin/env zsh

# NOTE: this script should be run from the wallpapers root directory.

nb_note="""
## N.B.

I did not create any of these wallpapers. If you are the original creator and would like for me
to remove your work, please let me know."""

generate_file() {
    echo "# wallpapers"
    echo "$nb_note"

    pushd vibrant
    echo "## vibrant"
    echo "These include some of my favorite wallpapers from [mut-ex's](https://github.com/mut-ex/) [collection](https://github.com/mut-ex/wallpapers)."
    for filename (*.jpg(om)); do
        printf "\n## %s\n\n![%s](vibrant/%s)\n" "$filename" "$filename" "$filename"
    done
    popd

    pushd wall
    echo "## wallpapers"
    for filename (*.*(om)); do
        printf "\n## %s\n\n![%s](wall/%s)\n" "$filename" "$filename" "$filename"
    done
    popd
}

rm README.md; generate_file >>README.md

# useful for inspecting readme after creation e.g. $ ./generate_preview.sh vim
[ -n "$1" ] && $1 README.md

exit 0
