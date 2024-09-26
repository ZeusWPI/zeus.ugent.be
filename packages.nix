let
  rev = "759537f06e6999e141588ff1c9be7f3a5c060106";
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
    gems libxml2 nodejs yarn cacert git glibcLocales
    pandoc (texlive.combine { inherit (texlive) scheme-basic xetex unicode-math enumitem booktabs ulem; })
  ] ++ (if stdenv.isDarwin then [terminal-notifier] else [chromium])
