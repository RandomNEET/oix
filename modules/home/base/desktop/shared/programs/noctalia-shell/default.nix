{
  inputs,
  osConfig,
  config,
  lib,
  pkgs,
  mylib,
  ...
}:
let
  inherit (lib) optional mkIf;
  colors = config.lib.stylix.colors.withHashtag;
  hasThemes = config.desktop.themes.enable;
  themeName = if hasThemes then mylib.theme.getBase16Scheme config.stylix.base16Scheme else "default";
  matchedPredefinedScheme =
    if hasThemes then
      if themeName == "ayu" then
        "Ayu"
      else if themeName == "catppuccin-mocha" then
        "Catppuccin"
      else if themeName == "dracula" then
        "Dracula"
      else if themeName == "eldritch" then
        "Eldritch"
      else if themeName == "gruvbox-dark-hard" then
        "Gruvbox"
      else if themeName == "kanagawa" then
        "Kanagawa"
      else if themeName == "nord" then
        "Nord"
      else if themeName == "rose-pine" then
        "Rose Pine"
      else if themeName == "tokyo-night-dark" then
        "Tokyo Night"
      else
        ""
    else
      "Noctalia (default)";

  hasWallpaper = config.desktop.wallpaper.enable;
  wallpaperDir =
    if hasThemes then
      "${config.desktop.wallpaper.dir}/themed/${themeName}"
    else
      config.desktop.wallpaper.dir;
  restore-wall-theme = import ./scripts/restore-wall-theme.nix { inherit config pkgs; };
