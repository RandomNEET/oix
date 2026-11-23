{ config, lib, ... }:
{
  config = lib.mkIf config.defaultPrograms.browser.chromium.enable ({
    programs.chromium = {
      enable = true;
      commandLineArgs = [
        "--ignore-gpu-blocklist"
      ];
      extensions = [
        { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # uBlock Origin Lite
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
      ];
    };
  });
}
