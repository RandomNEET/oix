{ lib, opts, ... }:
{
  home-manager.sharedModules = [
    {
      programs.firefox = {
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
            extraConfig = "" + (opts.firefox.extraConfig or "");
          }
          // lib.optionalAttrs (opts.firefox.DisableFirefoxAccounts or true) {
            bookmarks = import ./bookmarks.nix;
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
