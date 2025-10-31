{ opts, ... }:
{
  services.openssh = {
    enable = opts.ssh.daemon.enable or false;
    ports = opts.ssh.daemon.ports or [ 22 ];
    settings = opts.ssh.daemon.settings;
    authorizedKeysFiles = opts.ssh.daemon.authorizedKeysFiles;
  };
  home-manager.sharedModules = [
    (_: {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = opts.ssh.client.matchBlocks;
      };
      services.ssh-agent.enable =
        (opts.ssh.client.agent.enable or false) && !(opts.gpg.agent.enableSshSupport or false);
    })
  ];
}
