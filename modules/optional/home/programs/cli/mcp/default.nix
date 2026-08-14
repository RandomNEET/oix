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
rec {
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
          file = sops.secrets.context7.path;
        };
      };
      github = {
        command = getExe pkgs.github-mcp-server;
        args = [ "stdio" ];
        env.GITHUB_PERSONAL_ACCESS_TOKEN = {
          file = sops.secrets.github.path;
        };
      };
    };
  };
  sops = {
    secrets = {
      context7 = {
        sopsFile = ./secrets.yaml;
        path = "${sopsPath}/context7";
      };
      github = {
        sopsFile = ./secrets.yaml;
        path = "${sopsPath}/github";
      };
    };
  };
}
