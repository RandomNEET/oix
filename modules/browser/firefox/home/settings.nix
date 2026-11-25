let
  lockFalse = {
    Value = false;
    Status = "locked";
  };
  lockTrue = {
    Value = true;
    Status = "locked";
  };
in
{
  # AI stuff
  "browser.ml.chat.enabled" = false;
  "browser.ml.chat.page" = false;
  "browser.ml.linkPreview.enabled" = false;
  "browser.tabs.groups.smart.enabled" = false;
  "browser.tabs.groups.smart.userEnabled" = false;
  "browser.translations.enable" = false;
  "extensions.ml.enabled" = false;
  "pdfjs.enableAltText" = false;
  "browser.ai.control.default" = "blocked";
  "browser.ai.control.linkPreviewKeyPoints" = "blocked";
  "browser.ai.control.pdfjsAltText" = "blocked";
  "browser.ai.control.sidebarChatbot" = "blocked";
  "browser.ai.control.smartTabGroups" = "blocked";
  "browser.ai.control.translations" = "blocked";

  # Userchrome
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
  "network.trr.mode" = 3; # 0 - Off (default), 1 - Reserved, 2 - First, 3 - Only
  "network.trr.uri" = "https://dns.alidns.com/dns-query";
  "network.trr.custom_uri" = "https://dns.alidns.com/dns-query";

  # Remove trackers
  "privacy.purge_trackers.enabled" = lockTrue;
  "privacy.trackingprotection.enabled" = lockTrue;
  "privacy.trackingprotection.fingerprinting.enabled" = lockTrue;
  "privacy.resistFingerprinting" = lockTrue;
  "privacy.trackingprotection.socialtracking.enabled" = lockTrue;
  "privacy.trackingprotection.cryptomining.enabled" = lockTrue;
  "privacy.globalprivacycontrol.enabled" = lockTrue;
  "privacy.globalprivacycontrol.functionality.enabled" = lockTrue;
  "privacy.donottrackheader.enabled" = lockTrue;
  "privacy.donottrackheader.value" = 1;
  "privacy.query_stripping.enabled" = lockTrue;
  "privacy.query_stripping.enabled.pbmode" = lockTrue;

  # Clear on shutdown (Only locks the options to true. Manually enable in firefox settings)
  "privacy.sanitize.sanitizeOnShutdown" = lockTrue;
  "privacy.clearOnShutdown.cache" = lockTrue;
  "privacy.clearOnShutdown.cookies" = lockTrue;
  "privacy.clearOnShutdown.downloads" = lockTrue;
  "privacy.clearOnShutdown.formdata" = lockTrue;
  "privacy.clearOnShutdown.history" = lockTrue;
  "privacy.clearOnShutdown.offlineApps" = lockTrue;
  "privacy.clearOnShutdown.sessions" = lockTrue;
  "privacy.clearOnShutdown.siteSettings" = lockTrue;

  # Block telemetry
  "toolkit.telemetry.enabled" = lockFalse;
  "toolkit.telemetry.unified" = lockFalse;
  "toolkit.telemetry.server" = "data:,";
  "toolkit.telemetry.archive.enabled" = lockFalse;
  "toolkit.telemetry.newProfilePing.enabled" = lockFalse;
  "toolkit.telemetry.shutdownPingSender.enabled" = lockFalse;
  "toolkit.telemetry.updatePing.enabled" = lockFalse;
  "toolkit.telemetry.bhrPing.enabled" = lockFalse;
  "toolkit.telemetry.coverage.opt-out" = lockTrue;
  "toolkit.telemetry.firstShutdownPing.enabled" = lockFalse;
  "browser.newtabpage.activity-stream.telemetry" = lockFalse;
  "browser.ping-centre.telemetry" = lockFalse;

  # Permissions
  # 0=always ask (default), 1=allow, 2=block
  "permissions.default.geo" = 2;
  "permissions.default.camera" = 2;
  "permissions.default.microphone" = 0;
  "permissions.default.desktop-notification" = 2;
  "permissions.default.xr" = 2; # Virtual Reality

  # Block more unwanted stuff
  "dom.block_multiple_popups" = lockTrue;
  "browser.privatebrowsing.forceMediaMemoryCache" = lockTrue;
  "browser.contentblocking.category" = {
    Value = "strict";
    Status = "locked";
  };
  "browser.search.suggest.enabled" = lockFalse;
  "browser.search.suggest.enabled.private" = lockFalse;
  "privacy.popups.disable_from_plugins" = 3;
  "extensions.pocket.enabled" = lockFalse;
  "browser.newtabpage.activity-stream.section.highlights.includePocket" = lockFalse;
  "browser.newtabpage.activity-stream.feeds.section.topstories" = lockFalse;
  "browser.newtabpage.activity-stream.feeds.topsites" = lockFalse;
  "browser.newtabpage.activity-stream.showSponsored" = lockFalse;
  "browser.newtabpage.activity-stream.showSponsoredTopSites" = lockFalse;
  "layout.word_select.eat_space_to_next_word" = lockFalse;
  "browser.shell.checkDefaultBrowser" = lockFalse;
  "signon.rememberSignons" = lockFalse;
  "toolkit.coverage.opt-out" = lockTrue;
  "toolkit.coverage.endpoint.base" = "";
  "experiments.supported" = lockFalse;
  "experiments.enabled" = lockFalse;
  "experiments.manifest.uri" = "";
  "datareporting.healthreport.uploadEnabled" = lockFalse;
  "datareporting.healthreport.service.enabled" = lockFalse;
  "datareporting.policy.dataSubmissionEnabled" = lockFalse;
  "breakpad.reportURL" = "";
  "browser.tabs.crashReporting.sendReport" = lockFalse;
  "browser.crashReports.unsubmittedCheck.autoSubmit2" = lockFalse;
  "browser.formfill.enable" = lockFalse;
  "extensions.formautofill.addresses.enabled" = lockFalse;
  "extensions.formautofill.available" = "off";
  "extensions.formautofill.creditCards.available" = lockFalse;
  "extensions.formautofill.creditCards.enabled" = lockFalse;
  "extensions.formautofill.heuristics.enabled" = lockFalse;
  "app.normandy.enabled" = lockFalse;
  "app.normandy.api_url" = "";
  "dom.webnotifications.enabled" = lockFalse;
  "dom.webnotifications.serviceworker.enabled" = lockFalse;

  # General settings
  "ui.key.accelKey" = 17; # Set CTRL as master key
  "browser.aboutConfig.showWarning" = lockFalse;
  "browser.aboutwelcome.enabled" = lockFalse;
  "browser.tabs.firefox-view" = lockFalse;
  "browser.startup.homepage_override.mstone" = "ignore";
  "trailhead.firstrun.didSeeAboutWelcome" = true; # Disable welcome splash
  "browser.newtab.url" = "about:blank";
  "browser.newtabpage.activity-stream.enabled" = lockFalse;
  "browser.newtabpage.enhanced" = lockFalse;
  "browser.newtabpage.introShown" = lockTrue;
  "browser.newtabpage.pinned" = false;
  "browser.bookmarks.defaultLocation" = "toolbar";
  "browser.startup.page" = 1; # 3 = restore sessions
  "media.autoplay.default" = 0; # 0 = allow all 1 = mute audio
  "app.shield.optoutstudies.enabled" = lockFalse;
  "dom.security.https_only_mode" = lockTrue;
  "dom.security.https_only_mode_ever_enabled" = lockTrue;
  "app.update.auto" = false;
  "browser.startup.homepage" = "about:home";
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
  "browser.urlbar.suggest.openpage" = false;
  "datareporting.policy.dataSubmissionEnable" = false;
  "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;

  "extensions.getAddons.showPane" = lockFalse;
  "extensions.htmlaboutaddons.recommendations.enabled" = lockFalse;
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
  "extensions.allowPrivateBrowsingByDefault" = lockTrue;
  "extensions.webextensions.restrictedDomains" = {
    Value = "";
    Status = "locked";
  };

  # Do not tell what plugins we have enabled: https://mail.mozilla.org/pipermail/firefox-dev/2013-November/001186.html
  "plugins.enumerable_names" = "";
  "plugin.state.flash" = 0;
  "browser.search.update" = false;
  "extensions.getAddons.cache.enabled" = lockFalse;
  "extensions.ui.sitepermission.hidden" = lockTrue;
  "extensions.ui.locale.hidden" = lockTrue;

  "browser.uiCustomization.state" = builtins.toJSON {
    currentVersion = 20;
    newElementCount = 7;
    placements = {
      widget-overflow-fixed-list = [ ];
      unified-extensions-area = [
        "_036a55b4-5e72-4d05-a06c-cba2dfcc134a_-browser-action" # TWP - Translate Web Pages
        "addon_darkreader_org-browser-action" # Dark Reader
        "ublock0_raymondhill_net-browser-action" # uBlock Origin
      ];
      nav-bar = [
        "back-button"
        "forward-button"
        "stop-reload-button"
        "urlbar-container"
        "downloads-button"
        "unified-extensions-button"
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
