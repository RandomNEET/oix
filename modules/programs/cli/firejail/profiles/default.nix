{
  config,
  lib,
  pkgs,
  opts,
  ...
}:
let
  env = rec {
    inherit
      config
      lib
      pkgs
      opts
      ;
    DESKTOP =
      if (config.xdg.userDirs.desktop != null) then
        config.xdg.userDirs.desktop
      else
        "${config.home.homeDirectory}/Desktop";
    DOCUMENTS =
      if (config.xdg.userDirs.documents != null) then
        config.xdg.userDirs.documents
      else
        "${config.home.homeDirectory}/Documents";
    DOWNLOADS =
      if (config.xdg.userDirs.download != null) then
        config.xdg.userDirs.download
      else
        "${config.home.homeDirectory}/Downloads";
    MUSIC =
      if (config.xdg.userDirs.music != null) then
        config.xdg.userDirs.music
      else
        "${config.home.homeDirectory}/Music";
    PICTURES =
      if (config.xdg.userDirs.pictures != null) then
        config.xdg.userDirs.pictures
      else
        "${config.home.homeDirectory}/Pictures";
    VIDEOS =
      if (config.xdg.userDirs.videos != null) then
        config.xdg.userDirs.videos
      else
        "${config.home.homeDirectory}/Videos";
    global = pkgs.writeText "firejail-global-profile" ''
      blacklist ''${HOME}/.vault
    '';
  };
in
{
  aerc = import ./aerc.nix env;
  calibre = import ./calibre.nix env;
  firefox = import ./firefox.nix env;
  gimp = import ./gimp.nix env;
  libreoffice = import ./libreoffice.nix env;
  mpv = import ./mpv.nix env;
  newsboat = import ./newsboat.nix env;
  obsidian = import ./obsidian.nix env;
  qbittorrent = import ./qbittorrent.nix env;
  qq = import ./qq.nix env;
  qutebrowser = import ./qutebrowser.nix env;
  spotify = import ./spotify.nix env;
  thunderbird = import ./thunderbird.nix env;
  vesktop = import ./vesktop.nix env;
  w3m = import ./w3m.nix env;
  yt-dlp = import ./yt-dlp.nix env;
  zathura = import ./zathura.nix env;
}
