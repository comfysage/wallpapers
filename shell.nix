{
  pkgs,
}:
pkgs.mkShellNoCC {
  packages = [
    pkgs.just
    pkgs.fd
    pkgs.fzf
    pkgs.lutgen
  ];
}
