# Requirements: 'programs.firejail.enable = true;' and firejail installed at system level
{
  osConfig,
  config,
  lib,
  pkgs,
  meta,
  ...
}:
let
  inherit (lib) getBin;
  profiles = import ./profiles {
    inherit
      osConfig
      config
      lib
      pkgs
      meta
      ;
  };
  checkPkgs =
    pname: builtins.any (p: (builtins.isAttrs p) && (lib.getName p == pname)) config.home.packages;
in
{
  imports = [ ./options.nix ];
  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      aerc = {
        enable = config.programs.aerc.enable;
        executable = "${getBin pkgs.aerc}/bin/aerc";
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
      mpv = {
        enable = config.programs.mpv.enable;
        executable = "${config.programs.mpv.finalPackage}/bin/mpv";
        profile = profiles.mpv;
        filterStderr = {
          enable = true;
          patterns = [
            "dumpable"
            "fseccomp"
            "bwrap"
            "fsec-optimize"
          ];
        };
      };
      newsboat = {
        enable = config.programs.newsboat.enable;
        executable = "${getBin pkgs.newsboat}/bin/newsboat";
        profile = profiles.newsboat;
        filterStderr = {
          enable = true;
          patterns = [
            "dumpable"
            "fseccomp"
            "bwrap"
            "unix"
          ];
        };
      };
      obsidian = {
        enable = config.programs.obsidian.enable;
        executable = "${getBin pkgs.obsidian}/bin/obsidian";
        profile = profiles.obsidian;
      };
      qutebrowser = {
        enable = config.programs.qutebrowser.enable;
        executable = "${getBin pkgs.qutebrowser}/bin/qutebrowser";
        profile = profiles.qutebrowser;
      };
      spotify = {
        enable = config.programs.spicetify.enable;
        executable = "${config.programs.spicetify.spicedSpotify}/bin/spotify";
        profile = profiles.spotify;
      };
      thunderbird = {
        enable = config.programs.thunderbird.enable;
        executable = "${getBin pkgs.thunderbird}/bin/thunderbird";
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
        executable = "${getBin pkgs.yt-dlp}/bin/yt-dlp";
        profile = profiles.yt-dlp;
        filterStderr.enable = true;
      };
      zathura = {
        enable = config.programs.zathura.enable;
        executable = "${getBin pkgs.zathura}/bin/zathura";
        profile = profiles.zathura;
      };
    };
  };
}
