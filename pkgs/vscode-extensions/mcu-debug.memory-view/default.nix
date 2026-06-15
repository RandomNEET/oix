{ pkgs, lib }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "mcu-debug";
    name = "memory-view";
    version = "0.0.29";
    hash = "sha256-YZP02EeDe05LQn4gZWSCXndxV70Jfweu+jDu62ElGhI=";
  };

  meta = with lib; {
    description = "This is a memory viewer extension specially built to work with debuggers.";
    homepage = "https://github.com/mcu-debug/memview";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
