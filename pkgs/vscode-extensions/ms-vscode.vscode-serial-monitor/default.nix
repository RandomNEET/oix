{ pkgs, lib }:
let
  sources = builtins.fromJSON (builtins.readFile ./sources.json);
  system = pkgs.stdenv.hostPlatform.system;
  targetPlatform =
    {
      x86_64-linux = "linux-x64";
      aarch64-linux = "linux-arm64";
    }
    .${system} or (throw "ms-vscode.vscode-serial-monitor: unsupported system ${system}");
  candidates = builtins.filter (platform: builtins.hasAttr platform sources) [
    targetPlatform
    "universal"
  ];
  selectedPlatform =
    if candidates == [ ] then
      throw "ms-vscode.vscode-serial-monitor: no compatible source for ${system}"
    else
      builtins.foldl' (
        best: platform:
        if lib.versionOlder sources.${best}.version sources.${platform}.version then platform else best
      ) (builtins.head candidates) (builtins.tail candidates);
  source = sources.${selectedPlatform};
in
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-vscode";
    name = "vscode-serial-monitor";
    inherit (source) version hash;
    arch = if selectedPlatform == "universal" then "" else selectedPlatform;
  };

  meta = with lib; {
    description = "The Serial Monitor extension for Visual Studio Code provides a way to read from and write to serial ports.";
    homepage = "https://github.com/microsoft/vscode-serial-monitor";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
