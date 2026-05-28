{ pkgs }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "CL";
    name = "eide";
    version = "3.27.0";
    hash = "sha256-NLgr7hVD1odnTZXIiqeRMNlDuoYukw1VL5MIx4vCvRo=";
  };
}
