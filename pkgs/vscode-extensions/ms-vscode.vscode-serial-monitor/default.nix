{ pkgs, lib }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-vscode";
    name = "vscode-serial-monitor";
    version = "0.13.1";
    hash = "sha256-qZKCNG5EdMwzE9y3WVxaPMdTP9Y0xbe8kozjU7v44OI=";
  };

  meta = with lib; {
    description = "The Serial Monitor extension for Visual Studio Code provides a way to read from and write to serial ports.";
    homepage = "https://github.com/microsoft/vscode-serial-monitor";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
