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
        # TEMPFIX: Unstable Fetch MCP uses APIs removed in MCP SDK 2.
        # Switch back to pkgs.mcp-server-fetch once fixed upstream.
        command = getExe pkgs.stable.mcp-server-fetch;
      };
      git = {
        # TEMPFIX: Unstable requires MCP SDK <2 but receives SDK 2.
        # Switch back to pkgs.mcp-server-git once fixed upstream.
        command = getExe pkgs.stable.mcp-server-git;
      };
      nixos = {
        # TEMPFIX: Unstable FastMCP is incompatible with MCP SDK 2.
        # Switch back to pkgs.mcp-nixos once fixed upstream.
        command = getExe pkgs.stable.mcp-nixos;
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
