with import <nixpkgs> {};

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
