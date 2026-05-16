let
  mkEnv = key: value: {
    _args = [
      key
      value
    ];
  };
in
[
  (mkEnv "LIBVA_DRIVER_NAME" "nvidia")
  (mkEnv "__GLX_VENDOR_LIBRARY_NAME" "nvidia")
  (mkEnv "ELECTRON_OZONE_PLATFORM_HINT" "auto")
  (mkEnv "XDG_CURRENT_DESKTOP" "Hyprland")
  (mkEnv "XDG_SESSION_DESKTOP" "Hyprland")
  (mkEnv "XDG_SESSION_TYPE" "wayland")
  (mkEnv "GDK_BACKEND" "wayland,x11,*")
  (mkEnv "NIXOS_OZONE_WL" "1")
  (mkEnv "MOZ_ENABLE_WAYLAND" "1")
  (mkEnv "OZONE_PLATFORM" "wayland")
  (mkEnv "EGL_PLATFORM" "wayland")
  (mkEnv "CLUTTER_BACKEND" "wayland")
  (mkEnv "SDL_VIDEODRIVER" "wayland")
  (mkEnv "QT_QPA_PLATFORM" "wayland;xcb")
  (mkEnv "QT_WAYLAND_DISABLE_WINDOWDECORATION" "1")
  (mkEnv "QT_QPA_PLATFORMTHEME" "qt6ct")
  (mkEnv "QT_AUTO_SCREEN_SCALE_FACTOR" "1")
  (mkEnv "WLR_RENDERER_ALLOW_SOFTWARE" "1")
  (mkEnv "NIXPKGS_ALLOW_UNFREE" "1")
  (mkEnv "NIXOS_XDG_OPEN_USE_PORTAL" "1")
]
