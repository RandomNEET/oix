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

              # This filter suppresses known warnings
              grepPatterns = lib.concatMapStrings (p: " -e ${lib.escapeShellArg p}") opts.filterStderr.patterns;
              stderrFilter =
                if opts.filterStderr.enable && (opts.filterStderr.patterns != [ ]) then
                  "2> >(${pkgs.gnugrep}/bin/grep -v ${grepPatterns} >&2)"
                else
                  "";
            in
            ''
              cat <<_EOF >$out/bin/${command}
              #! ${pkgs.bash}/bin/bash -e
              exec /run/wrappers/bin/firejail ${args} -- ${toString opts.executable} "\$@" ${stderrFilter}
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
                  description = "Whether to enable this specific binary wrapper. Useful for conditional sandboxing.";
                };
                executable = mkOption {
                  type = types.path;
                  description = "The absolute path to the executable to be sandboxed.";
                };
                profile = mkOption {
                  type = types.nullOr types.path;
                  default = null;
                  description = "The firejail profile to use for this application.";
                };
                desktop = mkOption {
                  type = types.nullOr types.path;
                  default = null;
                  description = "The .desktop file to modify. The module will replace the absolute path to the executable with the firejail wrapper path.";
                };
                extraArgs = mkOption {
                  type = types.listOf types.str;
                  default = [ ];
                  description = "Extra command-line arguments to pass to firejail.";
                };
                filterStderr = {
                  enable = mkEnableOption "stderr filtering for this binary";
                  patterns = mkOption {
                    type = types.listOf types.str;
                    default = [
                      "dumpable"
                      "fseccomp"
                    ];
                    description = "List of patterns (strings) to filter out from stderr using grep -v.";
                  };
                };
              };
            }
          )
        );
        default = { };
        description = "Attribute set of binaries to wrap with firejail and add to the user profile.";
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
