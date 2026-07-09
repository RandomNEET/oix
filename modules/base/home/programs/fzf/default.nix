{
  osConfig,
  config,
  lib,
  meta,
  ...
}:
{
  programs.fzf =
    if (meta.channel == "unstable") then
      {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        tmux.enableShellIntegration = true;
        defaultOptions = [
          "--height 40%"
          "--layout=reverse"
          "--border"
        ];
        historyWidget.options = [
          "--sort"
          "--exact"
        ];
      }
      // lib.optionalAttrs config.programs.bat.enable {
        fileWidget.options = [
          "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
        ];
      }
      // lib.optionalAttrs config.programs.eza.enable {
        changeDirWidget.options = [
          "--preview 'eza --tree --color=always {} | head -200'"
        ];
      }
      // lib.optionalAttrs config.programs.fd.enable {
        defaultCommand = "fd --type f --strip-cwd-prefix";
        fileWidget.command = "fd --type f --strip-cwd-prefix";
        changeDirWidget.command = "fd --type d --strip-cwd-prefix";
      }
    else
      {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        tmux.enableShellIntegration = true;
        defaultOptions = [
          "--height 40%"
          "--layout=reverse"
          "--border"
        ];
        historyWidgetOptions = [
          "--sort"
          "--exact"
        ];
      }
      // lib.optionalAttrs config.programs.bat.enable {
        fileWidgetOptions = [
          "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
        ];
      }
      // lib.optionalAttrs config.programs.eza.enable {
        changeDirWidgetOptions = [
          "--preview 'eza --tree --color=always {} | head -200'"
        ];
      }
      // lib.optionalAttrs config.programs.fd.enable {
        defaultCommand = "fd --type f --strip-cwd-prefix";
        fileWidgetCommand = "fd --type f --strip-cwd-prefix";
        changeDirWidgetCommand = "fd --type d --strip-cwd-prefix";
      };
}
// lib.optionalAttrs osConfig.desktop.themes.enable {
  stylix.targets.fzf.enable = true;
}
