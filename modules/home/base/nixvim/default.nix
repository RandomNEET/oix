{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./core
    ./plugins
  ];

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      fd
      ghostscript
      lsof
      lynx
      ripgrep
      # Formatters
      astyle
      black
      isort
      nixfmt
      prettier
      prettierd
      rustfmt
      shfmt
      stylua
      # Linters
      commitlint
      eslint_d
      jq
      luajitPackages.luacheck
      markdownlint-cli
      ruff
      shellcheck
      yamllint
    ];
  };
}
