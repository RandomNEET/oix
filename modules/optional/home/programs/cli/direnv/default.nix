{ lib, meta, ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    silent = true;
  }
  // lib.optionalAttrs (meta.channel == "unstable") {
    enableGitIntegration = true;
  };
}
