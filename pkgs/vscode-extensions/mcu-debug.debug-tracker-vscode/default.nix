{ pkgs, lib }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "mcu-debug";
    name = "debug-tracker-vscode";
    version = "0.0.15";
    hash = "sha256-2u4Moixrf94vDLBQzz57dToLbqzz7OenQL6G9BMCn3I=";
  };

  meta = with lib; {
    description = "This extension is an API extension to help other extension track debug sessions.";
    homepage = "https://github.com/mcu-debug/debug-tracker-vscode";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
