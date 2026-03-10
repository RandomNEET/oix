{ opts, ... }:
{
  nix = {
    settings = {
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
    optimise = {
      automatic = true;
      dates = "weekly";
      persistent = true;
      randomizedDelaySec = "60min";
    };
  };
  i18n =
    let
      locale = opts.locale or "en_US.UTF-8";
    in
    {
      defaultLocale = locale;
      extraLocaleSettings = {
        LC_ADDRESS = locale;
        LC_IDENTIFICATION = locale;
        LC_MEASUREMENT = locale;
        LC_MONETARY = locale;
        LC_NAME = locale;
        LC_NUMERIC = locale;
        LC_PAPER = locale;
        LC_TELEPHONE = locale;
        LC_TIME = locale;
      };
    };
  time.timeZone = opts.timezone or "Asia/Shanghai";
  console.keyMap = opts.consoleKeymap or "us";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";
}
