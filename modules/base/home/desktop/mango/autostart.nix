{ config, lib }:
let
  inherit (lib) optional;
in
{
  exec-once = [
    "noctalia"
  ]
  ++ optional config.programs.foot.server.enable "systemctl --user restart foot.service"
  ++ optional (
    config.i18n.inputMethod.type == "fcitx5"
  ) "systemctl --user restart fcitx5-daemon.service ";
}
