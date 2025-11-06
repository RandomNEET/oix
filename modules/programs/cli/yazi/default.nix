{
  lib,
  pkgs,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    (_: {
      imports = [
        ./init.nix
        ./keymap.nix
      ]
      ++ lib.optional ((opts.theme or "") != "") ./themes/${opts.theme}.nix;

      programs.yazi =
        let
          displays = opts.display or [ ];
          primaryDisplay = lib.findFirst (d: d.orientation or "" == "landscape") { } displays;
        in
        {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
          settings = {
            mgr = {
              show_hidden = false;
              show_symlink = true;
              sort_dir_first = true;
              linemode = "size"; # or size, permissions, owner, mtime
              ratio = [
                # or 0 3 4
                1
                3
                4
              ];
            };
            preview = {
              # wrap = "yes";
              tab_size = 4;
              image_filter = "triangle"; # from fast to slow but high quality: nearest, triangle, catmull-rom, lanczos3
              max_width = primaryDisplay.width or 600;
              max_height = primaryDisplay.height or 900;
              image_quality = 90;
            };
            plugin = {
              repend_preloaders = [
                {
                  mime = "{audio,video,image}/*";
                  run = "mediainfo";
                }
                {
                  mime = "application/subrip";
                  run = "mediainfo";
                }
              ];
              prepend_previewers = [
                {
                  name = "*/";
                  run = ''piper -- eza -TL=3 --color=always --icons=always --group-directories-first --no-quotes "$1"'';
                }
                {
                  name = "*.tar*";
                  run = ''piper --format=url -- tar tf "$1"'';
                }
                {
                  name = "*.md";
                  run = ''piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark "$1"'';
                }
                {
                  mime = "{audio,video,image}/*";
                  run = "mediainfo";
                }
                {
                  mime = "application/subrip";
                  run = "mediainfo";
                }
              ];
            };
          };
          plugins = {
            piper = pkgs.yaziPlugins.piper;
            git = pkgs.yaziPlugins.git;
            diff = pkgs.yaziPlugins.diff;
            mediainfo = pkgs.yaziPlugins.mediainfo;
            lazygit = pkgs.yaziPlugins.lazygit;
            full-border = pkgs.yaziPlugins.full-border;
            yatline = pkgs.yaziPlugins.yatline;
            toggle-pane = pkgs.yaziPlugins.toggle-pane;
          };
        };

      home.packages = with pkgs; [
        mediainfo
        glow
      ];
    })
  ];
}
