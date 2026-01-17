{
  osConfig,
  pkgs,
  opts,
  randomwallctl,
  optionalString,
  getExe,
  ...
}:
''
  spawn-sh-at-startup "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=gnome"
  spawn-sh-at-startup "systemctl --user stop xdg-desktop-portal.service"
  spawn-sh-at-startup "systemctl --user start xdg-desktop-portal.service"
  spawn-sh-at-startup "systemctl --user restart lxqt-policykit-agent.service"
  spawn-sh-at-startup "wl-clipboard-history -t"
  spawn-sh-at-startup "wl-paste --type text --watch cliphist store"
  spawn-sh-at-startup "wl-paste --type image --watch cliphist store"
  spawn-sh-at-startup "rm $XDG_CACHE_HOME/cliphist/db"
  spawn-sh-at-startup "nm-applet --indicator"
  spawn-sh-at-startup "${randomwallctl} -r"
  ${optionalString (
    ((opts.terminal or "") == "foot") && (opts.foot.server or false)
  ) ''spawn-sh-at-startup "${getExe pkgs.foot} --server"''}
''
