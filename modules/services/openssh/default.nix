{ opts, ... }:
{
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    ports = opts.ssh.ports or [ 22 ];
    authorizedKeysFiles = [ ] ++ (opts.openssh.authorizedKeysFiles or [ ]);
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    }
    // (opts.openssh.settings or { });
  };
}
