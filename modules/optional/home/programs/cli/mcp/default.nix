{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe;
  sopsPath = "${config.xdg.configHome}/sops-nix/secrets/mcp";
in
{
  programs.mcp = {
    enable = true;
    servers = {
      fetch = {
        command = getExe pkgs.mcp-server-fetch;
      };
      git = {
        command = getExe pkgs.mcp-server-git;
      };
      nixos = {
        command = getExe pkgs.mcp-nixos;
      };
      context7 = {
        command = getExe pkgs.context7-mcp;
        env.CONTEXT7_API_KEY = {
          file = "${sopsPath}/context7";
        };
      };
      github = {
        command = getExe pkgs.github-mcp-server;
        args = [ "stdio" ];
        env.GITHUB_PERSONAL_ACCESS_TOKEN = {
          file = "${sopsPath}/github";
        };
      };
    };
  };
  sops = {
    secrets = {
      "mcp/context7".sopsFile = ./secrets.yaml;
      "mcp/github".sopsFile = ./secrets.yaml;
    };
  };
}
