{ pkgs, lib }:
let
  sources = builtins.fromJSON (builtins.readFile ./sources.json);
  system = pkgs.stdenv.hostPlatform.system;
  targetPlatform =
    {
      x86_64-linux = "linux-x64";
      aarch64-linux = "linux-arm64";
    }
    .${system} or (throw "mcu-debug.debug-tracker-vscode: unsupported system ${system}");
  candidates = builtins.filter (platform: builtins.hasAttr platform sources) [
    targetPlatform
    "universal"
  ];
  selectedPlatform =
    if candidates == [ ] then
      throw "mcu-debug.debug-tracker-vscode: no compatible source for ${system}"
    else
      builtins.foldl' (
        best: platform:
        if lib.versionOlder sources.${best}.version sources.${platform}.version then platform else best
      ) (builtins.head candidates) (builtins.tail candidates);
  source = sources.${selectedPlatform};
in
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "mcu-debug";
    name = "debug-tracker-vscode";
    inherit (source) version hash;
    arch = if selectedPlatform == "universal" then "" else selectedPlatform;
  };

  meta = with lib; {
    description = "This extension is an API extension to help other extension track debug sessions.";
    homepage = "https://github.com/mcu-debug/debug-tracker-vscode";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
