{ pkgs }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-vscode";
    name = "vscode-serial-monitor";
    version = "0.13.251128001";
    hash = "sha256-eTQcLyF6DMvzDByKLw2KR8PrjVwejsOU60Hew7IOmY8=";
  };
}
