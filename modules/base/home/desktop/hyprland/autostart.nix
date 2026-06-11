{ lib }:
let
  mkAutostart = cmds: {
    _args = [
      "hyprland.start"
      (lib.generators.mkLuaInline ''
        function()
          ${lib.concatMapStringsSep "\n    " (cmd: "hl.exec_cmd(\"${cmd}\")") cmds}
        end
      '')
    ];
  };
in
mkAutostart [
  "noctalia-shell"
  "hyprctl dispatch 'hl.dsp.focus({ workspace = 1 })'"
]
