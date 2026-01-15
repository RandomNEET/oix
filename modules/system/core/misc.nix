{ pkgs, opts, ... }:
{
  nix = {
    settings = {
      auto-optimise-store = true;
      substituters = [ "https://nix-community.cachix.org" ] ++ (opts.nix.settings.substituters or [ ]);
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ]
      ++ (opts.nix.settings.trusted-public-keys or [ ]);
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
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";
}
