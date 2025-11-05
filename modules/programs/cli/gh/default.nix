{ opts, ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.gh = {
        enable = true;
        settings = {
          git_protocol = "ssh";
          prompt = "enabled";
          editor = opts.editor or "";
        };
      };
    })
  ];
}