in
{
  imports = [ inputs.noctalia.homeModules.default ];
  config = lib.mkIf config.desktop.enable {
    programs.noctalia-shell = {
      enable = true;
      package = pkgs.noctalia-shell;
      settings = {
        bar = {
          position = "top";
          widgets = {
            left = [
              {
                id = "Workspace";
              }
              {
                id = "Taskbar";
              }
              {
                id = "MediaMini";
                scrollingMode = "always";
                showArtistFirst = false;
                showVisualizer = true;
                maxWidth = 200;
              }
            ];
            center = [
              {
                id = "Clock";
                usePrimaryColor = true;
                formatHorizontal = "ddd MMM d HH:mm";
                formatVertical = "MM dd - HH mm";
                tooltipFormat = "yyyy-MM-dd HH:mm:ss";
              }
            ];
            right = [
              {
                id = "SystemMonitor";
                showGpuTemp = if !(lib.strings.hasInfix "integrated" osConfig.base.gpu) then true else false;
              }
              {
                id = "Network";
              }
              {
                id = "Bluetooth";
              }
              {
                id = "Brightness";
              }
              {
                id = "Volume";
              }
              {
                id = "Battery";
                hideIfNotDetected = true;
              }
              {
                id = "Tray";
                drawerEnabled = false;
              }
              {
                id = "NotificationHistory";
                showUnreadBadge = true;
              }
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
            ];
          };
        };
        general = {
          telemetryEnabled = false;
          keybinds = {
            keyUp = [
              "Ctrl+K"
              "Up"
            ];
            keyDown = [
              "Ctrl+J"
              "Down"
            ];
            keyLeft = [
              "Ctrl+H"
              "Left"
            ];
            keyRight = [
              "Ctrl+L"
              "Right"
            ];
            keyEnter = [
              "Return"
              "Enter"
            ];
            keyEscape = [ "Esc" ];
            keyRemove = [
              "Del"
              "Backspace"
            ];
          };
          # Lock Screen
          clockStyle = "digital";
          compactLockScreen = false;
          enableLockScreenCountdown = true;
          enableLockScreenMediaControls = false;
          lockOnSuspend = true;
          lockScreenAnimations = true;
          lockScreenBlur = 0.30;
          lockScreenCountdownDuration = 10000;
          lockScreenTint = 0.25;
          showHibernateOnLockScreen = config.desktop.hibernate;
          showSessionButtonsOnLockScreen = true;
        };
        ui = {
          fontDefault = mkIf hasThemes config.stylix.fonts.sansSerif.name;
          fontFixed = mkIf hasThemes config.stylix.fonts.monospace.name;
          panelBackgroundOpacity = 0.9;
        };
        location = {
          autoLocate = true;
          hideWeatherCityName = true;
          useFahrenheit = false;
          use12hourFormat = false;
        };
        wallpaper = {
          enabled = true;
          directory = wallpaperDir;
          monitorDirectories = mkIf (hasWallpaper && osConfig.base.display.info != [ ]) (
            map (d: {
              directory = "${wallpaperDir}/${d.orientation}";
              name = d.output;
              wallpaper = "";
            }) osConfig.base.display.info
          );
          enableMultiMonitorDirectories = true;
          showHiddenFiles = false;
          viewMode = "recursive";
          setWallpaperOnAllMonitors = false;
          fillMode = "crop";
          fillColor = "#000000";
          useSolidColor = !hasWallpaper;
          solidColor = if hasThemes then colors.base00 else "#1a1a2e";
          automationEnabled = true;
          wallpaperChangeMode = "random";
          randomIntervalSec = 3600;
          transitionDuration = 1500;
          transitionType = "random";
          transitionEdgeSmoothness = 0.05;
          panelPosition = "follow_bar";
          hideWallpaperFilenames = false;
          useWallhaven = false;
        };
        appLauncher = {
          enableClipboardHistory = true;
          terminalCommand =
            if ((config.defaultPrograms.terminal == "foot") && config.programs.foot.server.enable) then
              "footclient -e"
            else
              "${config.defaultPrograms.terminal} -e";
        };
        controlCenter = {
          shortcuts = {
            left = [
              {
                id = "Network";
              }
              {
                id = "Bluetooth";
              }
              {
                id = "PowerProfile";
              }
            ]
            ++ optional osConfig.services.dae.enable {
              id = "CustomButton";
              generalTooltipText = "Dae";
              onClicked = "sh -c 'if systemctl is-active --quiet dae.service; then pkexec systemctl stop dae.service; else pkexec systemctl start dae.service; fi'";
              icon = "shield-cancel";
              enableOnStateLogic = true;
              stateChecksJson = "[{\"command\":\"pgrep -x dae > /dev/null\",\"icon\":\"shield-check\"}]";
            }
            ++ optional osConfig.services.xray.enable {
              id = "CustomButton";
              generalTooltipText = "Xray";
              onClicked = "sh -c 'if systemctl is-active --quiet xray.service; then pkexec systemctl stop xray.service; else pkexec systemctl start xray.service; fi'";
              icon = "shield-cancel";
              enableOnStateLogic = true;
              stateChecksJson = "[{\"command\":\"pgrep -x xray > /dev/null\",\"icon\":\"shield-check\"}]";
            };
            right = [
              {
                id = "KeepAwake";
              }
              {
                id = "NightLight";
              }
              {
                id = "Notifications";
              }
              {
                id = "WallpaperSelector";
              }
            ];
          };
          cards = [
            {
              enabled = true;
              id = "profile-card";
            }
            {
              enabled = true;
              id = "shortcuts-card";
            }
            {
              enabled = true;
              id = "audio-card";
            }
            {
              enabled = true;
              id = "brightness-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
            {
              enabled = true;
              id = "media-sysmon-card";
            }
          ];
        };
        systemMonitor = {
          enableDgpuMonitoring =
            if !(lib.strings.hasInfix "integrated" osConfig.base.gpu) then true else false;
        };
        dock = {
          enabled = true;
          position = "bottom";
          dockType = "attached";
        };
        network = {
          wifiEnabled = true;
          airplaneModeEnabled = false;
          bluetoothRssiPollingEnabled = false;
          disableDiscoverability = false;
        };
        sessionMenu = {
          powerOptions = [
            {
              action = "lock";
              enabled = true;
              countdownEnabled = true;
              keybind = "1";
            }
            {
              action = if (osConfig.desktop.hibernate or false) then "hibernate" else "suspend";
              enabled = true;
              countdownEnabled = true;
              keybind = "2";
            }
            {
              action = "reboot";
              enabled = true;
              countdownEnabled = true;
              keybind = "3";
            }
            {
              action = "logout";
              enabled = true;
              countdownEnabled = true;
              keybind = "4";
            }
            {
              action = "shutdown";
              enabled = true;
              countdownEnabled = true;
              keybind = "5";
            }
          ];
        };
        notifications = {
          saveToHistory = {
            low = false;
            normal = true;
            critical = true;
          };
          sounds = {
            enabled = false;
          };
        };
        colorSchemes = {
          darkMode = true;
          predefinedScheme = matchedPredefinedScheme;
          useWallpaperColors = false;
        };
        brightness = {
          enableDdcSupport = osConfig.base.display.ddcutil.enable;
        };
        hooks = {
          enabled = true;
          session = lib.mkIf (hasWallpaper && hasThemes) "${restore-wall-theme}";
        };
        idle = rec {
          enabled = true;
          lockTimeout = 600;
          screenOffTimeout = 1800 - lockTimeout;
          suspendTimeout = 3600 - lockTimeout;
          fadeDuration = 5;
        };
      };
      colors = mkIf (matchedPredefinedScheme == "") {
        mPrimary = colors.base05;
        mOnPrimary = colors.base00;
        mSecondary = colors.base05;
        mOnSecondary = colors.base00;
        mTertiary = colors.base04;
        mOnTertiary = colors.base00;
        mError = colors.base08;
        mOnError = colors.base00;
        mSurface = colors.base00;
        mOnSurface = colors.base05;
        mHover = colors.base04;
        mOnHover = colors.base00;
        mSurfaceVariant = colors.base01;
        mOnSurfaceVariant = colors.base04;
        mOutline = colors.base02;
        mShadow = colors.base00;
      };
    };
  };
}
