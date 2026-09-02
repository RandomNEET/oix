{
  pkgs,
  global,
  DOWNLOADS,
  MUSIC,
  VIDEOS,
  ...
}:
let
  yt-dlp-profile = import ./yt-dlp.nix {
    inherit
      pkgs
      global
      DOWNLOADS
      MUSIC
      VIDEOS
      ;
  };
  local = pkgs.writeText "firejail-gallery-dl-local" "";
in
pkgs.writeText "firejail-gallery-dl-profile" ''
  # Firejail profile for gallery-dl
  # Description: Downloader of images from various sites
  # This file is overwritten after every install/update
  quiet
  # Persistent local customizations
  include ${local}
  # Persistent global definitions
  # added by included profile
  #include ${global}

  noblacklist ''${HOME}/.config/gallery-dl
  noblacklist ''${HOME}/.gallery-dl.conf

  private-bin gallery-dl
  private-etc gallery-dl.conf

  # Redirect
  include ${yt-dlp-profile}
''
