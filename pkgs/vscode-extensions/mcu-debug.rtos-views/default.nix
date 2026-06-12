{ pkgs }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "mcu-debug";
    name = "rtos-views";
    version = "0.0.16";
    hash = "sha256-EyHItd82GW8AXu4cG1oyT54AuX3b5QoaEww0W3+bFbo=";
  };
}
