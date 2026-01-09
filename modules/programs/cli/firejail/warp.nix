{
  config,
  lib,
  pkgs,
  opts,
  ...
}:
let
  inherit (lib) getBin;

  profiles = import ./profiles {
    inherit
      config
      lib
      pkgs
      opts
      ;
  };

  check =
    pname: builtins.any (p: (builtins.isAttrs p) && (lib.getName p == pname)) config.home.packages;

  themes = opts.themes or [ ];
  hasThemes = themes != [ ];

  packages = {
    aerc = {
      enable = config.programs.aerc.enable;
      bin = "${getBin pkgs.aerc}/bin/aerc";
      profile = profiles.aerc;
    };
    code = {
      enable = config.programs.vscode.enable;
      bin = "${getBin pkgs.vscode}/bin/code";
      profile = profiles.code;
    };
    firefox = {
      enable = config.programs.firefox.enable;
      bin = "${getBin pkgs.firefox}/bin/firefox";
      profile = profiles.firefox;
    };
    mpv = {
      enable = config.programs.mpv.enable;
      bin = "${config.programs.mpv.finalPackage}/bin/mpv";
      profile = profiles.mpv;
    };
    newsboat = {
      enable = config.programs.newsboat.enable;
      bin = "${getBin pkgs.newsboat}/bin/newsboat";
      profile = profiles.newsboat;
    };
    obsidian = {
      enable = config.programs.obsidian.enable;
      bin = "${getBin pkgs.obsidian}/bin/obsidian";
      profile = profiles.obsidian;
    };
    qutebrowser = {
      enable = config.programs.qutebrowser.enable;
      bin = "${getBin pkgs.qutebrowser}/bin/qutebrowser";
      profile = profiles.qutebrowser;
    };
    spotify = {
      enable = config.programs.spicetify.enable;
      bin =
        if hasThemes then
          "${config.programs.spicetify.spicedSpotify}/bin/spotify"
        else
          "${getBin pkgs.spotify}/bin/spotify";
      profile = profiles.spotify;
    };
    thunderbird = {
      enable = config.programs.thunderbird.enable;
      bin = "${getBin pkgs.thunderbird}/bin/thunderbird";
      profile = profiles.thunderbird;
    };
    vesktop = {
      enable = config.programs.vesktop.enable;
      bin = "${getBin pkgs.vesktop}/bin/vesktop";
      profile = profiles.vesktop;
    };
    yt-dlp = {
      enable = config.programs.yt-dlp.enable;
      bin = "${getBin pkgs.yt-dlp}/bin/yt-dlp";
      profile = profiles.yt-dlp;
    };
    zathura = {
      enable = config.programs.zathura.enable;
      bin = "${getBin pkgs.zathura}/bin/zathura";
      profile = profiles.zathura;
    };

    calibre = {
      enable = check "calibre";
      bin = "${getBin pkgs.calibre}/bin/calibre";
      profile = profiles.calibre;
    };
    gimp = {
      enable = check "gimp";
      bin = "${getBin pkgs.gimp}/bin/gimp";
      profile = profiles.gimp;
    };
    libreoffice = {
      enable = check "libreoffice";
      bin = "${getBin pkgs.libreoffice}/bin/libreoffice";
      profile = profiles.libreoffice;
    };
    qbittorrent = {
      enable = check "qbittorrent";
      bin = "${getBin pkgs.qbittorrent}/bin/qbittorrent";
      profile = profiles.qbittorrent;
    };
    qq = {
      enable = check "qq";
      bin = "${getBin pkgs.qq}/bin/qq";
      profile = profiles.qq;
    };
    w3m = {
      enable = check "w3m";
      bin = "${getBin pkgs.w3m}/bin/w3m";
      profile = profiles.w3m;
    };
  };

  toWarp = lib.filter (name: packages.${name}.enable) (builtins.attrNames packages);

  # line '2> >(grep -v -e "fseccomp" -e "dumpable" >&2)' is to suppress known warnings about 'dumpable process' and 'fseccomp' permissions
  warpCmd =
    name:
    let
      pkg = packages.${name};
    in
    ''
      #! ${pkgs.bash}/bin/bash -e
      exec /run/wrappers/bin/firejail \
        --profile=${pkg.profile} \
        -- ${pkg.bin} "$@" \
        2> >(grep -v -e "fseccomp" -e "dumpable" >&2)
    '';
in
{
  home.file = lib.genAttrs toWarp (name: {
    target = ".local/bin/${name}";
    executable = true;
    text = warpCmd name;
  });
  home.sessionPath = [ "$HOME/.local/bin" ];
}
