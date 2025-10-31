{ opts, ... }:
{
  nix = {
    settings = {
      auto-optimise-store = true;
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
  time.timeZone = opts.timezone;
  i18n = {
    defaultLocale = opts.locale;
    extraLocaleSettings = {
      LC_ADDRESS = opts.locale;
      LC_IDENTIFICATION = opts.locale;
      LC_MEASUREMENT = opts.locale;
      LC_MONETARY = opts.locale;
      LC_NAME = opts.locale;
      LC_NUMERIC = opts.locale;
      LC_PAPER = opts.locale;
      LC_TELEPHONE = opts.locale;
      LC_TIME = opts.locale;
    };
  };
  console.keyMap = opts.consoleKeymap;
  environment.sessionVariables = {
    # These are the defaults, and xdg.enable does set them, but due to load
    # order, they're not set before environment.variables are set, which could
    # cause race conditions.
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_BIN_HOME = "$HOME/.local/bin";
  };
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
}
