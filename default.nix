let
  rev = "70904d4a9927a4d6e05c72c4aaac4370e05107f3";
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  pkgs = import nixpkgs {};
in with pkgs;
stdenv.mkDerivation {
  name = "zeus.ugent.be";

  # the src can also be a local folder, like:
  src = ./.;

  buildInputs = (import ./packages.nix);
  buildPhase = ''
    export LANG=en_US.UTF-8
    nanoc --env=prod
  '';

  checkPhase = ''
    nanoc --env=prod check --deploy
  '';
  doCheck = true;

  installPhase = ''
    cp -r output $out
  '';
}
