{
  inputs,
  lib,
  pkgs,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    (_: {
      imports = [
        inputs.nixvim.homeModules.nixvim
        ./core
        ./plugins
        ./themes
      ];

      programs.nixvim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        globals.mapleader = " ";
        clipboard = {
          register = "unnamedplus";
          providers = lib.optionalAttrs ((opts.desktop or "") != "") {
            wl-copy.enable = true;
            xclip.enable = true;
          };
        };

        extraPackages =
          with pkgs;
          (
            [
              fd
              ghostscript
              lsof
              lynx
              ripgrep
            ]
            ++ lib.optionals (opts.nixvim.conform.enable or true) [
              # Formatters
              astyle
              black
              isort
              nixfmt-rfc-style
              prettier
              prettierd
              rustfmt
              shfmt
              stylua
            ]
            ++ lib.optionals (opts.nixvim.lint.enable or true) [
              # Linters
              commitlint
              eslint_d
              jq
              luajitPackages.luacheck
              markdownlint-cli
              ruff
              shellcheck
              yamllint
            ]
          );
      };

      home.packages = with pkgs; [ ];
    })
  ];
}
