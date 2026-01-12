{ opts, ... }:
{
  services.openssh = {
    enable = opts.ssh.server.enable or false;
    ports = opts.ssh.server.ports or [ 22 ];
    authorizedKeysFiles = [ ] ++ (opts.ssh.server.authorizedKeysFiles or [ ]);
    settings = {
      PasswordAuthentication = opts.ssh.server.settings.PasswordAuthentication or false;
    };
  };
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;
          matchBlocks = { } // (opts.ssh.client.matchBlocks or { });
        };
        services.ssh-agent.enable = if config.services.gpg-agent.enableSshSupport then false else true;
      }
    )
  ];
}
