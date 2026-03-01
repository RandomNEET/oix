{
  inputs,
  lib,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    {
      programs = {
        firefox = {
          enable = true;
          policies = import ./policies.nix { inherit opts; };
          profiles = {
            default = {
              # choose a profile name; directory is /home/<user>/.mozilla/firefox/profile_0
              id = 0; # 0 is the default profile; see also option "isDefault"
              name = "default"; # name as listed in about:profiles
              isDefault = true; # can be omitted; true if profile ID is 0
              settings = import ./settings.nix { inherit lib opts; };
              search = import ./search.nix;
              extraConfig = ''
                lockPref("extensions.activeThemeID", "{76aabc99-c1a8-4c1e-832b-d4f2941d5a7a}");
                lockPref("extensions.formautofill.addresses.enabled", false);
                lockPref("extensions.formautofill.creditCards.enabled", false);
                lockPref("dom.security.https_only_mode_pbm", true);
                lockPref("dom.security.https_only_mode_error_page_user_suggestions", true);
                lockPref("browser.firefox-view.feature-tour", "{\"screen\":\"\",\"complete\":true}");
                lockPref("identity.fxaccounts.enabled", ${
                  if (opts.firefox.DisableFirefoxAccounts or true) then "false" else "true"
                });
                lockPref("browser.tabs.firefox-view-next", false);
                lockPref("privacy.sanitize.sanitizeOnShutdown", false);
                lockPref("privacy.clearOnShutdown.cache", true);
                lockPref("privacy.clearOnShutdown.cookies", false);
                lockPref("privacy.clearOnShutdown.offlineApps", false);
                lockPref("browser.sessionstore.privacy_level", 0);
                lockPref("floorp.browser.sidebar.enable", false);
                lockPref("geo.enabled", false);
                lockPref("media.navigator.enabled", false);
                lockPref("dom.event.clipboardevents.enabled", false);
                lockPref("dom.event.contextmenu.enabled", false);
                lockPref("dom.battery.enabled", false);
                lockPref("extensions.enabledScopes", 15);
                lockPref("extensions.autoDisableScopes", 0);
                lockPref("browser.newtabpage.activity-stream.floorp.newtab.imagecredit.hide", true);
                lockPref("browser.newtabpage.activity-stream.floorp.newtab.releasenote.hide", true);
                lockPref("browser.search.separatePrivateDefault", true);
              '';
            }
            // lib.optionalAttrs (opts.firefox.DisableFirefoxAccounts or true) {
              bookmarks = import ./bookmarks.nix;
            };
          };
        };
      };
      # whether disable titlebar buttons for wm
      home.file.".mozilla/firefox/default/chrome".source =
        if (opts.firefox.titlebar-buttons-disable or false) then
          ./chrome/titlebar-buttons-disable
        else
          ./chrome/titlebar-buttons-enable;
    }
  ];
}
