{ config, lib, ... }:
let
  inherit (lib) optionalAttrs;
  cfg = config.oix.defaults;
  hasThunar = builtins.any (p: (lib.getName p) == "thunar") config.home.packages;
in
{
  home.sessionVariables =
    (optionalAttrs (cfg.terminal != null) {
      TERMINAL = cfg.terminal;
    })
    // (optionalAttrs (cfg.browser != null) {
      BROWSER = cfg.browser;
    });

  assertions = [
    {
      assertion = cfg.editor != "nvim" || config.programs.nixvim.enable;
      message = "oix.defaults.editor is set to 'nvim', but modules/editor/nvim is not imported.";
    }
    {
      assertion = cfg.editor != "helix" || config.programs.helix.enable;
      message = "oix.defaults.editor is set to 'helix', but modules/editor/helix is not imported.";
    }
    {
      assertion = cfg.fileManager != "yazi" || config.programs.yazi.enable;
      message = "oix.defaults.fileManager is set to 'yazi', but modules/file-manager/yazi is not imported.";
    }
    {
      assertion = cfg.fileManager != "thunar" || hasThunar;
      message = "oix.defaults.fileManager is set to 'thunar', but modules/file-manager/thunar is not imported.";
    }
    {
      assertion = cfg.terminal != "kitty" || config.programs.kitty.enable;
      message = "oix.defaults.terminal is set to 'kitty', but modules/terminal/kitty is not imported.";
    }
    {
      assertion = cfg.terminal != "foot" || config.programs.foot.enable;
      message = "oix.defaults.terminal is set to 'foot', but modules/terminal/foot is not imported.";
    }
    {
      assertion = cfg.browser != "qutebrowser" || config.programs.qutebrowser.enable;
      message = "oix.defaults.browser is set to 'qutebrowser', but modules/browser/qutebrowser is not imported.";
    }
    {
      assertion = cfg.browser != "firefox" || config.programs.firefox.enable;
      message = "oix.defaults.browser is set to 'firefox', but modules/browser/firefox is not imported.";
    }
    {
      assertion = cfg.browser != "chromium" || config.programs.chromium.enable;
      message = "oix.defaults.browser is set to 'chromium', but modules/browser/chromium is not imported.";
    }
    {
      assertion = cfg.browser != "w3m" || config.programs.w3m.enable;
      message = "oix.defaults.browser is set to 'w3m', but modules/browser/w3m is not imported.";
    }
  ];
}
