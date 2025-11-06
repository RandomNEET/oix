{
  lib,
  pkgs,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    (_: {
      programs.thunderbird = {
        enable = true;
        package = pkgs.thunderbird.override {
          extraPolicies.ExtensionSettings = import ./extensions.nix { inherit lib opts; };
        };
        profiles = {
          default = {
            isDefault = true;
            search = {
              force = true;
              default = "ddg";
              privateDefault = "ddg";
            };
            settings = {
              "app.donation.eoy.version.viewed" = 999;
              "mailnews.start_page.enabled" = false;
              "font.name.sans-serif.x-western" = "JetBrainsMono Nerd Font";

              # TELEMETRY
              "datareporting.policy.dataSubmissionEnabled" = false;
              "datareporting.policy.dataSubmissionPolicyBypassNotification" = true;
              "datareporting.healthreport.uploadEnabled" = false;
              "toolkit.telemetry.unified" = false;
              "toolkit.telemetry.enabled" = false;
              "toolkit.telemetry.server" = "data:,";
              "toolkit.telemetry.archive.enabled" = false;
              "toolkit.telemetry.newProfilePing.enabled" = false;
              "toolkit.telemetry.shutdownPingSender.enabled" = false;
              "toolkit.telemetry.updatePing.enabled" = false;
              "toolkit.telemetry.bhrPing.enabled" = false;
              "toolkit.telemetry.firstShutdownPing.enabled" = false;
              "toolkit.telemetry.coverage.opt-out" = true;
              "toolkit.coverage.opt-out" = true;
              "toolkit.coverage.endpoint.base" = "";

              # STUDIES
              "app.shield.optoutstudies.enabled" = false;
              "app.normandy.enabled" = false;
              "app.normandy.api_url" = "";

              # PASSWORDS
              "signon.autofillForms" = false;
              "signon.formlessCapture.enabled" = false;
              "network.auth.subresource-http-auth-allow" = 1;

              # DOWNLOADS
              "browser.download.useDownloadDir" = false;
              "browser.download.manager.addToRecentDocs" = false;
              "browser.download.always_ask_before_handling_new_types" = true;
            };
          };
        };
      };
    })
  ];
}
