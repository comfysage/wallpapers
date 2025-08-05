{
  pkgs,
}:
pkgs.mkShellNoCC {
  packages = [
    pkgs.just
    pkgs.fd
    pkgs.rhash
    pkgs.fzf
    pkgs.lutgen
  ];
}
