let
  rev = "70904d4a9927a4d6e05c72c4aaac4370e05107f3";
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  pkgs = import nixpkgs {};
  ruby = pkgs.ruby_3_0;
  gems = pkgs.bundlerEnv {
    name = "zeus.ugent.be";
    inherit ruby;
    gemdir = ./.;
  };
in with pkgs;
  [
    gems libxml2 nodejs yarn cacert git glibcLocales
    pandoc (texlive.combine { inherit (texlive) scheme-basic xetex unicode-math enumitem booktabs ulem; })
  ] ++ (if stdenv.isDarwin then [terminal-notifier] else [])
