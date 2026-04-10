{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getBin;
  profiles = import ./profiles {
    inherit
      config
      lib
      pkgs
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
            "fsec-optimize"
          ];
        };
      };
      newsboat = {
        enable = config.programs.newsboat.enable;
        executable = "${getBin pkgs.newsboat}/bin/newsboat";
        profile = profiles.newsboat;
        filterStderr.enable = true;
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
      vesktop = {
        enable = config.programs.vesktop.enable;
        executable = "${getBin pkgs.vesktop}/bin/vesktop";
        profile = profiles.vesktop;
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

      calibre = {
        enable = checkPkgs "calibre";
        executable = "${getBin pkgs.calibre}/bin/calibre";
        profile = profiles.calibre;
      };
      gimp = {
        enable = checkPkgs "gimp";
        executable = "${getBin pkgs.gimp}/bin/gimp";
        profile = profiles.gimp;
      };
      libreoffice = {
        enable = checkPkgs "libreoffice";
        executable = "${getBin pkgs.libreoffice}/bin/libreoffice";
        profile = profiles.libreoffice;
      };
      qbittorrent = {
        enable = checkPkgs "qbittorrent";
        executable = "${getBin pkgs.qbittorrent}/bin/qbittorrent";
        profile = profiles.qbittorrent;
      };
      qq = {
        enable = checkPkgs "qq";
        executable = "${getBin pkgs.qq}/bin/qq";
        profile = profiles.qq;
      };
      tor-browser = {
        enable = checkPkgs "tor-browser";
        executable = "${getBin pkgs.tor-browser}/bin/tor-browser";
        profile = profiles.tor-browser;
      };
      w3m = {
        enable = checkPkgs "w3m";
        executable = "${getBin pkgs.w3m}/bin/w3m";
        profile = profiles.w3m;
        filterStderr.enable = true;
      };
    };
  };
}
