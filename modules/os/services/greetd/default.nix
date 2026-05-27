{ config, pkgs, ... }:
let
  tuigreetPrefix = "tuigreet --time --theme 'border=lightblue;text=white;prompt=lightcyan;time=lightyellow;action=white;button=lightred;container=black;input=white' --sessions /etc/greetd/sessions --cmd";
in
{
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        command = "${tuigreetPrefix} ${
          if config.desktop.enable then
            if config.desktop.hyprland.primary then
              "'systemd-cat -t hyprland start-hyprland'"
            else if config.desktop.niri.primary then
              "'systemd-cat -t niri niri-session'"
            else if config.desktop.plasma.primary then
              "'systemd-cat -t plasma ${pkgs.kdePackages.plasma-workspace}/libexec/plasma-dbus-run-session-if-needed ${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland'"
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
    };
  };
  environment.systemPackages = with pkgs; [ tuigreet ];
  imports = [ ./sessions.nix ];
}
