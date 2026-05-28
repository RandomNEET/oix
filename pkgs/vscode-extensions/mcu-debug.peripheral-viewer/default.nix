{ pkgs }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "mcu-debug";
    name = "peripheral-viewer";
    version = "1.6.1";
    hash = "sha256-DwaL0lct8KevC7AVFLydQTQEr1mC1Rz+P+jl+zHoN+k=";
  };
}
