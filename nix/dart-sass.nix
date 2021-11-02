{ pkgs ? (import (builtins.fetchTarball {
      # Descriptive name to make the store path easier to identify
      name = "nixos-unstable-2021-11-02";
      # Commit hash for nixos-unstable as of 2018-09-12
      url = "https://github.com/nixos/nixpkgs/archive/1380230a378043ecd55c3d50a0bfa1f401d80efc.tar.gz";
      # Hash obtained using `nix-prefetch-url --unpack <url>`
      sha256 = "062ix9661gq7ysgs4a2wppspvxdn2wcaf0l2pfiwpg8jkl3rgfnb";
    }) {})
, sha256 ? "0d8ks6x4a32v906p0xb5nn0hkivyi6gr6nyiq10sz1zxx8gkcl7v"
, version ? "1.43.4" }:
with pkgs;
stdenv.mkDerivation {
    name = "dart-sass-${version}";
    inherit version;

    src = fetchurl {
        inherit sha256;
        url = "https://github.com/sass/dart-sass/archive/${version}.tar.gz";
    };

    buildPhase = ''
        export HOME=$PWD
        ${dart}/bin/dart pub get
        ${dart}/bin/dart compile exe -Dversion=${version} bin/sass.dart -o sass
    '';
    installPhase = ''
        cp -r . $out
        ln -s $out/sass $out/bin/sass
    '';
}
