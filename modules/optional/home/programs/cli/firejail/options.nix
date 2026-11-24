{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    types
    mkMerge
    mkIf
    mkForce
    ;

  cfg = config.programs.firejail;

  enabledBinaries = lib.filterAttrs (
    name: value: if builtins.isAttrs value then value.enable else true
  ) cfg.wrappedBinaries;

  wrappedBins =
    pkgs.runCommand "hm-firejail-wrapped-binaries"
      {
        preferLocalBuild = true;
        allowSubstitutes = false;
        meta.priority = -1;
      }
      ''
        mkdir -p $out/bin
        mkdir -p $out/share/applications

        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (
            command: value:
            let
              opts =
                if builtins.isAttrs value then
                  value
                else
                  {
                    enable = true;
                    executable = value;
                    profile = null;
                    desktop = null;
                    extraArgs = [ ];
                    filterStderr = {
                      enable = false;
                      patterns = [ ];
                    };
                  };

              args = lib.escapeShellArgs (
                opts.extraArgs ++ (lib.optional (opts.profile != null) "--profile=${toString opts.profile}")
              );

              # Suppress only complete, known Firejail warning lines
              grepPatterns = lib.concatMapStrings (p: " -e ${lib.escapeShellArg p}") opts.filterStderr.patterns;
              stderrFilter =
                if opts.filterStderr.enable && (opts.filterStderr.patterns != [ ]) then
                  "2> >(${pkgs.gnugrep}/bin/grep -F -x -v ${grepPatterns} >&2)"
                else
                  "";
            in
            ''
              cat <<_EOF >$out/bin/${command}
              #! ${pkgs.bash}/bin/bash -e
              exec firejail ${args} -- ${toString opts.executable} "\$@" ${stderrFilter}
              _EOF
              chmod 0755 $out/bin/${command}
              ${lib.optionalString (opts.desktop != null) ''
                if [ -f "${opts.desktop}" ]; then
                  substitute "${opts.desktop}" "$out/share/applications/$(basename ${opts.desktop})" \
                    --replace "${opts.executable}" "$out/bin/${command}"
                fi
              ''}
            ''
          ) enabledBinaries
        )}
      '';
in
{
  options = {
    programs.firejail = {
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
  };

  config = mkMerge [
    { programs.firejail.enable = mkForce osConfig.programs.firejail.enable; }
    (mkIf cfg.enable {
      home.packages = [ wrappedBins ];
    })
  ];
}
