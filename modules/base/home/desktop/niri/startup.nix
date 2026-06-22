{ config, lib }:
let
  inherit (lib) optional;
in
[ { sh = "noctalia"; } ]
++ optional config.programs.foot.server.enable { sh = "systemctl --user restart foot.service"; }
++ optional (config.i18n.inputMethod.type == "fcitx5") {
  sh = "systemctl --user restart fcitx5-daemon.service";
}
