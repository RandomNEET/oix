{
  config,
  lib,
  pkgs,
  opts,
  ...
}:
let
  hasDesktop = opts ? desktop;
  tuigreetPrefix = "tuigreet --time --theme 'border=lightblue;text=white;prompt=lightcyan;time=lightyellow;action=white;button=lightred;container=black;input=white' --sessions /etc/greetd/sessions --cmd";
in
{
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        command = "${tuigreetPrefix} ${
          if hasDesktop then
            if (lib.strings.hasInfix "hyprland" opts.desktop) then
              "'systemd-cat -t hyprland start-hyprland'"
            else if (lib.strings.hasInfix "niri" opts.desktop) then
              "'systemd-cat -t niri niri-session'"
            else if config.programs.zsh.enable then
              "zsh"
            else
              "bash"
          else if config.programs.zsh.enable then
            "zsh"
          else
            "bash"
        }";
        user = "greeter";
      };
    }
    // (opts.greetd.settings or { });
  };
  environment.systemPackages = with pkgs; [ tuigreet ];
  imports = [ ./sessions.nix ];
}
