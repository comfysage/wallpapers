args := "-G -i 16 -m 8 -l 16"
variant := "fall"

root_dir := justfile_directory() / ".lutgen"
palette_file := root_dir / "palette" / "evergarden-" + variant
lut_file := root_dir / "lut" / "evergarden-" + variant + ".png"
out_dir := root_dir / "out" / variant

_default:
  @just --list

generate-palette:
  [[ -f "{{ palette_file }}" ]] || whiskers --flavor {{variant}} palette.tera

generate-lut: generate-palette
  [[ -f "{{ lut_file }}" ]] || lutgen generate -o {{ lut_file }} {{args}} -- $(cat {{ palette_file }})

generate +files: generate-lut
  lutgen apply --hald-clut {{ lut_file }} -d -o {{ out_dir }}/ {{files}}

generate-preview:
  cd {{ justfile_directory() }} && ./.scripts/generate_preview.sh
