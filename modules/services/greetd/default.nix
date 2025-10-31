{
  pkgs,
  opts,
  ...
}:
{
  services.greetd = {
    enable = true;
    settings = opts.greetd.settings;
  };

  environment.systemPackages = with pkgs; [
    pkgs.tuigreet
  ];
}
