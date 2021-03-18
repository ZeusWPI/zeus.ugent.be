let
  pkgs = import <nixpkgs> {};
in with pkgs; mkShell {
  nativeBuildInputs = [
    ruby bundler libxml2 nodejs yarn cacert git glibcLocales
  ];
  shellHook = ''
    export LANG=en_US.UTF-8
  '';
}
