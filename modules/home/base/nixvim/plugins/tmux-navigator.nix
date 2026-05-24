{
  config,
  lib,
  meta,
  ...
}:
{
  programs.nixvim = lib.mkIf config.programs.tmux.enable {
    plugins.tmux-navigator = {
      enable = true;
    }
    // lib.optionalAttrs (meta.channel == "unstable") {
      lazyLoad = {
        enable = true;
        settings = {
          event = "DeferredUIEnter";
        };
      };
    };
  };
}
