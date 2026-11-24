{ lib, ... }:
let
  inherit (lib) mkOption mkEnableOption types;
in
{
  options.programs.firejail = {
    enable = mkEnableOption "firejail, a sandboxing tool for Linux";
    wrappedBinaries = mkOption {
      type = types.attrsOf (
        types.either types.path (
          types.submodule {
            options = {
              enable = mkOption {
                type = types.bool;
                default = true;
                description = "Whether to enable the Firejail wrapper for this binary.";
              };
              executable = mkOption {
                type = types.path;
                description = "Executable to run sandboxed.";
              };
              profile = mkOption {
                type = types.nullOr types.path;
                default = null;
                description = "Profile to use.";
              };
              desktop = mkOption {
                type = types.nullOr types.path;
                default = null;
                description = ".desktop file to modify. Only necessary if it uses the absolute path to the executable.";
              };
              extraArgs = mkOption {
                type = types.listOf types.str;
                default = [ ];
                description = "Extra arguments to pass to firejail.";
              };
              filterStderr = {
                enable = mkEnableOption "filtering of known Firejail warning lines from standard error";
                patterns = mkOption {
                  type = types.listOf types.str;
                  default = [
                    "Error: dumpable process"
                    "Remove read permission on fseccomp executable"
                    "Warning: /usr/bin/bwrap was not disabled"
                  ];
                  description = "List of exact standard error lines to suppress using `grep -F -x -v`.";
                };
              };
            };
          }
        )
      );
      default = { };
      description = ''
        Wrap the binaries in firejail and place them in the user profile path.
      '';
    };
  };
}
