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
      enable = lib.mkForce false;
      configFile = "/run/secrets/dae";
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
    };
  };
}
