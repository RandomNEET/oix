{
  lib,
  pkgs,
  meta,
  ...
}:
rec {
  defaultPrograms = {
    editor = "nvim";
    fileManager = "yazi";
    terminal = "kitty";
    browser = "qutebrowser";
  };
  desktop = {
    wallpaper = {
      enable = true;
      dir = "/home/${meta.username}/pic/wallpapers";
    };
  };

  programs = {
    ssh = {
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "/home/${meta.username}/.config/sops-nix/secrets/ssh/github-RandomNEET";
          addKeysToAgent = "yes";
        };
        "codeberg.org" = {
          hostname = "codeberg.org";
          user = "git";
          identityFile = "/home/${meta.username}/.config/sops-nix/secrets/ssh/codeberg-RandomNEET";
          addKeysToAgent = "yes";
        };
        gale = {
          hostname = "gale.local";
          port = 22;
          user = meta.username;
          identityFile = "/home/${meta.username}/.config/sops-nix/secrets/ssh/gale";
          addKeysToAgent = "yes";
        };
        voile = {
          hostname = "voile.local";
          port = 22;
          user = meta.username;
          identityFile = "/home/${meta.username}/.config/sops-nix/secrets/ssh/voile";
          addKeysToAgent = "yes";
        };
      };
    };
    git = {
      settings = {
        user = {
          name = "RandomNEET";
          email = "dev@randomneet.me";
        };
      };
    };
    yazi = {
      keymap = {
        mgr = {
          prepend_keymap = [
            {
              on = [
                "g"
                "d"
              ];
              run = "cd ~/dls";
              desc = "Go ~/dls";
            }
            {
              on = [
                "g"
                "r"
              ];
              run = "cd ~/repo";
              desc = "Go ~/repo";
            }
            {
              on = [
                "g"
                "u"
              ];
              run = "cd /run/media/$USER";
              desc = "Go /run/media/$USER";
            }
          ];
        };
      };
    };
    rbw = {
      settings = {
        base_url = "https://vaultwarden.scaphium.xyz";
        email = "selfhost@randomneet.me";
        lock_timeout = 3600;
      };
    };
    qutebrowser = {
      settings = {
        url = {
          default_page = "https://startpage.randomneet.me/";
          start_pages = "https://startpage.randomneet.me/";
        };
      };
      quickmarks = {
        sp = "https://startpage.randomneet.me/";
        hp = "https://homepage.scaphium.xyz/";
        ld = "https://linkding.scaphium.xyz/";
      };
    };
    obsidian = {
      vaults = {
        default = {
          enable = true;
          target = "doc/notes";
        };
      };
    };
    niri = {
      settings = {
        outputs = {
          "DP-1" = {
            enable = true;
            mode = {
              width = 3840;
              height = 2160;
              refresh = 144.00;
            };
            scale = 1.5;
            position = {
              x = 0;
              y = 0;
            };
            variable-refresh-rate = "on-demand";
            focus-at-startup = true;
          };
          "HDMI-A-1" = {
            enable = true;
            mode = {
              width = 3840;
              height = 2160;
              refresh = 60.00;
            };
            scale = 1.5;
            transform = {
              rotation = 90;
            };
            position = {
              x = 2560;
              y = -600;
            };
          };
        };
        binds = {
          "Mod+F1" = {
            action.spawn = [
              "noctalia-shell"
              "ipc"
              "call"
              "volume"
              "muteOutput"
            ];
            allow-when-locked = true;
          };
          "Mod+F2" = {
            action.spawn = [
              "noctalia-shell"
              "ipc"
              "call"
              "volume"
              "decrease"
            ];
            allow-when-locked = true;
          };
          "Mod+F3" = {
            action.spawn = [
              "noctalia-shell"
              "ipc"
              "call"
              "volume"
              "increase"
            ];
            allow-when-locked = true;
          };
          "Mod+F4" = {
            action.spawn = [
              "noctalia-shell"
              "ipc"
              "call"
              "volume"
              "muteInput"
            ];
            allow-when-locked = true;
          };
          "Mod+F5" = {
            action.spawn = [
              "noctalia-shell"
              "ipc"
              "call"
              "brightness"
              "decrease"
            ];
            allow-when-locked = true;
          };
          "Mod+F6" = {
            action.spawn = [
              "noctalia-shell"
              "ipc"
              "call"
              "brightness"
              "increase"
            ];
            allow-when-locked = true;
          };
          "Mod+F7" = {
            action.spawn = [
              "noctalia-shell"
              "ipc"
              "call"
              "media"
              "previous"
            ];
            allow-when-locked = true;
          };
          "Mod+F8" = {
            action.spawn = [
              "noctalia-shell"
              "ipc"
              "call"
              "media"
              "playPause"
            ];
            allow-when-locked = true;
          };
          "Mod+F9" = {
            action.spawn = [
              "noctalia-shell"
              "ipc"
              "call"
              "media"
              "next"
            ];
            allow-when-locked = true;
          };
        };
      };
    };
    noctalia-shell = {
      settings = {
        general = {
          avatarImage = "/home/${meta.username}/pic/avatars/weeb.jpg";
        };
        bar = {
          screenOverrides = [
            {
              enabled = true;
              name = "HDMI-A-1";
              position = "top";
              density = "default";
              widgets = {
                center = [
                  {
                    id = "Clock";
                    formatHorizontal = "ddd MMM d HH:mm";
                    formatVertical = "MM dd - HH mm";
                    tooltipFormat = "yyyy-MM-dd HH:mm:ss";
                  }
                ];
                left = [
                  {
                    id = "Workspace";
                  }
                ];
                right = [
                  {
                    id = "AudioVisualizer";
                    hideWhenIdle = true;
                  }
                ];
              };
            }
          ];
        };
        sessionMenu = {
          powerOptions = lib.mkForce [
            {
              action = "lock";
              enabled = true;
              countdownEnabled = true;
              keybind = "1";
            }
            {
              action = "suspend";
              enabled = true;
              countdownEnabled = true;
              keybind = "2";
            }
            {
              action = "reboot";
              enabled = true;
              countdownEnabled = true;
              keybind = "3";
            }

            {
              action = "logout";
              enabled = true;
              countdownEnabled = true;
              keybind = "4";
            }
            {
              action = "shutdown";
              enabled = true;
              countdownEnabled = true;
              keybind = "5";
            }
            {
              action = "rebootToUefi";
              enabled = true;
              countdownEnabled = true;
              keybind = "6";
            }
          ];
        };
        idle = {
          suspendTimeout = lib.mkForce 0;
        };
      };
    };
  };
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          monitor = [
            "desc:SAC G7u Pro 0001, 3840x2160@160, 0x0, 1.5"
            "desc:KOS KOIOS K2718UD 0000000000000, 3840x2160@60, 2560x-600, 1.5, transform, 1"
          ];
          bind = [
            "$mainMod, F1, exec, noctalia-shell ipc call volume muteOutput"
            "$mainMod, F4, exec, noctalia-shell ipc call volume muteInput"
            "$mainMod, F7, exec, noctalia-shell ipc call media previous"
            "$mainMod, F8, exec, noctalia-shell ipc call media playPause"
            "$mainMod, F9, exec, noctalia-shell ipc call media next"
          ];
          binde = [
            "$mainMod, F2, exec, noctalia-shell ipc call volume decrease"
            "$mainMod, F3, exec, noctalia-shell ipc call volume increase"
            "$mainMod, F5, exec, noctalia-shell ipc call brightness decrease"
            "$mainMod, F6, exec, noctalia-shell ipc call brightness increase"
          ];
          extraConfig = ''
            workspace = 1, monitor:desc:SAC G7u Pro 0001, default:true;
            workspace = 10, monitor:desc:KOS KOIOS K2718UD 0000000000000, default:true;
          '';
        };
      };
    };
  };
  services = {
    flatpak = {
      packages = [
        "com.github.tchx84.Flatseal"
        "com.qq.QQ"
        "com.tencent.WeChat"
      ];
    };
    mbsync = {
      configFile = "/home/${meta.username}/.config/sops-nix/secrets/mbsync";
      trigger.enable = true;
    };
    mpd = {
      network = {
        listenAddress = "127.0.0.1";
        port = 6600;
        startWhenNeeded = true;
      };
      dataDir = "/mnt/hdd1/media/.mpd";
      musicDirectory = "/mnt/hdd1/media/music";
      extraConfig = ''
        audio_output {
           type   "pipewire"
           name   "PipeWire Sound Server"
        }
        audio_output {
           type   "fifo"
           name   "my_fifo"
           path   "/tmp/mpd.fifo"
           format "44100:16:2"
        }
        auto_update "yes"
      '';
    };
  };
  systemd = {
    user = {
      services.mbsync = {
        Unit.After = [ "sops-nix.service" ];
      };
    };
  };
  home = {
    packages = with pkgs; [
      ffmpeg
      imagemagick
      md2pdf

      localsend
      qbittorrent
      libreoffice
      tor-browser

      lolcat
      figlet
      fortune
      cowsay
      asciiquarium-transparent
      cbonsai
      cmatrix
      pipes
      tty-clock

      osu-lazer
      prismlauncher
    ];
  };

  accounts = {
    email = {
      maildirBasePath = ".mail";
      accounts = {
        RandomNEET = {
          primary = true;
          maildir.path = "/neet";
          address = "neet@randomneet.me";
          userName = "neet@randomneet.me";
          passwordCommand = "cat /home/${meta.username}/.config/sops-nix/secrets/email/RandomNEET/password";
          realName = "RandomNEET";
          gpg = {
            key = "0xBFA119DF465BFBB1";
            signByDefault = true;
            encryptByDefault = false;
          };
          flavor = "migadu.com";
          aerc = {
            enable = true;
            extraAccounts = {
              default = "Inbox";
              folders-sort = "Inbox,Inbox/dev,Inbox/contact,Inbox/selfhost,Inbox/bill,Inbox/cert,Inbox/temp,Archive,Drafts,Sent,Junk,Trash";
              check-mail = "5m";
              check-mail-cmd = "touch /home/${meta.username}/${accounts.email.maildirBasePath}/.trigger && sleep 1";
            };
          };
          mbsync = {
            enable = true;
            create = "maildir";
          };
        };
      };
    };
  };
  xdg = {
    userDirs = {
      enable = true;
      desktop = null; # no need for wm
      documents = "/home/${meta.username}/doc";
      download = "/home/${meta.username}/dls";
      music = "/home/${meta.username}/mus";
      pictures = "/home/${meta.username}/pic";
      videos = "/home/${meta.username}/vid";
      templates = "/home/${meta.username}/tpl";
      publicShare = "/home/${meta.username}/pub";
    };
  };

  sops = {
    secrets = {
      "ssh/github-RandomNEET".sopsFile = ./secrets.yaml;
      "ssh/codeberg-RandomNEET".sopsFile = ./secrets.yaml;
      "ssh/gale".sopsFile = ./secrets.yaml;
      "ssh/voile".sopsFile = ./secrets.yaml;
      "email/RandomNEET/password".sopsFile = ./secrets.yaml;
      mbsync.sopsFile = ./secrets.yaml;
    };
  };
}
