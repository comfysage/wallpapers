#!/usr/bin/env bash

# NOTE: this script should be run from the wallpapers root directory.

generate_file() {
	echo "# $1"
	fd -I '.*\.(jpg|jpeg|png)' -t f | while read -r filename; do
		printf '\n![%s](./%s)\n' "$filename" "$filename"
	done
}

printf "# wallpapers\n\n" >README.md
cat desc.md >>README.md

find . -mindepth 1 -maxdepth 1 -type d -not -name '.*' | while read -r dir; do
	item="${dir#./}"
	item="${item%/}"
	printf '\n[%s](./%s/README.md)\n' "$item" "$item" >>README.md
	(cd "$item" && generate_file "$item" >README.md)
done
