{ pkgs ? import <nixpkgs> { }
, sha256 ? "0d8ks6x4a32v906p0xb5nn0hkivyi6gr6nyiq10sz1zxx8gkcl7v"
, version ? "1.43.4" }:

let
   unstable = import (builtins.fetchTarball {
      # Descriptive name to make the store path easier to identify
      name = "nixos-unstable-2021-11-02";
      # Commit hash for nixos-unstable as of 2018-09-12
      url = "https://github.com/nixos/nixpkgs/archive/1380230a378043ecd55c3d50a0bfa1f401d80efc.tar.gz";
      # Hash obtained using `nix-prefetch-url --unpack <url>`
      sha256 = "062ix9661gq7ysgs4a2wppspvxdn2wcaf0l2pfiwpg8jkl3rgfnb";
    }) {};
in with pkgs;
stdenv.mkDerivation rec {
    name = "dart-sass-${version}";
    inherit version;
    #system = "x86_64-darwin";
    
    isExecutable = true;

    src = fetchurl {
        inherit sha256;
        url = "https://github.com/sass/dart-sass/archive/${version}.tar.gz";
    };

    phases = "unpackPhase installPhase fixupPhase";

    fixupPhase = ''
        #${patchelf}/bin/patchelf \
        #    --set-interpreter ${binutils.dynamicLinker} \
        #    $out/src/dart
    '';
    
    installPhase = ''
        export HOME=$PWD
        ${unstable.dart}/bin/dart pub get
        ${unstable.dart}/bin/dart compile exe -Dversion=${version} bin/sass.dart -o sass
        cp -r . $out
        ln -s $out/sass $out/bin/sass
    '';
}
