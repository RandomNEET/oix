{
  home-manager.sharedModules = [
    {
      programs.fastfetch = {
        enable = true;
      };
      home = {
        file = {
          ".config/fastfetch/ascii".source = ./ascii;
          ".config/fastfetch/fumo.jsonc".source = ./fumo.jsonc;
          ".config/fastfetch/reimu.jsonc".source = ./reimu.jsonc;
        };
        shellAliases = {
          fumofetch = "fastfetch -c ~/.config/fastfetch/fumo.jsonc";
          reimufetch = "fastfetch -c ~/.config/fastfetch/reimu.jsonc";
        };
      };
    }
  ];
}
