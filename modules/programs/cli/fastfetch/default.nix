{ ... }:
{
  home-manager.sharedModules = [
    (_: {
      home.file.".config/fastfetch/ascii".source = ./ascii;
      home.file.".config/fastfetch/fumo.jsonc".source = ./fumo.jsonc;
      home.file.".config/fastfetch/reimu.jsonc".source = ./reimu.jsonc;
      programs.fastfetch = {
        enable = true;
      };

      home.shellAliases = {
        fumofetch = "fastfetch -c ~/.config/fastfetch/fumo.jsonc";
        reimufetch = "fastfetch -c ~/.config/fastfetch/reimu.jsonc";
      };
    })
  ];
}
