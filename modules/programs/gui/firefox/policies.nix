{ lib, opts, ... }:
{
  AllowFileSelectionDialogs = true;
  AppAutoUpdate = false;
  AutofillAddressEnabled = false;
  AutofillCreditCardEnabled = false;
  #AutoLaunchProtocolsFromOrigins = { };
  BackgroundAppUpdate = false;
  BlockAboutAddons = false;
  BlockAboutConfig = false;
  BlockAboutProfiles = false;
  BlockAboutSupport = false;
  #Containers = { };
  DisableAppUpdate = true;
  DisableFirefoxAccounts = opts.firefox.DisableFirefoxAccounts or true;
  DisableFirefoxScreenshots = false;
  DisableFirefoxStudies = true;
  DisableFormHistory = true;
  DisableMasterPasswordCreation = true;
  DisablePocket = true;
  DisablePrivateBrowsing = false;
  DisableProfileImport = false;
  DisableProfileRefresh = false;
  DisableSafeMode = false;
  DisableTelemetry = true;
  DisableFeedbackCommands = true;
  DontCheckDefaultBrowser = true;
  DNSOverHTTPS = {
    Enabled = true;
  };
  EnableTrackingProtection = {
    Value = true;
    Locked = true;
    Cryptomining = true;
    Fingerprinting = true;
  };
  EncryptedMediaExtensions = {
    Enabled = true;
  };
  ExtensionUpdate = true;
  FirefoxHome = {
    Search = false;
    TopSites = false;
    SponsoredTopSites = false;
    Highlights = false;
    Pocket = false;
    SponsoredPocket = false;
    Snippets = false;
    Locked = false;
  };
  HardwareAcceleration = true;
  ManualAppUpdateOnly = true;
  NoDefaultBookmarks = opts.firefox.DisableFirefoxAccounts or false;
  OfferToSaveLogins = false;
  PasswordManagerEnabled = false;
  PictureInPicture = {
    Enabled = true;
  };
  PopupBlocking = {
    Allow = [ ];
    Default = true;
  };
  Preferences = {
    "browser.tabs.warnOnClose" = {
      Value = false;
    };
  };
  PromptForDownloadLocation = true;
  SearchSuggestEnabled = false;
  ShowHomeButton = false;
  StartDownloadsInTempDirectory = false;
  UserMessaging = {
    ExtensionRecommendations = false;
    SkipOnboarding = true;
  };
  # ---- EXTENSIONS ----
  ExtensionSettings = {
    "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
    # Tridactyl
    "tridactyl.vim@cmcaine.co.uk" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/tridactyl-vim/latest.xpi";
      installation_mode = "force_installed";
      private_browsing = true;
    };
    # uBlock Origin
    "uBlock0@raymondhill.net" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      installation_mode = "force_installed";
      private_browsing = true;
    };
    # TWP - Translate Web Pages
    "{036a55b4-5e72-4d05-a06c-cba2dfcc134a}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/traduzir-paginas-web/latest.xpi";
      installation_mode = "force_installed";
      private_browsing = true;
    };
    # Dark Reader
    "addon@darkreader.org" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
      installation_mode = "force_installed";
      private_browsing = true;
    };
    # Stylus
    "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/styl-us/latest.xpi";
      installation_mode = "force_installed";
      private_browsing = true;
    };
    # Bitwarden Password Manager
    "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
      installation_mode = "force_installed";
      private_browsing = true;
    };
    # linkding extension
    "{61a05c39-ad45-4086-946f-32adb0a40a9d}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/linkding-extension/latest.xpi";
      installation_mode = "force_installed";
      private_browsing = true;
    };
    # New Tab Override
    "newtaboverride@agenedia.com" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/new-tab-override/latest.xpi";
      installation_mode = "force_installed";
      private_browsing = true;
    };
  }
  // lib.optionalAttrs ((opts.theme or "") == "catppuccin-mocha") {
    # Catppuccin Mocha - Mauve, only included if theme matches
    "{76aabc99-c1a8-4c1e-832b-d4f2941d5a7a}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/catppuccin-mocha-mauve-git/latest.xpi";
      installation_mode = "force_installed";
      private_browsing = true;
    };
  };
}
