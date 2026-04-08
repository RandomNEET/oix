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
        settings = import ./settings.nix;
        search = import ./search.nix;
        bookmarks = import ./bookmarks.nix;
      };
    };
  };
  # whether disable titlebar buttons for wm
  home.file.".mozilla/firefox/default/chrome".source = ./chrome/titlebar-buttons-disable;
}
