{ lib, opts, ... }:
let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in
{
  # enable custom userchrome
  "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  "svg.context-properties.content.enabled" = true;
  "layout.css.color-mix.enabled" = true;
  "browser.display.background_color" = "#eee";
  "browser.display.background_color.dark" = "#222";
  "browser.tabs.searchclipboardfor.middleclick " = false;
  "toolkit.tabbox.switchByScrolling" = true;
  "browser.tabs.groups.enabled" = true;
  "browser.tabs.delayHidingAudioPlayingIconMS" = 0;
  "layout.css.backdrop-filter.enabled" = true;
  "browser.newtabpage.activity-stream.improvesearch.handoffToAwesomebar" = false;
  "privacy.userContext.enabled" = true;
  "privacy.userContext.ui.enabled" = true;
  "privacy.userContext.longPressBehavior" = 2;

  # Performance settings
  "gfx.webrender.all" = true; # Force enable GPU acceleration
  "media.ffmpeg.vaapi.enabled" = true;
  "widget.dmabuf.force-enabled" = true; # Required in recent Firefoxes
  "reader.parse-on-load.force-enabled" = true;
  "privacy.webrtc.legacyGlobalIndicator" = false;

  # Use cloudflare for better security/privacy
  "network.trr.mode" = opts.firefox.network.trr.mode or 3; # 0 - Off (default), 1 - Reserved, 2 - First, 3 - Only
  "network.trr.uri" = opts.firefox.network.trr.uri or "https://cloudflare-dns.com/dns-query";
  "network.trr.custom_uri" =
    opts.firefox.network.trr.custom_uri or "https://cloudflare-dns.com/dns-query";

  # Remove trackers
  "privacy.purge_trackers.enabled" = lock-true;
  "privacy.trackingprotection.enabled" = lock-true;
  "privacy.trackingprotection.fingerprinting.enabled" = lock-true;
  "privacy.resistFingerprinting" = lock-true;
  "privacy.trackingprotection.socialtracking.enabled" = lock-true;
  "privacy.trackingprotection.cryptomining.enabled" = lock-true;
  "privacy.globalprivacycontrol.enabled" = lock-true;
  "privacy.globalprivacycontrol.functionality.enabled" = lock-true;
  "privacy.donottrackheader.enabled" = lock-true;
  "privacy.donottrackheader.value" = 1;
  "privacy.query_stripping.enabled" = lock-true;
  "privacy.query_stripping.enabled.pbmode" = lock-true;

  # Clear on shutdown (Only locks the options to true. Manually enable in firefox settings)
  "privacy.sanitize.sanitizeOnShutdown" = lock-true;
  "privacy.clearOnShutdown.cache" = lock-true;
  "privacy.clearOnShutdown.cookies" = lock-true;
  "privacy.clearOnShutdown.downloads" = lock-true;
  "privacy.clearOnShutdown.formdata" = lock-true;
  "privacy.clearOnShutdown.history" = lock-true;
  "privacy.clearOnShutdown.offlineApps" = lock-true;
  "privacy.clearOnShutdown.sessions" = lock-true;
  "privacy.clearOnShutdown.siteSettings" = lock-true;

  # Block telemetry
  "toolkit.telemetry.enabled" = lock-false;
  "toolkit.telemetry.unified" = lock-false;
  "toolkit.telemetry.server" = "data:,";
  "toolkit.telemetry.archive.enabled" = lock-false;
  "toolkit.telemetry.newProfilePing.enabled" = lock-false;
  "toolkit.telemetry.shutdownPingSender.enabled" = lock-false;
  "toolkit.telemetry.updatePing.enabled" = lock-false;
  "toolkit.telemetry.bhrPing.enabled" = lock-false;
  "toolkit.telemetry.coverage.opt-out" = lock-true;
  "toolkit.telemetry.firstShutdownPing.enabled" = lock-false;
  "browser.newtabpage.activity-stream.telemetry" = lock-false;
  "browser.ping-centre.telemetry" = lock-false;

  # Permissions
  # 0=always ask (default), 1=allow, 2=block
  "permissions.default.geo" = 2;
  "permissions.default.camera" = 2;
  "permissions.default.microphone" = 0;
  "permissions.default.desktop-notification" = 2;
  "permissions.default.xr" = 2; # Virtual Reality

  # Block more unwanted stuff
  "dom.block_multiple_popups" = lock-true;
  "browser.privatebrowsing.forceMediaMemoryCache" = lock-true;
  "browser.contentblocking.category" = {
    Value = "strict";
    Status = "locked";
  };
  "browser.search.suggest.enabled" = lock-false;
  "browser.search.suggest.enabled.private" = lock-false;
  "privacy.popups.disable_from_plugins" = 3;
  "extensions.pocket.enabled" = lock-false;
  "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
  "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
  "browser.newtabpage.activity-stream.feeds.topsites" = lock-false;
  "browser.newtabpage.activity-stream.showSponsored" = lock-false;
  "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
  "layout.word_select.eat_space_to_next_word" = lock-false;
  "browser.shell.checkDefaultBrowser" = lock-false;
  "signon.rememberSignons" = lock-false;
  "toolkit.coverage.opt-out" = lock-true;
  "toolkit.coverage.endpoint.base" = "";
  "experiments.supported" = lock-false;
  "experiments.enabled" = lock-false;
  "experiments.manifest.uri" = "";
  "datareporting.healthreport.uploadEnabled" = lock-false;
  "datareporting.healthreport.service.enabled" = lock-false;
  "datareporting.policy.dataSubmissionEnabled" = lock-false;
  "breakpad.reportURL" = "";
  "browser.tabs.crashReporting.sendReport" = lock-false;
  "browser.crashReports.unsubmittedCheck.autoSubmit2" = lock-false;
  "browser.formfill.enable" = lock-false;
  "extensions.formautofill.addresses.enabled" = lock-false;
  "extensions.formautofill.available" = "off";
  "extensions.formautofill.creditCards.available" = lock-false;
  "extensions.formautofill.creditCards.enabled" = lock-false;
  "extensions.formautofill.heuristics.enabled" = lock-false;
  "app.normandy.enabled" = lock-false;
  "app.normandy.api_url" = "";
  "dom.webnotifications.enabled" = lock-false;
  "dom.webnotifications.serviceworker.enabled" = lock-false;

  # General settings
  "ui.key.accelKey" = 17; # Set CTRL as master key
  "browser.aboutConfig.showWarning" = lock-false;
  "browser.aboutwelcome.enabled" = lock-false;
  "browser.tabs.firefox-view" = lock-false;
  "browser.startup.homepage_override.mstone" = "ignore";
  "trailhead.firstrun.didSeeAboutWelcome" = true; # Disable welcome splash
  "browser.newtab.url" = "about:blank";
  "browser.newtabpage.activity-stream.enabled" = lock-false;
  "browser.newtabpage.enhanced" = lock-false;
  "browser.newtabpage.introShown" = lock-true;
  "browser.newtabpage.pinned" = false;
  "browser.bookmarks.defaultLocation" = "toolbar";
  "browser.startup.page" = 1; # 3 = restore sessions
  "media.autoplay.default" = 0; # 0 = allow all 1 = mute audio
  "app.shield.optoutstudies.enabled" = lock-false;
  "dom.security.https_only_mode" = lock-true;
  "dom.security.https_only_mode_ever_enabled" = lock-true;
  "app.update.auto" = false;
  "browser.startup.homepage" = opts.firefox.browser.startup.homepage or "about:home";
  "browser.bookmarks.restore_default_bookmarks" = false;
  "browser.ctrlTab.recentlyUsedOrder" = false;
  "browser.discovery.enabled" = false;
  "browser.laterrun.enabled" = false;
  "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
  "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
  "browser.newtabpage.activity-stream.feeds.snippets" = false;
  "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "";
  "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" = "";
  "browser.protections_panel.infoMessage.seen" = true;
  "browser.ssb.enabled" = true;
  "browser.toolbars.bookmarks.visibility" = "never"; # always, never, newtab
  #"browser.urlbar.placeholderName" = "google";
  "browser.urlbar.suggest.openpage" = false;
  "datareporting.policy.dataSubmissionEnable" = false;
  "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;

  "extensions.getAddons.showPane" = lock-false;
  "extensions.htmlaboutaddons.recommendations.enabled" = lock-false;
  "extensions.extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
  # "extensions.update.enabled" = false;
  "extensions.webcompat.enable_picture_in_picture_overrides" = true;
  "extensions.webcompat.enable_shims" = true;
  "extensions.webcompat.perform_injections" = true;
  "extensions.webcompat.perform_ua_overrides" = true;

  "extensions.autoDisableScopes" = {
    Value = 0;
    Status = "locked";
  };
  "extensions.enabledScopes" = {
    Value = 15;
    Status = "locked";
  };
  "extensions.allowPrivateBrowsingByDefault" = lock-true;
  "extensions.webextensions.restrictedDomains" = {
    Value = "";
    Status = "locked";
  };

  # Do not tell what plugins we have enabled: https://mail.mozilla.org/pipermail/firefox-dev/2013-November/001186.html
  "plugins.enumerable_names" = "";
  "plugin.state.flash" = 0;
  "browser.search.update" = false;
  "extensions.getAddons.cache.enabled" = lock-false;
  "extensions.ui.sitepermission.hidden" = lock-true;
  "extensions.ui.locale.hidden" = lock-true;

  "browser.uiCustomization.state" = builtins.toJSON {
    currentVersion = 20;
    newElementCount = 7;
    placements = {
      widget-overflow-fixed-list = [ ];
      unified-extensions-area = [
        "_61a05c39-ad45-4086-946f-32adb0a40a9d_-browser-action"
        "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
        "_036a55b4-5e72-4d05-a06c-cba2dfcc134a_-browser-action"
        "addon_darkreader_org-browser-action"
        "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action"
        "ublock0_raymondhill_net-browser-action"
        "newtaboverride_agenedia_com-browser-action"
      ];
      nav-bar = [
        "back-button"
        "forward-button"
        "stop-reload-button"
        "urlbar-container"
        # "developer-button"
        "downloads-button"
        "unified-extensions-button"

        # Extensions
        # "ublock0_raymondhill_net-browser-action"
        # "addon_darkreader_org-browser-action"
      ];
      toolbar-menubar = [ "menubar-items" ];
      TabsToolbar = [
        "firefox-view-button"
        "tabbrowser-tabs"
        "new-tab-button"
        "alltabs-button"
      ];
      PersonalToolbar = [
        "personal-bookmarks"
        "managed-bookmarks"
      ];
    };
  };
}
// lib.optionalAttrs (opts.firefox.full-screen-api.ignore-widgets or false) {
  "full-screen-api.ignore-widgets" = true;
}
