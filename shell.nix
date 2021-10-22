let
  build-deps = import ./packages.nix;
  rev = "70904d4a9927a4d6e05c72c4aaac4370e05107f3";
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  pkgs = import nixpkgs {};
in
pkgs.mkShell {
  nativeBuildInputs = build-deps;
  shellHook = ''
    export LANG=en_US.UTF-8
  '';
}
