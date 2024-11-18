let
  build-deps = import ./packages.nix;
  rev = "5e4fbfb6b3de1aa2872b76d49fafc942626e2add";
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  pkgs = import nixpkgs {};
in
pkgs.mkShell {
  nativeBuildInputs = build-deps;
  shellHook = ''
    export LANG=en_US.UTF-8
  '';
}
