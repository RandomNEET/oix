{ osConfig, lib }:
let
  inherit (lib) optionals;
in
[ { sh = "noctalia-shell"; } ]
++ optionals osConfig.desktop.hyprland.enable [
  { sh = "systemctl --user stop hyprpolkitagent.service"; }
  { sh = "systemctl --user start lxqt-policykit-agent.service"; }
]
