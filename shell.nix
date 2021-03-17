let
  pkgs = import <nixpkgs> {};
in with pkgs; mkShell {
  nativeBuildInputs = [
    ruby bundler libxml2 nodejs yarn
  ];
}
