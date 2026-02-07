{
  inputs,
  lib,
  pkgs,
  mylib,
  opts,
  ...
}:
let
  inherit (lib) optional mkIf;
  display = opts.display or [ ];
  hasMultiDisplay = builtins.length display > 1;
  hasExternalDisplay = builtins.any (d: d.external == true) display;
in
{
  home-manager.sharedModules = [
    (
      { osConfig, config, ... }:
      let
        themes = opts.themes or [ ];
        hasThemes = themes != [ ];
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

        wallpaperDir =
          if ((opts.wallpaper.dir or "") != "") then
            if hasThemes then "${opts.wallpaper.dir}/${themeName}" else opts.wallpaper.dir
          else
            "";
        hasWallpaper = wallpaperDir != "";
        restore-wall-theme = import ./scripts/restore-wall-theme.nix { inherit config pkgs opts; };

        colors = config.lib.stylix.colors.withHashtag;
      in
      {
        imports = [ inputs.noctalia.homeModules.default ];

        programs.noctalia-shell = {
          enable = true;
          package = pkgs.noctalia-shell;
          systemd.enable = true;
          settings = {
            bar = {
              position = "top";
              monitors = opts.noctalia.settings.bar.monitors or [ ];
              widgets = {
                left = [
                  {
                    id = "Workspace";
                  }
                  {
                    id = "ActiveWindow";
                    showIcon = true;
                  }
                  {
                    id = "MediaMini";
                    scrollingMode = "always";
                    showArtistFirst = false;
                    showVisualizer = true;
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
                    showGpuTemp = if (!(lib.strings.hasInfix "integrated" (opts.gpu or ""))) then true else false;
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
              }
              // opts.noctalia.settings.bar.widgets or { };
              screenOverrides = opts.noctalia.settings.bar.screenOverrides or [ ];
            };
            general = {
              avatarImage = opts.noctalia.settings.general.avatarImage or "";
              showHibernateOnLockScreen = opts.hibernate or false;
              telemetryEnabled = false;
              enableLockScreenCountdown = true;
              lockScreenCountdownDuration = 10000;
            };
            ui = {
              fontDefault = mkIf hasThemes config.stylix.fonts.sansSerif.name;
              fontFixed = mkIf hasThemes config.stylix.fonts.monospace.name;
            };
            location = {
              name = opts.noctalia.settings.location.name or "";
              hideWeatherCityName = true;
            };
            wallpaper = {
              enabled = true;
              directory = wallpaperDir;
              monitorDirectories = mkIf (hasWallpaper && hasMultiDisplay) (
                map (d: {
                  directory = "${wallpaperDir}/${d.orientation}";
                  name = d.output;
                  wallpaper = "";
                }) opts.display
              );
              enableMultiMonitorDirectories = hasMultiDisplay;
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
              useApp2Unit = true;
              terminalCommand =
                if opts ? terminal then
                  if ((opts.terminal == "foot") && (opts.foot.server or false)) then
                    "footclient -e"
                  else
                    "${opts.terminal} -e"
                else
                  "xterm -e";
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
                  onClicked = "systemctl is-active --quiet dae.service && pkexec systemctl stop dae.service || pkexec systemctl start dae.service";
                  generalTooltipText = "Proxy";
                  icon = "shield-cancel";
                  enableOnStateLogic = true;
                  stateChecksJson = "[{\"command\":\"pgrep -x dae > /dev/null\",\"icon\":\"shield-check\"}]";
                }
                ++ optional osConfig.services.sing-box.enable {
                  id = "CustomButton";
                  onClicked = "systemctl is-active --quiet sing-box.service && pkexec systemctl stop sing-box.service || pkexec systemctl start sing-box.service";
                  generalTooltipText = "Proxy";
                  icon = "shield-cancel";
                  enableOnStateLogic = true;
                  stateChecksJson = "[{\"command\":\"pgrep -x sing-box > /dev/null\",\"icon\":\"shield-check\"}]";
                }
                ++ optional osConfig.services.xray.enable {
                  id = "CustomButton";
                  onClicked = "systemctl is-active --quiet xray.service && pkexec systemctl stop xray.service || pkexec systemctl start xray.service";
                  generalTooltipText = "Proxy";
                  icon = "shield-cancel";
                  enableOnStateLogic = true;
                  stateChecksJson = "[{\"command\":\"pgrep -x xray > /dev/null\",\"icon\":\"shield-check\"}]";
                };
                right = [
                  {
                    id = "Notifications";
                  }
                  {
                    id = "KeepAwake";
                  }
                  {
                    id = "NightLight";
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
                if (!(lib.strings.hasInfix "integrated" (opts.gpu or ""))) then true else false;
            };
            sessionMenu = {
              powerOptions = [
                {
                  action = "lock";
                  enabled = true;
                }
                {
                  action = "suspend";
                  enabled = true;
                }
                {
                  action = "hibernate";
                  enabled = opts.hibernate or false;
                }
                {
                  action = "reboot";
                  enabled = true;
                }
                {
                  action = "logout";
                  enabled = true;
                }
                {
                  action = "shutdown";
                  enabled = true;
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
            brightness = {
              enableDdcSupport = hasExternalDisplay;
            };
            colorSchemes = {
              darkMode = true;
              predefinedScheme = matchedPredefinedScheme;
              useWallpaperColors = false;
            };
            hooks = {
              enabled = true;
              session = lib.mkIf hasThemes "${restore-wall-theme}";
            };
            desktopWidgets = opts.noctalia.settings.desktopWidgets or { };
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
      }
    )
  ];
  environment.systemPackages = [ ] ++ lib.optionals hasExternalDisplay [ pkgs.ddcutil ];
}
