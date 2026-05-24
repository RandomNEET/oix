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
        json = [ "jq" ];
        yaml = [ "yamllint" ];
        markdownlint = [ "markdownlint" ];
        gitcommit = [ "commitlint" ];
      };
      linters = { };
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
      luajitPackages.luacheck
      ruff
      jq
      yamllint
      markdownlint-cli
      commitlint
    ];
  };
}
