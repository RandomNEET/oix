{
  config,
  lib,
  pkgs,
  opts,
  ...
}:
let
  inherit (lib) mkIf getBin;
  homeConfig = config.home-manager.users.${opts.users.primary.name};
  isInstalled =
    pname: pkgList: builtins.any (p: (builtins.isAttrs p) && (lib.getName p == pname)) pkgList;
  osCheck = pname: isInstalled pname config.environment.systemPackages;
  homeCheck = pname: isInstalled pname homeConfig.home.packages;
in
{
  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      aerc = mkIf homeConfig.programs.aerc.enable {
        executable = "${getBin pkgs.aerc}/bin/aerc";
        profile = "${pkgs.firejail}/etc/firejail/mail-common.profile";
      };
      calibre = mkIf (homeCheck "calibre") {
        executable = "${getBin pkgs.calibre}/bin/calibre";
        profile = "${pkgs.firejail}/etc/firejail/calibre.profile";
      };
      discord = mkIf homeConfig.programs.vesktop.enable {
        executable = "${getBin pkgs.vesktop}/bin/vesktop";
        profile = "${pkgs.firejail}/etc/firejail/vesktop.profile";
      };
      firefox = mkIf homeConfig.programs.firefox.enable {
        executable = "${getBin pkgs.firefox}/bin/firefox";
        profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
      };
      gh = mkIf homeConfig.programs.gh.enable {
        executable = "${getBin pkgs.gh}/bin/gh";
        profile = "${pkgs.firejail}/etc/firejail/gh.profile";
      };
      gimp = mkIf (homeCheck "gimp") {
        executable = "${getBin pkgs.gimp}/bin/gimp";
        profile = "${pkgs.firejail}/etc/firejail/gimp.profile";
      };
      libreoffice = mkIf (homeCheck "libreoffice") {
        executable = "${getBin pkgs.libreoffice}/bin/libreoffice";
        profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
      };
      localsend = mkIf (homeCheck "localsend") {
        executable = "${getBin pkgs.localsend}/bin/localsend_app";
        profile = "${pkgs.firejail}/etc/firejail/localsend_app.profile";
      };
      mpv = mkIf homeConfig.programs.mpv.enable {
        executable = "${getBin pkgs.mpv}/bin/mpv";
        profile = "${pkgs.firejail}/etc/firejail/mpv.profile";
      };
      newsboat = mkIf homeConfig.programs.newsboat.enable {
        executable = "${getBin pkgs.newsboat}/bin/newsboat";
        profile = "${pkgs.firejail}/etc/firejail/newsboat.profile";
      };
      obsidian = mkIf homeConfig.programs.obsidian.enable {
        executable = "${getBin pkgs.obsidian}/bin/obsidian";
        profile = "${pkgs.firejail}/etc/firejail/obsidian.profile";
      };
      prismlauncher = mkIf (homeCheck "prismlauncher") {
        executable = "${getBin pkgs.prismlauncher}/bin/prismlauncher";
        profile = "${pkgs.firejail}/etc/firejail/prismlauncher.profile";
      };
      qbittorrent = mkIf (homeCheck "qbittorrent") {
        executable = "${getBin pkgs.qbittorrent}/bin/qbittorrent";
        profile = "${pkgs.firejail}/etc/firejail/qbittorrent.profile";
      };
      qq = mkIf (homeCheck "qq") {
        executable = "${getBin pkgs.qq}/bin/qq";
        profile = "${pkgs.firejail}/etc/firejail/qq.profile";
      };
      spicetify = mkIf homeConfig.programs.spicetify.enable {
        executable = "${getBin pkgs.spotify}/bin/spotify";
        profile = "${pkgs.firejail}/etc/firejail/spotify.profile";
      };
      thunderbird = mkIf homeConfig.programs.thunderbird.enable {
        executable = "${getBin pkgs.thunderbird}/bin/thunderbird";
        profile = "${pkgs.firejail}/etc/firejail/thunderbird.profile";
      };
      vscode = mkIf homeConfig.programs.vscode.enable {
        executable = "${getBin pkgs.vscode}/bin/code";
        profile = "${pkgs.firejail}/etc/firejail/code.profile";
      };
      w3m = mkIf (homeCheck "w3m") {
        executable = "${getBin pkgs.w3m}/bin/w3m";
        profile = "${pkgs.firejail}/etc/firejail/w3m.profile";
      };
      yt-dlp = mkIf homeConfig.programs.yt-dlp.enable {
        executable = "${getBin pkgs.yt-dlp}/bin/yt-dlp";
        profile = "${pkgs.firejail}/etc/firejail/yt-dlp.profile";
      };
      zathura = mkIf homeConfig.programs.zathura.enable {
        executable = "${getBin pkgs.zathura}/bin/zathura";
        profile = "${pkgs.firejail}/etc/firejail/zathura.profile";
      };
    };
  };
}
