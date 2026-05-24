{
  lib,
  pkgs,
  meta,
  ...
}:
{
  programs.nixvim = {
    plugins.lint = {
      enable = true;
      lintersByFt = {
        nix = [ "nix" ];
        sh = [ "shellcheck" ];
        lua = [ "luacheck" ];
        python = [ "ruff" ];
        c = [ "clangtidy" ];
        cpp = [ "clangtidy" ];
        json = [ "jsonlint" ];
        yaml = [ "yamllint" ];
        markdownlint = [ "markdownlint" ];
        gitcommit = [ "commitlint" ];
      };
    }
    // lib.optionalAttrs (meta.channel == "unstable") {
      lazyLoad = {
        enable = true;
        settings = {
          event = [
            "BufReadPost"
            "BufNewFile"
            "BufWritePre"
          ];
        };
      };
    };
    extraPackages = with pkgs; [
      shellcheck
      luajitPackages.luacheck # luacheck
      ruff
      python314Packages.demjson3 # jsonlint
      yamllint
      markdownlint-cli
      commitlint
    ];
  };
}
