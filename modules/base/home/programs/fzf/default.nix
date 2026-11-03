{
  osConfig,
  config,
  lib,
  meta,
  ...
}:
let
  inherit (lib) optionalAttrs;
in
{
  programs.fzf =
    if (meta.channel == "unstable") then
      lib.mkMerge [
        {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
          defaultOptions = [
            "--height 40%"
            "--layout=reverse"
            "--border"
          ];
          historyWidget = {
            options = [
              "--sort"
              "--exact"
            ];
          };
        }
        (optionalAttrs config.programs.atuin.enable {
          historyWidget.command = "";
        })
        (optionalAttrs config.programs.tmux.enable {
          tmux.enableShellIntegration = true;
        })
        (optionalAttrs config.programs.bat.enable {
          fileWidget.options = [
            "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
          ];
        })
        (optionalAttrs config.programs.eza.enable {
          changeDirWidget.options = [ "--preview 'eza --tree --color=always {} | head -200'" ];
        })
        (optionalAttrs config.programs.fd.enable {
          defaultCommand = "fd --type f --strip-cwd-prefix";
          fileWidget.command = "fd --type f --strip-cwd-prefix";
          changeDirWidget.command = "fd --type d --strip-cwd-prefix";
        })
      ]
    else
      # 26.05
      lib.mkMerge [
        {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
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
        (optionalAttrs config.programs.tmux.enable {
          tmux.enableShellIntegration = true;
        })
        (optionalAttrs config.programs.bat.enable {
          fileWidgetOptions = [ "--preview 'bat --color=always --style=numbers --line-range=:500 {}'" ];
        })
        (optionalAttrs config.programs.eza.enable {
          changeDirWidgetOptions = [ "--preview 'eza --tree --color=always {} | head -200'" ];
        })
        (optionalAttrs config.programs.fd.enable {
          defaultCommand = "fd --type f --strip-cwd-prefix";
          fileWidgetCommand = "fd --type f --strip-cwd-prefix";
          changeDirWidgetCommand = "fd --type d --strip-cwd-prefix";
        })
      ];
}
// optionalAttrs osConfig.desktop.themes.enable {
  stylix.targets.fzf.enable = true;
}
