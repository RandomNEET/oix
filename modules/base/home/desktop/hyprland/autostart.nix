{ osConfig, lib }:
let
  inherit (lib) optionals;
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
  [
    "noctalia-shell"
    "hyprctl dispatch 'hl.dsp.focus({ workspace = 1 })'"
  ]
  ++ optionals (osConfig.desktop.niri.enable || osConfig.desktop.mango.enable) [
    "systemctl --user stop lxqt-policykit-agent.service"
    "systemctl --user start hyprpolkitagent.service"
  ]
)
