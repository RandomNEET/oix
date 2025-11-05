{
  config,
  pkgs,
  opts,
  ...
}:
{
  services.greetd = {
    enable = true;
    settings =
      if ((opts.greetd.settings or "") != "") then
        opts.greetd.settings
      else if config.programs.hyprland.enable then
        {
          default_session = {
            command = "tuigreet --time --theme 'border=lightblue;text=white;prompt=lightcyan;time=lightyellow;action=white;button=lightred;container=black;input=white' --cmd hyprland";
            user = "greeter";
          };
        }
      else if config.programs.niri.enable then
        {
          default_session = {
            command = "tuigreet --time --theme 'border=lightblue;text=white;prompt=lightcyan;time=lightyellow;action=white;button=lightred;container=black;input=white' --cmd niri-session";
            user = "greeter";
          };
        }
      else if config.programs.zsh.enable then
        {
          default_session = {
            command = "tuigreet --time --theme 'border=lightblue;text=white;prompt=lightcyan;time=lightyellow;action=white;button=lightred;container=black;input=white' --cmd zsh";
            user = "greeter";
          };
        }
      else
        {
          default_session = {
            command = "tuigreet --time --theme 'border=lightblue;text=white;prompt=lightcyan;time=lightyellow;action=white;button=lightred;container=black;input=white' --cmd bash";
            user = "greeter";
          };
        };
  };

  environment.systemPackages = with pkgs; [
    pkgs.tuigreet
  ];
}
