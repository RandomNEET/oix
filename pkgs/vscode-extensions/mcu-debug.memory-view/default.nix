{ pkgs }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "mcu-debug";
    name = "memory-view";
    version = "0.0.29";
    hash = "sha256-YZP02EeDe05LQn4gZWSCXndxV70Jfweu+jDu62ElGhI=";
  };
}
