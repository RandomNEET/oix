{ pkgs }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "mcu-debug";
    name = "rtos-views";
    version = "0.0.15";
    hash = "sha256-yytAP5U7urgKLcQO0rp6jlcxIVzDls6jWddaojTV6nQ=";
  };
}
