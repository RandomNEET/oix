{ opts, ... }:
{
  services.openssh = {
    enable = opts.ssh.server.enable or false;
    ports = opts.ssh.server.ports or [ 22 ];
    authorizedKeysFiles = opts.ssh.server.authorizedKeysFiles or [ ];
    settings = {
      AllowGroups = opts.ssh.server.settings.AllowGroups or null;
      AllowUsers = opts.ssh.server.settings.AllowUsers or null;
      AuthorizedPrincipalsFile = opts.ssh.server.settings.AuthorizedPrincipalsFile or "none";
      Ciphers =
        opts.ssh.server.settings.Ciphers or [
          "chacha20-poly1305@openssh.com"
          "aes256-gcm@openssh.com"
          "aes128-gcm@openssh.com"
          "aes256-ctr"
          "aes192-ctr"
          "aes128-ctr"
        ];
      DenyGroups = opts.ssh.server.settings.DenyGroups or null;
      DenyUsers = opts.ssh.server.settings.DenyUsers or null;
      GatewayPorts = opts.ssh.server.settings.GatewayPorts or "no";
      KbdInteractiveAuthentication = opts.ssh.server.settings.KbdInteractiveAuthentication or true;
      KexAlgorithms =
        opts.ssh.server.settings.KexAlgorithms or [
          "mlkem768x25519-sha256"
          "sntrup761x25519-sha512"
          "sntrup761x25519-sha512@openssh.com"
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
          "diffie-hellman-group-exchange-sha256"
        ];
      LogLevel = opts.ssh.server.settings.LogLevel or "INFO";
      Macs =
        opts.ssh.server.settings.Macs or [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
        ];
      PasswordAuthentication = opts.ssh.server.settings.PasswordAuthentication or true;
      PermitRootLogin = opts.ssh.server.settings.PermitRootLogin or "prohibit-password";
      PrintMotd = opts.ssh.server.settings.PrintMotd or false;
      StrictModes = opts.ssh.server.settings.StrictModes or true;
      UseDns = opts.ssh.server.settings.UseDns or false;
      UsePAM = opts.ssh.server.settings.UsePAM or true;
      X11Forwarding = opts.ssh.server.settings.X11Forwarding or false;
    };
  };
  home-manager.sharedModules = [
    (_: {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = opts.ssh.client.matchBlocks or { };
      };
      services.ssh-agent.enable =
        (opts.ssh.client.agent.enable or false) && !(opts.gpg.agent.enableSshSupport or false);
    })
  ];
}
