{ pkgs }:
let
  dreamsofcode-io-catppuccin-tmux = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "catppuccin";
    version = "unstable-2023-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "dreamsofcode-io";
      repo = "catppuccin-tmux";
      rev = "b4e0715356f820fc72ea8e8baf34f0f60e891718";
      sha256 = "sha256-FJHM6LJkiAwxaLd5pnAoF3a7AE1ZqHWoCpUJE0ncCA8=";
    };
  };
in
{
  plugins = [ dreamsofcode-io-catppuccin-tmux ];
  extraConfig = ''
    set -g @catppuccin_flavour 'mocha'
  '';
}
