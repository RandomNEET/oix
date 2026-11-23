{ pkgs, meta, ... }:
{
  imports = [
    ../../../../modules/base/home/default-programs
    ../../../../modules/base/home/programs/bat
    ../../../../modules/base/home/programs/eza
    ../../../../modules/base/home/programs/fd
    ../../../../modules/base/home/programs/fzf
    ../../../../modules/base/home/programs/git
    ../../../../modules/base/home/programs/jq
    ../../../../modules/base/home/programs/lazygit
    ../../../../modules/base/home/programs/ripgrep
    ../../../../modules/base/home/programs/starship
    ../../../../modules/base/home/programs/tmux
    ../../../../modules/base/home/programs/zoxide
    ../../../../modules/base/home/programs/zsh

    ../../../../modules/optional/home/programs/cli/antigravity-cli
    ../../../../modules/optional/home/programs/cli/codex
    ../../../../modules/optional/home/programs/cli/delta
    ../../../../modules/optional/home/programs/cli/devenv
    ../../../../modules/optional/home/programs/cli/direnv
    ../../../../modules/optional/home/programs/cli/gh
    ../../../../modules/optional/home/programs/cli/glow
    ../../../../modules/optional/home/programs/cli/mcp
    ../../../../modules/optional/home/programs/cli/opencode
    ../../../../modules/optional/home/programs/cli/pi-coding-agent
  ];

  defaultPrograms = {
    editor = {
      default = "nvim";
      helix.enable = true;
    };
    fileManager = {
      default = "yazi";
    };
  };
  programs = {
    home-manager.enable = true;
  };
  home = {
    packages = with pkgs; [ deepseek-harness ];
    preferXdgDirectories = true;
    username = "howl";
    homeDirectory = "/home/howl";
    stateVersion = meta.stateVersion;
  };
  xdg = {
    enable = true;
  };
}
