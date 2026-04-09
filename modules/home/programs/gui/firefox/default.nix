{ config, lib, ... }:
let
  isWm = config.desktop.hyprland.primary || config.desktop.niri.primary;
in
{
  programs.firefox = {
    enable = true;
    policies = import ./policies.nix;
    profiles = {
      default = {
        # choose a profile name; directory is /home/<user>/.mozilla/firefox/profile_0
        id = 0; # 0 is the default profile; see also option "isDefault"
        name = "default"; # name as listed in about:profiles
        isDefault = true; # can be omitted; true if profile ID is 0
        settings = import ./settings.nix { inherit lib isWm; };
        search = import ./search.nix;
        bookmarks = import ./bookmarks.nix;
      };
    };
  };
  home.file.".mozilla/firefox/default/chrome".source =
    if isWm then ./chrome/titlebar-buttons-disable else ./chrome/titlebar-buttons-enable;
}
