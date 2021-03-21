let
  pkgs = import <nixpkgs> {};
in with pkgs; mkShell {
  nativeBuildInputs = [
    ruby bundler libxml2 nodejs yarn cacert git glibcLocales
    pandoc (texlive.combine { inherit (texlive) scheme-basic xetex unicode-math enumitem booktabs; })
  ];
  shellHook = ''
    export LANG=en_US.UTF-8
  '';
}
