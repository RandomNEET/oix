{
  inputs,
  options,
  pkgs,
  mylib,
  meta,
  ...
}:
{
  imports = [
    ../../../../modules/base/os/core/openssh.nix
    ../../../../modules/base/os/desktop/options.nix
    ../../../../modules/base/os/gpu/options.nix

    ../../../../modules/optional/os/programs/nix-ld
  ];

  programs = {
    zsh = {
      enable = true;
    };
  };
  services = {
    openssh = {
      authorizedKeysFiles = [ "/run/host-ssh/authorized_keys" ];
      hostKeys = map (
        key:
        key
        // {
          path = "/var/lib/ssh/${builtins.baseNameOf key.path}";
        }
      ) options.services.openssh.hostKeys.default;
    };
    getty = {
      autologinUser = "root";
    };
  };
  systemd = {
    network = {
      enable = true;
      networks = {
        "20-agent" = {
          matchConfig = {
            MACAddress = "02:00:00:00:00:01";
          };
          networkConfig = {
            DHCP = "ipv4";
          };
        };
      };
    };
  };
  environment = {
    systemPackages = with pkgs; [
      bubblewrap
      curl
      wget
      gcc
      gnumake
      unzip
    ];
  };

  users = {
    mutableUsers = false;
    # 授权公钥在运行时通过宿主机只读共享提供
    allowNoPasswordLogin = true;
    users = {
      howl = {
        isNormalUser = true;
        uid = 1000;
        extraGroups = [ "wheel" ];
        shell = pkgs.zsh;
      };
    };
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs mylib meta; };
    users = {
      howl = import ./home.nix;
    };
  };
  networking = {
    hostName = meta.hostname;
    proxy = {
      # 通过 QEMU 用户态网络访问宿主机的回环代理
      default = "http://10.0.2.2:9998";
      noProxy = "localhost,127.0.0.1,::1,10.0.2.2";
    };
    firewall = {
      enable = true;
    };
    useDHCP = false;
  };
  security = {
    sudo = {
      wheelNeedsPassword = false;
    };
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
  fileSystems = {
    "/home" = {
      neededForBoot = true;
    };
    "/nix" = {
      neededForBoot = true;
    };
  };
  boot = {
    kernelParams = [ "console=ttyS0" ];
  };
  system = {
    stateVersion = meta.stateVersion;
  };

  microvm = {
    vcpu = 4;
    mem = 8192;
    volumes = [
      {
        image = "home.img";
        mountPoint = "/home";
        size = 65536;
      }
      {
        image = "nix.img";
        mountPoint = "/nix";
        size = 32768;
      }
      {
        image = "var.img";
        mountPoint = "/var";
        size = 8192;
      }
    ];
    forwardPorts = [
      {
        from = "host";
        host = {
          address = "127.0.0.1";
          port = 2200;
        };
        guest = {
          port = 22;
        };
      }
    ];
    shares = [
      {
        proto = "virtiofs";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        readOnly = true;
      }
      {
        proto = "virtiofs";
        tag = "ssh-keys";
        source = "/run/voile-agent-ssh";
        mountPoint = "/run/host-ssh";
        readOnly = true;
      }
    ];
    writableStoreOverlay = "/nix/.rw-store";
    hypervisor = "qemu";
    interfaces = [
      {
        type = "user";
        id = "agent";
        mac = "02:00:00:00:00:01";
      }
    ];
    qemu = {
      serialConsole = false;
      # 恢复控制台仅通过宿主机上的 MicroVM 状态目录访问
      extraArgs = [
        "-chardev"
        "socket,id=console,path=console.sock,server=on,wait=off"
        "-serial"
        "chardev:console"
      ];
    };
  };
}
