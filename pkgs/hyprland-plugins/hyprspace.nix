# https://github.com/KZDKM/Hyprspace
# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/window-managers/hyprwm/hyprland-plugins/hyprspace.nix
{
  lib,
  fetchFromGitHub,
  mkHyprlandPlugin,
  nix-update-script,
}:

mkHyprlandPlugin {
  pluginName = "hyprspace";
  version = "0-unstable-2026-01-08";

  src = fetchFromGitHub {
    owner = "KZDKM";
    repo = "hyprspace";
    rev = "bcd969224ffeb6266c6618c192949461135eef38";
    hash = "sha256-Gge7LY1lrPc2knDnyw8GBQ2sxRPzM7W2T6jNG1HY5bA=";
  };

  dontUseCmakeConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv Hyprspace.so $out/lib/libhyprspace.so

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    homepage = "https://github.com/KZDKM/Hyprspace";
    description = "Workspace overview plugin for Hyprland";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
