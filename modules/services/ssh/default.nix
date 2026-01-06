{ opts, ... }:
{
  services.openssh = {
    enable = opts.ssh.server.enable or false;
    ports = opts.ssh.server.ports or [ 22 ];
    authorizedKeysFiles = opts.ssh.server.authorizedKeysFiles or [ ];
    settings = {
      PasswordAuthentication = opts.ssh.server.settings.PasswordAuthentication or true;
    };
  };
  home-manager.sharedModules = [
    {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = opts.ssh.client.matchBlocks or { };
      };
      services.ssh-agent.enable =
        (opts.ssh.client.ssh-agent.enable or false) && !(opts.gpg.gpg-agent.enableSshSupport or false);
    }
  ];
}
