{ pkgs }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "CL";
    name = "eide";
    version = "3.27.2";
    hash = "sha256-ZoQF0fiRmn7vXfySMZ1227WFOOplZelyro3CM1Zldjo=";
  };
}
