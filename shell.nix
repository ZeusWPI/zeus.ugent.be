let
  build-deps = import ./packages.nix;
  rev = "759537f06e6999e141588ff1c9be7f3a5c060106";
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  pkgs = import nixpkgs {};
in
pkgs.mkShell {
  nativeBuildInputs = build-deps;
  shellHook = ''
    export LANG=en_US.UTF-8
  '';
}
