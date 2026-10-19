{ pkgs, lib }:
let
  sources = builtins.fromJSON (builtins.readFile ./sources.json);
  system = pkgs.stdenv.hostPlatform.system;
  targetPlatform =
    {
      x86_64-linux = "linux-x64";
      aarch64-linux = "linux-arm64";
    }
    .${system} or (throw "mcu-debug.memory-view: unsupported system ${system}");
  candidates = builtins.filter (platform: builtins.hasAttr platform sources) [
    targetPlatform
    "universal"
  ];
  selectedPlatform =
    if candidates == [ ] then
      throw "mcu-debug.memory-view: no compatible source for ${system}"
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
    name = "memory-view";
    inherit (source) version hash;
    arch = if selectedPlatform == "universal" then "" else selectedPlatform;
  };

  meta = with lib; {
    description = "This is a memory viewer extension specially built to work with debuggers.";
    homepage = "https://github.com/mcu-debug/memview";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
