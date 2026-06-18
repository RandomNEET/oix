{ pkgs, meta, ... }:
let
  username = "howl";
in
{
  imports = [ ./sever ];

  base = {
    gpu = "nvidia";
  };

  services = {
    openssh = {
      authorizedKeysFiles = [ "/run/secrets/ssh/${username}@${meta.hostname}" ];
    };
    xray = {
      settingsFile = "/run/secrets/xray";
    };
  };
  systemd = {
    services = {
      xray = {
        after = [
          "sops-nix.service"
          "docker.service"
        ];
      };
      docker = {
        serviceConfig = {
          Environment = [
            "http_proxy=http://127.0.0.1:9998"
            "https_proxy=http://127.0.0.1:9998"
          ];
        };
      };
      mpd = {
        after = [
          "mnt-smb.mount"
        ];
        requires = [
          "mnt-smb.mount"
        ];
      };
    };
  };
  environment = {
    systemPackages = with pkgs; [ ntfs3g ];
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
          "libvirtd"
          "docker"
        ];
        shell = pkgs.zsh;
      };
    };
  };
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        6600 # mpd
        8000 # mpd http stream
        10090 # watchtower
        10225 # peerbanhelper
        10230 # anirss
      ];
    };
    hostName = meta.hostname;
  };
  nix = {
    settings = {
      allowed-users = [ username ];
    };
  };
  boot = {
    kernelPackages = pkgs.linuxPackages;
  };

  sops = {
    secrets = {
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
      xray.sopsFile = ./secrets.yaml;
    };
  };
}
