{ opts, ... }:
{
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
  system.stateVersion = "26.05";
}
