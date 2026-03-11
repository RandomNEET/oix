{ opts, ... }:
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;
          matchBlocks = { } // (opts.ssh.matchBlocks or { });
        };
        services.ssh-agent.enable = !config.services.gpg-agent.enableSshSupport;
      }
    )
  ];
}
