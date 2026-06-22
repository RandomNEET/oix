{ config, lib }:
let
  inherit (lib) optional;
  mkAutostart = cmds: [
    {
      _args = [
        "hyprland.start"
        (lib.generators.mkLuaInline ''
          function()
            ${lib.concatMapStringsSep "\n    " (cmd: "hl.exec_cmd(\"${cmd}\")") cmds}
          end
        '')
      ];
    }
  ];
in
mkAutostart (
  [ "noctalia" ]
  ++ optional config.programs.foot.server.enable "systemctl --user restart foot.service"
  ++ optional (
    config.i18n.inputMethod.type == "fcitx5"
  ) "systemctl --user restart fcitx5-daemon.service"
  ++ [ "hyprctl dispatch 'hl.dsp.focus({ workspace = 1 })'" ]
)
