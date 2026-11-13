{
  inputs,
  config,
  lib,
  pkgs,
  meta,
  ...
}:
let
  username = "howl";
in
{
  imports = [
    inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.base
    inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.display-vc4
    inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.bluetooth
  ];

  base = {
    gpu = "none";
    multimedia.enable = true;
    bluetooth.enable = true;
    power.enable = true;
  };
  desktop = {
    enable = true;
    displayManager = "ly";
    niri.enable = true;
    themes = {
      enable = true;
      list = [ "catppuccin-mocha" ];
      polarity = "dark";
    };
    fonts = {
      monospace = [
        {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        }
        {
          package = pkgs.sarasa-gothic;
          name = "Sarasa Mono SC";
        }
      ];
      sansSerif = [
        {
          package = pkgs.ibm-plex;
          name = "IBM Plex Sans";
        }
        {
          package = pkgs.sarasa-gothic;
          name = "Sarasa Gothic SC";
        }
      ];
      serif = [
        {
          package = pkgs.ibm-plex;
          name = "IBM Plex Serif";
        }
        {
          package = pkgs.sarasa-gothic;
          name = "Sarasa Gothic SC";
        }
      ];
      emoji = [
        {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        }
      ];
    };
  };

  programs = {
    dconf.enable = true;
  };
  services = {
    dae = {
      configFile = "/run/secrets/dae";
    };
    tailscale = {
      authKeyFile = "/run/secrets/tailscale";
    };
    openssh = {
      authorizedKeysFiles = [ "/run/secrets/ssh/${username}@${meta.hostname}" ];
      settings = {
        PasswordAuthentication = lib.mkForce true;
      };
    };
  };
  systemd = {
    defaultUnit = lib.mkForce "multi-user.target";
  };
  users = {
    users = {
      root = {
        hashedPasswordFile = "/run/secrets-for-users/users/root/password";
      };
      "${username}" = {
        hashedPasswordFile = "/run/secrets-for-users/users/${username}/password";
        isNormalUser = true;
        uid = 1000;
        extraGroups = [
          "wheel"
          "networkmanager"
          "podman"
        ];
        shell = pkgs.zsh;
      };
    };
  };
  networking = {
    firewall = {
      allowedTCPPorts = [
        53317 # localsend
      ];
    };
    hostName = meta.hostname;
  };
  nix = {
    settings = {
      allowed-users = [ username ];
    };
    extraOptions = ''
      !include ${config.sops.secrets."nix/access-tokens".path}
    '';
  };

  sops = {
    secrets = {
      "nix/access-tokens" = {
        sopsFile = ./secrets.yaml;
        mode = "0440";
        group = "wheel";
      };
      "users/root/password" = {
        sopsFile = ./secrets.yaml;
        neededForUsers = true;
      };
      "users/${username}/password" = {
        sopsFile = ./secrets.yaml;
        neededForUsers = true;
      };
      "ssh/${username}@${meta.hostname}" = {
        sopsFile = ./secrets.yaml;
        owner = username;
      };
      dae.sopsFile = ./secrets.yaml;
      tailscale.sopsFile = ./secrets.yaml;
    };
  };

  # TEMPFIX: older kernel tools lack the 128-bit types used by newer arm64 headers.
  # Remove once the Raspberry Pi kernel includes upstream commit 10a47fb67340.
  # Upstream: https://git.kernel.org/linus/10a47fb67340
  boot.kernelPatches = [
    {
      name = "tools-arm64-u128";
      patch = pkgs.writeText "tools-arm64-u128.patch" ''
        diff --git a/tools/include/linux/types.h b/tools/include/linux/types.h
        --- a/tools/include/linux/types.h
        +++ b/tools/include/linux/types.h
        @@ -24,1 +24,6 @@
         } gfp_t;
        +
        +#ifdef __SIZEOF_INT128__
        +typedef __signed__ __int128 __s128 __attribute__((aligned(16)));
        +typedef unsigned __int128 __u128 __attribute__((aligned(16)));
        +#endif
      '';
    }
  ];

  # TEMPFIX: the large-message AI session test exceeds its redaction timeout on Pi.
  # Remove once Atuin's a_huge_message_reads_back test is reliable on this host.
  home-manager.users.${username}.programs.atuin.package = pkgs.atuin.overrideAttrs (old: {
    checkFlags = (old.checkFlags or [ ]) ++ [ "--skip=a_huge_message_reads_back" ];
  });

  # TEMPFIX: allow qutebrowser 3.7.0 despite the eMudhra TLS advisory.
  # Remove once the locked package is fixed and no longer marked insecure.
  # Upstream: https://github.com/qutebrowser/qutebrowser/issues/9032
  nixpkgs.config.permittedInsecurePackages = [ "qutebrowser-3.7.0" ];
}
