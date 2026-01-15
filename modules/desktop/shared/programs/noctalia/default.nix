{
  inputs,
  config,
  lib,
  opts,
  pkgs,
  ...
}:
let
  inherit (lib) optional;
  display = opts.display or [ ];
  multiDisplay = builtins.length display > 1;
  hasExternalDisplay = builtins.any (d: d.external == true) display;
  powermodectl = import ../../scripts/powermodectl.nix {
    inherit
      config
      lib
      pkgs
      opts
      ;
  };
in
{
  home-manager.sharedModules = [
    (
      { osConfig, config, ... }:
      let
        themes = opts.themes or [ ];
        hasThemes = themes != [ ];
        colors = config.lib.stylix.colors;
        modifiers = [
          "dark"
          "light"
          "hard"
          "soft"
          "medium"
          "dim"
          "high"
          "low"
          "storm"
          "moon"
          "night"
          "latte"
          "frappe"
          "macchiato"
          "mocha"
          "pro"
          "soda"
          "classic"
          "reloaded"
          "alt"
          "alternate"
          "pale"
          "tints"
          "256"
        ];
        fullThemeName = lib.removeSuffix ".yaml" (builtins.baseNameOf config.stylix.base16Scheme);
        stripOnce = name: lib.foldl' (n: mod: lib.removeSuffix "-${mod}" n) name modifiers;
        stripAll =
          name:
          let
            nextName = stripOnce name;
          in
          if nextName == name then name else stripAll nextName;
        themeBaseName = stripAll fullThemeName;
        wallpaperDir =
          if ((opts.wallpaper.dir or "") != "") then
            if hasThemes then "${opts.wallpaper.dir}/${themeBaseName}" else opts.wallpaper.dir
          else
            "${config.xdg.userDirs.pictures}/wallpapers";
      in
      {
        imports = [ inputs.noctalia.homeModules.default ];

        programs.noctalia-shell = {
          enable = true;
          systemd.enable = true;
          settings = {
            settingsVersion = 0;
            bar = {
              position = "top";
              monitors = opts.noctalia.settings.bar.monitors or [ ];
              density = "default";
              showOutline = false;
              showCapsule = true;
              capsuleOpacity = 1;
              backgroundOpacity = 0.93;
              useSeparateOpacity = false;
              floating = false;
              marginVertical = 4;
              marginHorizontal = 4;
              outerCorners = true;
              exclusive = true;
              hideOnOverview = false;
              widgets = {
                left = [
                  {
                    id = "Workspace";
                    showApplications = false;
                  }
                  {
                    id = "ActiveWindow";
                    showIcon = true;
                  }
                  {
                    id = "MediaMini";
                    compactMode = false;
                    compactShowAlbumArt = true;
                    compactShowVisualizer = false;
                    hideMode = "hidden";
                    hideWhenIdle = true;
                    panelShowAlbumArt = true;
                    panelShowVisualizer = true;
                    scrollingMode = "always";
                    showAlbumArt = true;
                    showArtistFirst = true;
                    showProgressRing = true;
                    showVisualizer = true;
                    useFixedWidth = false;
                    visualizerType = "linear";
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
                    colorizeIcons = true;
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
              avatarImage = opts.noctalia.settings.general.avatarImage or "";
              dimmerOpacity = 0.2;
              showScreenCorners = false;
              forceBlackScreenCorners = false;
              scaleRatio = 1;
              radiusRatio = 1;
              iRadiusRatio = 1;
              boxRadiusRatio = 1;
              screenRadiusRatio = 1;
              animationSpeed = 1;
              animationDisabled = false;
              compactLockScreen = false;
              lockOnSuspend = true;
              showSessionButtonsOnLockScreen = true;
              showHibernateOnLockScreen = opts.hibernate or false;
              enableShadows = true;
              shadowDirection = "bottom_right";
              shadowOffsetX = 2;
              shadowOffsetY = 3;
              language = "";
              allowPanelsOnScreenWithoutBar = true;
              showChangelogOnStartup = false;
              telemetryEnabled = false;
            };
            ui = {
              fontDefault = config.stylix.fonts.monospace.name;
              fontFixed = config.stylix.fonts.monospace.name;
              fontDefaultScale = 1;
              fontFixedScale = 1;
              tooltipsEnabled = true;
              panelBackgroundOpacity = 0.93;
              panelsAttachedToBar = true;
              settingsPanelMode = "attached";
              wifiDetailsViewMode = "grid";
              bluetoothDetailsViewMode = "grid";
              networkPanelView = "wifi";
              bluetoothHideUnnamedDevices = false;
              boxBorderEnabled = false;
            };
            location = {
              name = "";
              weatherEnabled = true;
              useFahrenheit = false;
              weatherShowEffects = true;
              use12hourFormat = false;
              showWeekNumberInCalendar = false;
              showCalendarEvents = true;
              showCalendarWeather = true;
              analogClockInCalendar = false;
              firstDayOfWeek = -1;
              hideWeatherTimezone = false;
              hideWeatherCityName = true;
            };
            calendar = {
              cards = [
                {
                  enabled = true;
                  id = "calendar-header-card";
                }
                {
                  enabled = true;
                  id = "calendar-month-card";
                }
                {
                  enabled = true;
                  id = "weather-card";
                }
              ];
            };
            wallpaper = {
              enabled = true;
              overviewEnabled = false;
              directory = wallpaperDir;
              enableMultiMonitorDirectories = multiDisplay;
              monitorDirectories = map (d: {
                directory = "${wallpaperDir}/${d.orientation}";
                name = d.output;
                wallpaper = "";
              }) opts.display;
              recursiveSearch = true;
              setWallpaperOnAllMonitors = false;
              fillMode = "crop";
              fillColor = "#000000";
              useSolidColor = false;
              solidColor = colors.base00;
              randomEnabled = true;
              wallpaperChangeMode = "random";
              randomIntervalSec = 3600;
              transitionDuration = 1500;
              transitionType = "random";
              transitionEdgeSmoothness = 0.05;
              panelPosition = "follow_bar";
              hideWallpaperFilenames = false;
              useWallhaven = false;
              wallhavenQuery = "";
              wallhavenSorting = "relevance";
              wallhavenOrder = "desc";
              wallhavenCategories = "111";
              wallhavenPurity = "100";
              wallhavenRatios = "";
              wallhavenApiKey = "";
              wallhavenResolutionMode = "atleast";
              wallhavenResolutionWidth = "";
              wallhavenResolutionHeight = "";
            };
            appLauncher = {
              enableClipboardHistory = true;
              autoPasteClipboard = false;
              enableClipPreview = true;
              clipboardWrapText = true;
              position = "center";
              pinnedApps = [ ];
              useApp2Unit = true;
              sortByMostUsed = true;
              terminalCommand = "${opts.terminal} -e";
              customLaunchPrefixEnabled = false;
              customLaunchPrefix = "";
              viewMode = "list";
              showCategories = true;
              iconMode = "tabler";
              showIconBackground = false;
              ignoreMouseInput = false;
              screenshotAnnotationTool = "";
            };
            controlCenter = {
              position = "close_to_bar_button";
              diskPath = "/";
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
              cpuWarningThreshold = 80;
              cpuCriticalThreshold = 90;
              tempWarningThreshold = 80;
              tempCriticalThreshold = 90;
              gpuWarningThreshold = 80;
              gpuCriticalThreshold = 90;
              memWarningThreshold = 80;
              memCriticalThreshold = 90;
              diskWarningThreshold = 80;
              diskCriticalThreshold = 90;
              cpuPollingInterval = 3000;
              tempPollingInterval = 3000;
              gpuPollingInterval = 3000;
              enableDgpuMonitoring =
                if (!(lib.strings.hasInfix "integrated" (opts.gpu or ""))) then true else false;
              memPollingInterval = 3000;
              diskPollingInterval = 3000;
              networkPollingInterval = 3000;
              loadAvgPollingInterval = 3000;
              useCustomColors = false;
              warningColor = "";
              criticalColor = "";
              externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
            };
            dock = {
              enabled = true;
              position = "bottom";
              displayMode = "auto_hide";
              backgroundOpacity = 1;
              floatingRatio = 1;
              size = 1;
              onlySameOutput = true;
              monitors = [ ];
              pinnedApps = [ ];
              colorizeIcons = false;
              pinnedStatic = false;
              inactiveIndicators = false;
              deadOpacity = 0.6;
              animationSpeed = 1;
            };
            network = {
              wifiEnabled = true;
              bluetoothRssiPollingEnabled = false;
              bluetoothRssiPollIntervalMs = 10000;
              wifiDetailsViewMode = "grid";
              bluetoothDetailsViewMode = "grid";
              bluetoothHideUnnamedDevices = false;
            };
            sessionMenu = {
              enableCountdown = true;
              countdownDuration = 10000;
              position = "center";
              showHeader = true;
              largeButtonsStyle = false;
              largeButtonsLayout = "grid";
              showNumberLabels = true;
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
              enabled = true;
              monitors = [ ];
              location = "top_right";
              overlayLayer = true;
              backgroundOpacity = 1;
              respectExpireTimeout = false;
              lowUrgencyDuration = 3;
              normalUrgencyDuration = 8;
              criticalUrgencyDuration = 15;
              enableKeyboardLayoutToast = true;
              saveToHistory = {
                low = false;
                normal = true;
                critical = true;
              };
              sounds = {
                enabled = false;
                volume = 0.5;
                separateSounds = false;
                criticalSoundFile = "";
                normalSoundFile = "";
                lowSoundFile = "";
                excludedApps = "discord,qutebrowser,firefox,chrome,chromium,edge";
              };
            };
            osd = {
              enabled = true;
              location = "top_right";
              autoHideMs = 2000;
              overlayLayer = true;
              backgroundOpacity = 1;
              enabledTypes = [
                0
                1
                2
              ];
              monitors = [ ];
            };
            audio = {
              volumeStep = 5;
              volumeOverdrive = false;
              cavaFrameRate = 30;
              visualizerType = "linear";
              mprisBlacklist = [ ];
              preferredPlayer = "";
            };
            brightness = {
              brightnessStep = 5;
              enforceMinimum = true;
              enableDdcSupport = hasExternalDisplay;
            };
            colors = {
              mSurface = "#${colors.base00}";
              mSurfaceVariant = "#${colors.base01}";
              mHover = "#${colors.base02}";
              mOutline = "#${colors.base03}";
              mOnSurfaceVariant = "#${colors.base04}";
              mOnSurface = "#${colors.base05}";
              mTertiary = "#${colors.base06}";
              mOnHover = "#${colors.base07}";
              mError = "#${colors.base08}";
              mSecondary = "#${colors.base09}";
              mPrimary = "#${colors.base0A}";
              mOnPrimary = "#${colors.base00}";
              mOnSecondary = "#${colors.base00}";
              mOnTertiary = "#${colors.base00}";
              mOnError = "#${colors.base00}";
              mShadow = "#${colors.base0F}";
            };
            colorSchemes = {
              darkMode = true;
              predefinedScheme =
                if themeBaseName == "catppuccin" then
                  "Catppuccin"
                else if themeBaseName == "gruvbox" then
                  "Gruvbox"
                else if themeBaseName == "kanagawa" then
                  "Kanagawa"
                else if themeBaseName == "nord" then
                  "Nord"
                else
                  "Noctalia (default)";
              useWallpaperColors = false;
              schedulingMode = "off";
              manualSunrise = "06:30";
              manualSunset = "18:30";
              matugenSchemeType = "scheme-fruit-salad";
            };
            templates = {
              gtk = false;
              qt = false;
              kcolorscheme = false;
              alacritty = false;
              kitty = false;
              ghostty = false;
              foot = false;
              wezterm = false;
              fuzzel = false;
              discord = false;
              pywalfox = false;
              vicinae = false;
              walker = false;
              code = false;
              spicetify = false;
              telegram = false;
              cava = false;
              yazi = false;
              emacs = false;
              niri = false;
              hyprland = false;
              mango = false;
              zed = false;
              helix = false;
              zenBrowser = false;
              enableUserTemplates = false;
            };
            nightLight = {
              enabled = false;
              forced = false;
              autoSchedule = true;
              nightTemp = "4000";
              dayTemp = "6500";
              manualSunrise = "06:30";
              manualSunset = "18:30";
            };
            hooks = {
              enabled = true;
              wallpaperChange = "";
              darkModeChange = "";
              screenLock = "";
              screenUnlock = "";
              performanceModeEnabled = "";
              performanceModeDisabled = "";
              session = "${powermodectl} -s";
            };
            desktopWidgets = opts.noctalia.settings.desktopWidgets or { };
          };
          plugins = {
            sources = [
              {
                enabled = true;
                name = "Official Noctalia Plugins";
                url = "https://github.com/noctalia-dev/noctalia-plugins";
              }
            ];
            states = {
              catwalk = {
                enabled = true;
                sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
              };
            };
            # version = 1;
          };
          pluginSettings = {
            catwalk = {
              minimumThreshold = 25;
              hideBackground = true;
            };
          };
        };
      }
    )
  ];
  environment.systemPackages = [ ] ++ lib.optionals hasExternalDisplay [ pkgs.ddcutil ];
}
