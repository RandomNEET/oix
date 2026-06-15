{ pkgs, lib }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "mcu-debug";
    name = "rtos-views";
    version = "0.0.16";
    hash = "sha256-EyHItd82GW8AXu4cG1oyT54AuX3b5QoaEww0W3+bFbo=";
  };

  meta = with lib; {
    description = "RTOS views for micro-controllers that work with any debugger.";
    homepage = "https://github.com/mcu-debug/rtos-views";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
