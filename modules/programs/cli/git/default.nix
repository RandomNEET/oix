{ opts, ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.git = {
        enable = true;
        settings = opts.git.settings or { };
        includes = opts.git.includes or [ ];
      };
    })
  ];
}
