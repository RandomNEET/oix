{
  osConfig,
  config,
  lib,
  ...
}:
{
  programs.foot = {
    enable = true;
    settings = {
      mouse = {
        hide-when-typing = "yes";
      };
      key-bindings = {
        scrollback-up-half-page = "Control+Shift+k";
        scrollback-down-half-page = "Control+Shift+j";
      };
    };
    server.enable = true;
  };
  systemd.user.services.foot.Service.Environment = lib.mkIf (
    config.programs.foot.server.enable && config.programs.tmux.secureSocket
  ) "TMUX_TMPDIR=%t";
}
// lib.optionalAttrs osConfig.desktop.themes.enable {
  stylix.targets.foot.enable = true;
}
