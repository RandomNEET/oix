{
  osConfig,
  config,
  lib,
}:
let
  inherit (lib) optional optionals;
in
{
  exec-once = [
    "noctalia-shell"
  ]
  ++ optional config.programs.foot.server.enable "systemctl --user restart foot-server.service foot-server.socket"
  ++ optional (
    config.i18n.inputMethod.type == "fcitx5"
  ) "systemctl --user restart fcitx5-daemon.service "
  ++ optionals osConfig.desktop.hyprland.enable [
    "systemctl --user stop hyprpolkitagent.service"
    "systemctl --user start lxqt-policykit-agent.service"
  ];
}
