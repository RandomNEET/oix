{ pkgs, lib }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "CL";
    name = "eide";
    version = "3.27.2";
    hash = "sha256-ZoQF0fiRmn7vXfySMZ1227WFOOplZelyro3CM1Zldjo=";
  };

  meta = with lib; {
    description = "A mcu development environment for 8051/STM8/Cortex-M/MIPS/RISC-V on VsCode.";
    homepage = "https://github.com/github0null/eide";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
