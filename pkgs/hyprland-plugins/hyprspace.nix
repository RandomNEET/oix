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
  version = "0-unstable-2026-04-01";

  src = fetchFromGitHub {
    owner = "KZDKM";
    repo = "hyprspace";
    rev = "12ddde04f8584bf7de3151e6169918e0dda9f822";
    hash = "sha256-LXkeeH9Blr6ohS1LAsVZbkJ/EAkkMDATh5qu45hC7Zo=";
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
