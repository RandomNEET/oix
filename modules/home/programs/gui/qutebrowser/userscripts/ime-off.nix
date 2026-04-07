{ pkgs, ... }:
pkgs.writeShellScript "ime-off" ''
  FCITX5_REMOTE="${pkgs.fcitx5}/bin/fcitx5-remote"

  if [ "$1" = "fcitx5" ]; then
    STATE=$($FCITX5_REMOTE)

    if [ "$STATE" != "1" ]; then
      $FCITX5_REMOTE -c
    fi
  fi
''
