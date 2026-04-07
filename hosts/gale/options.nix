{ pkgs, meta, ... }:
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
    kmonad = {
      keyboards = {
        T480 = {
          name = "T480";
          device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
          config = ''
            (defcfg
              input  (device-file "/dev/input/by-path/platform-i8042-serio-0-event-kbd")
              output (uinput-sink "T480")
              fallthrough true
            )
            (defsrc
                   mute vold volu
            esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  home end  ins  del
              grv  1    2    3    4    5    6    7    8    9    0    -     =    bspc
              tab  q    w    e    r    t    y    u    i    o    p    [     ]    \
              caps a    s    d    f    g    h    j    k    l    ;    '          ret
              lsft z    x    c    v    b    n    m    ,    .    /               rsft
              wkup lctl lmet lalt           spc            ralt sys  rctl  pgdn up   pgup
            )
            (defalias 
              mod (layer-toggle mod1)
            )
            (deflayer mod0
                   mute vold volu
            esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  home end  ins  del
              grv  1    2    3    4    5    6    7    8    9    0    -     =    bspc
              tab  q    w    e    r    t    y    u    i    o    p    [     ]    \
              lctl a    s    d    f    g    h    j    k    l    ;    '          ret
              lsft z    x    c    v    b    n    m    ,    .    /               rsft
              wkup lctl lmet lalt           spc            ralt sys  @mod  pgdn up   pgup
            )
            (deflayer mod1
                   mute vold volu
            esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  home end  ins  del
              grv  1    2    3    4    5    6    7    8    9    0    -     =    bspc
              tab  q    w    e    r    t    y    u    i    o    p    [     ]    \
              caps a    s    d    f    g    h    j    k    l    ;    '          ret
              lsft z    x    c    v    b    n    m    ,    .    /               rsft
              wkup lctl lmet lalt           spc            ralt sys  rctl  pgdn up   pgup
            )
          '';
          extraGroups = [
            "input"
            "uinput"
          ];
          enableHardening = true;
        };
      };
    };
  };
  systemd = {
    services = {
      dae.after = [ "sops-nix.service" ];
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
    gpu = "intel-integrated";
    display = {
      info = [
        {
          output = "eDP-1";
          width = 1920;
          height = 1080;
          orientation = "landscape";
        }
      ];
    };
  };
  desktop = {
    enable = true;
    hyprland = {
      enable = true;
      primary = false;
    };
    niri = {
      enable = true;
      primary = true;
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
