{ lib, ... }:
{
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

  oix.defaults.browser = lib.mkDefault "chromium";
}
