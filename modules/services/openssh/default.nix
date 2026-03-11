{ opts, ... }:
{
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    ports = opts.ssh.ports or [ 22 ];
    authorizedKeysFiles = [ ] ++ (opts.openssh.authorizedKeysFiles or [ ]);
    settings = {
      PasswordAuthentication = opts.openssh.settings.PasswordAuthentication or false;
    };
  };
}
