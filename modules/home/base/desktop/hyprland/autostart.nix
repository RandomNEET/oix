{ lib, mkLuaInline }:
let
  mkExecOnce = cmds: {
    _args = [
      "hyprland.start"
      (mkLuaInline ''
        function()
          ${lib.concatMapStringsSep "\n    " (cmd: "hl.exec_cmd(\"${cmd}\")") cmds}
        end
      '')
    ];
  };
in
mkExecOnce [
  "noctalia-shell"
  "hyprctl dispatch workspace 1"
]
