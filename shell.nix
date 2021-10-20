with (import <nixpkgs> {});
let
  gems = pkgs.bundlerEnv {
    name = "zeus.ugent.be";
    inherit ruby;
    gemdir = ./.;
  };
in mkShell {
  nativeBuildInputs = [
    ruby_3_0 gems bundler libxml2 nodejs yarn cacert git glibcLocales
    pandoc (texlive.combine { inherit (texlive) scheme-basic xetex unicode-math enumitem booktabs ulem; })
  ] ++ (if stdenv.isDarwin then [terminal-notifier] else []);
  shellHook = ''
    export LANG=en_US.UTF-8
  '';
}
