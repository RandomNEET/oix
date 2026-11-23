{ lib, pkgs, ... }:
let
  inherit (lib) getExe;
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
    };
  };
}
