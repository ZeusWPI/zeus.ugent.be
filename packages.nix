let
  rev = "5e4fbfb6b3de1aa2872b76d49fafc942626e2add";
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  pkgs = import nixpkgs {};
  ruby = pkgs.ruby_3_3;
  gems = pkgs.bundlerEnv {
    name = "zeus.ugent.be";
    inherit ruby;
    gemdir = ./.;
  };
in with pkgs;
  [
    gems (lowPrio gems.wrappedRuby) libxml2 nodejs cacert git glibcLocales
    pandoc (texlive.combine { inherit (texlive) scheme-basic xetex unicode-math enumitem booktabs ulem etoolbox; })
  ] ++ (if stdenv.isDarwin then [terminal-notifier] else [chromium])
