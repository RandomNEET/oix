{ pkgs, lib }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "mcu-debug";
    name = "peripheral-viewer";
    version = "1.6.1";
    hash = "sha256-DwaL0lct8KevC7AVFLydQTQEr1mC1Rz+P+jl+zHoN+k=";
  };

  meta = with lib; {
    description = "Standalone SVD Viewer extension extracted from cortex-debug but now work with any debugger that supports the Microsoft Debug Protocol";
    homepage = "https://github.com/mcu-debug/peripheral-viewer";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
