{ osConfig, lib, ... }:
{
  config = lib.mkIf osConfig.desktop.enable {
    services.cliphist = {
      enable = true;
      allowImages = true;
      extraOptions = [
        "-max-dedupe-search"
        "10"
        "-max-items"
        "500"
      ];
    };
  };
}
