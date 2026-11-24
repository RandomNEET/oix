let
  mkEnv = key: value: {
    _args = [
      key
      value
    ];
  };
in
[
  (mkEnv "ELECTRON_OZONE_PLATFORM_HINT" "auto")
  (mkEnv "QT_QPA_PLATFORM" "wayland")
  (mkEnv "QT_QPA_PLATFORMTHEME" "qt6ct")
]
