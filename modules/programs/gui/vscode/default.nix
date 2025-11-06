{
  lib,
  pkgs,
  opts,
  ...
}:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "vscode" ];
  home-manager.sharedModules = [
    (_: {
      programs.vscode = {
        enable = true;
        package = pkgs.vscode;
        mutableExtensionsDir = true;
        profiles.default = {
          extensions = import ./extensions.nix { inherit lib pkgs opts; };
          userMcp = {
            servers = {
              Github = {
                url = "https://api.githubcopilot.com/mcp/";
              };
            };
          };
        };
      };
    })
  ];
}
