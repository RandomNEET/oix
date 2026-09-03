{ pkgs, lib }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "mcu-debug";
    name = "peripheral-viewer";
    version = "1.6.3";
    hash = "sha256-ElqS0Zsd1qptgQyQI1lAVwyK8oDJYuoF6Q8UkMBnqNM=";
  };

  meta = with lib; {
    description = "Standalone SVD Viewer extension extracted from cortex-debug but now work with any debugger that supports the Microsoft Debug Protocol";
    homepage = "https://github.com/mcu-debug/peripheral-viewer";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
