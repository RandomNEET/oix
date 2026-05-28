{ pkgs }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "mcu-debug";
    name = "debug-tracker-vscode";
    version = "0.0.15";
    hash = "sha256-2u4Moixrf94vDLBQzz57dToLbqzz7OenQL6G9BMCn3I=";
  };
}
