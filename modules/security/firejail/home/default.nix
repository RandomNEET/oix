# Requirements: programs.firejail.enable = true;
{
  osConfig,
  config,
  lib,
  pkgs,
  meta,
  ...
}:
let
  inherit (lib)
    getBin
    optionalAttrs
    mkMerge
    mkIf
    mkForce
    ;
  cfg = config.programs.firejail;
  profiles = import ./profiles {
    inherit
      osConfig
      config
      lib
      pkgs
      meta
      ;
  };

  enabledBinaries = lib.filterAttrs (
    _name: value: if builtins.isAttrs value then value.enable else true
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
  imports = [ ./options.nix ];

  config = mkMerge [
    {
      programs.firejail = {
        enable = mkForce osConfig.programs.firejail.enable;
        wrappedBinaries = {
          aerc = {
            enable = config.programs.aerc.enable;
            executable = "${getBin config.programs.aerc.package}/bin/aerc";
            profile = profiles.aerc;
            filterStderr.enable = true;
          };
          chromium = {
            enable = config.programs.chromium.enable;
            executable = "${config.programs.chromium.finalPackage}/bin/chromium";
            profile = profiles.chromium;
          };
          firefox = {
            enable = config.programs.firefox.enable;
            executable = "${config.programs.firefox.finalPackage}/bin/firefox";
            profile = profiles.firefox;
          };
          gallery-dl = {
            enable = config.programs.gallery-dl.enable;
            executable = "${getBin config.programs.gallery-dl.package}/bin/gallery-dl";
            profile = profiles.gallery-dl;
            filterStderr.enable = true;
          };
          mpv = {
            enable = config.programs.mpv.enable;
            executable = "${config.programs.mpv.finalPackage}/bin/mpv";
            profile = profiles.mpv;
            filterStderr = {
              enable = true;
              patterns = [
                "Error: dumpable process"
                "Remove read permission on fseccomp executable"
                "Warning: /usr/bin/bwrap was not disabled"
                "Remove read permission on fsec-optimize executable"
              ];
            };
          };
          newsboat = {
            enable = config.programs.newsboat.enable;
            executable = "${getBin config.programs.newsboat.package}/bin/newsboat";
            profile = profiles.newsboat;
            filterStderr = {
              enable = true;
              patterns = [
                "Error: dumpable process"
                "Remove read permission on fseccomp executable"
                "Warning: /usr/bin/bwrap was not disabled"
                "Warning: invalid private-bin path /usr/bin/bwrap"
                "Warning: An abstract unix socket for session D-BUS might still be available. Use --net or remove unix from --protocol set."
              ];
            };
          };
          obsidian = {
            enable = config.programs.obsidian.enable;
            executable = "${getBin config.programs.obsidian.package}/bin/obsidian";
            profile = profiles.obsidian;
          };
          qutebrowser = {
            enable = config.programs.qutebrowser.enable;
            executable = "${getBin config.programs.qutebrowser.package}/bin/qutebrowser";
            profile = profiles.qutebrowser;
          };
          thunderbird = {
            enable = config.programs.thunderbird.enable;
            executable = "${getBin config.programs.thunderbird.package}/bin/thunderbird";
            profile = profiles.thunderbird;
          };
          w3m = {
            enable = config.programs.w3m.enable;
            executable = "${config.programs.w3m.finalPackage}/bin/w3m";
            profile = profiles.w3m;
            filterStderr.enable = true;
          };
          yt-dlp = {
            enable = config.programs.yt-dlp.enable;
            executable = "${getBin config.programs.yt-dlp.package}/bin/yt-dlp";
            profile = profiles.yt-dlp;
            filterStderr.enable = true;
          };
          zathura = {
            enable = config.programs.zathura.enable;
            executable = "${getBin config.programs.zathura.package}/bin/zathura";
            profile = profiles.zathura;
          };
        }
        // optionalAttrs (config.programs ? spicetify) {
          spotify = {
            enable = config.programs.spicetify.enable;
            executable = "${config.programs.spicetify.spicedSpotify}/bin/spotify";
            profile = profiles.spotify;
          };
        };
      };
    }
    (mkIf cfg.enable {
      home.packages = [ wrappedBins ];
    })
  ];
}
