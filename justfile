set dotenv-load

args_hash := `rhash -H <(echo "$LUTARGS") | cut -d ' ' -f1`
variant := "fall"

root_dir := justfile_directory() / ".lutgen"
palette_dir := root_dir / "palette"
palette_file := palette_dir / "evergarden-" + variant
lut_dir := root_dir / "lut"
lut_file := lut_dir / "evergarden-" + variant + "-" + args_hash + ".png"
out_dir := root_dir / "out-" + args_hash / variant

_default:
  @just --list

generate-palette:
  mkdir -p {{ palette_dir }}
  [[ -f "{{ palette_file }}" ]] || whiskers --flavor {{variant}} palette.tera

generate-lut: generate-palette
  mkdir -p {{ lut_dir }}
  [[ -f "{{ lut_file }}" ]] || lutgen generate -o {{ lut_file }} $LUTARGS -- $(cat {{ palette_file }})

generate +files: generate-lut
  mkdir -p {{ out_dir }}
  lutgen apply --hald-clut {{ lut_file }} -d -o {{ out_dir }}/ {{files}}

generate-preview:
  cd {{ justfile_directory() }} && ./.scripts/generate_preview.sh
