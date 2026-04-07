{
  lib,
  pkgs,
  meta,
  ...
}:
let
  username = "howl";
in
{
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
  };
  networking = {
    hostName = meta.hostname;
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
        ];
        shell = pkgs.zsh;
      };
    };
  };
  environment = {
    systemPackages = with pkgs; [ veracrypt ];
  };
  services = {
    udev = {
      extraRules = ''
        # Disable wake-on-USB for Logitech G502X Receiver to prevent accidental wakeups from sleep/suspend
        ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c547", ENV{DEVTYPE}=="usb_device", ATTR{power/wakeup}="disabled"
      '';
    };
    snapper = {
      configs = {
        home = {
          SUBVOLUME = "/home";
          ALLOW_USERS = [ username ];
          TIMELINE_CREATE = true;
          TIMELINE_CLEANUP = true;
        };
      };
    };
    openssh = {
      authorizedKeysFiles = [ "/run/secrets/ssh/${username}@${meta.hostname}" ];
    };
    dae = {
      configFile = "/run/secrets/dae";
    };
  };
  systemd = {
    services = {
      dae.after = [ "sops-nix.service" ];
    };
  };
  virtualisation = {
    libvirtd = {
      hooks = {
        qemu = {
          auto-mount = pkgs.writeShellScript "auto-mount" ''
            # Set PATH for the script environment
            export PATH="${
              lib.makeBinPath [
                pkgs.util-linux
                pkgs.coreutils
              ]
            }:$PATH"

            # Logic for VM: win11-native
            VM_NAME="win11-native"
            if [ "$1" = "$VM_NAME" ]; then
                case "$2" in
                    prepare)
                        # Unmount before VM starts
                        umount -l /mnt/ssd || true 
                        ;;
                    stopped|release)
                        # Re-mount after VM stops
                        if ! mountpoint -q /mnt/ssd; then
                            mount /mnt/ssd || true
                        fi
                        ;;
                esac
            fi
          '';
        };
      };
    };
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
      dae.sopsFile = ./secrets.yaml;
    };
  };
  base = {
    gpu = "nvidia";
    display = {
      info = [
        {
          output = "DP-1";
          width = 3840;
          height = 2160;
          orientation = "landscape";
        }
        {
          output = "HDMI-A-1";
          width = 2160;
          height = 3840;
          orientation = "portrait";
        }
      ];
      ddcutil = {
        enable = true;
        users = [ username ];
      };
    };
  };
  desktop = {
    enable = true;
    hyprland = {
      enable = true;
      primary = true;
    };
    niri = {
      enable = true;
      primary = false;
    };
    theme = {
      enable = true;
      baseTheme = "catppuccin-mocha";
      polarity = "dark";
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
        sansSerif = {
          package = pkgs.noto-fonts-cjk-sans;
          name = "Noto Sans CJK SC";
        };
        serif = {
          package = pkgs.noto-fonts-cjk-serif;
          name = "Noto Serif CJK SC";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
    };
  };
}
