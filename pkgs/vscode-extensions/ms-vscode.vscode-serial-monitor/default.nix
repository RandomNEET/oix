{ pkgs, lib }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-vscode";
    name = "vscode-serial-monitor";
    version = "0.13.251128001";
    hash = "sha256-eTQcLyF6DMvzDByKLw2KR8PrjVwejsOU60Hew7IOmY8=";
  };

  meta = with lib; {
    description = "The Serial Monitor extension for Visual Studio Code provides a way to read from and write to serial ports.";
    homepage = "https://github.com/microsoft/vscode-serial-monitor";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
