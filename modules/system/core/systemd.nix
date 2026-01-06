{
  config,
  lib,
  opts,
  ...
}:
{
  systemd = { } // (opts.systemd or { });

  home-manager.sharedModules = [
    {
      home.shellAliases = {
        # User commands (no sudo)
        sc-cat = "systemctl cat";
        sc-get-default = "systemctl get-default";
        sc-help = "systemctl help";
        sc-is-active = "systemctl is-active";
        sc-is-enabled = "systemctl is-enabled";
        sc-is-failed = "systemctl is-failed";
        sc-is-system-running = "systemctl is-system-running";
        sc-list-dependencies = "systemctl list-dependencies";
        sc-list-jobs = "systemctl list-jobs";
        sc-list-sockets = "systemctl list-sockets";
        sc-list-timers = "systemctl list-timers";
        sc-list-unit-files = "systemctl list-unit-files";
        sc-list-units = "systemctl list-units";
        sc-show = "systemctl show";
        sc-show-environment = "systemctl show-environment";
        sc-status = "systemctl status";

        # User commands with --user flag
        scu-cat = "systemctl --user cat";
        scu-get-default = "systemctl --user get-default";
        scu-help = "systemctl --user help";
        scu-is-active = "systemctl --user is-active";
        scu-is-enabled = "systemctl --user is-enabled";
        scu-is-failed = "systemctl --user is-failed";
        scu-is-system-running = "systemctl --user is-system-running";
        scu-list-dependencies = "systemctl --user list-dependencies";
        scu-list-jobs = "systemctl --user list-jobs";
        scu-list-sockets = "systemctl --user list-sockets";
        scu-list-timers = "systemctl --user list-timers";
        scu-list-unit-files = "systemctl --user list-unit-files";
        scu-list-units = "systemctl --user list-units";
        scu-show = "systemctl --user show";
        scu-show-environment = "systemctl --user show-environment";
        scu-status = "systemctl --user status";

        # Sudo commands
        sc-add-requires = "sudo systemctl add-requires";
        sc-add-wants = "sudo systemctl add-wants";
        sc-cancel = "sudo systemctl cancel";
        sc-daemon-reexec = "sudo systemctl daemon-reexec";
        sc-daemon-reload = "sudo systemctl daemon-reload";
        sc-default = "sudo systemctl default";
        sc-disable = "sudo systemctl disable";
        sc-edit = "sudo systemctl edit";
        sc-emergency = "sudo systemctl emergency";
        sc-enable = "sudo systemctl enable";
        sc-halt = "sudo systemctl halt";
        sc-import-environment = "sudo systemctl import-environment";
        sc-isolate = "sudo systemctl isolate";
        sc-kexec = "sudo systemctl kexec";
        sc-kill = "sudo systemctl kill";
        sc-link = "sudo systemctl link";
        sc-list-machines = "sudo systemctl list-machines";
        sc-load = "sudo systemctl load";
        sc-mask = "sudo systemctl mask";
        sc-preset = "sudo systemctl preset";
        sc-preset-all = "sudo systemctl preset-all";
        sc-reenable = "sudo systemctl reenable";
        sc-reload = "sudo systemctl reload";
        sc-reload-or-restart = "sudo systemctl reload-or-restart";
        sc-reset-failed = "sudo systemctl reset-failed";
        sc-rescue = "sudo systemctl rescue";
        sc-restart = "sudo systemctl restart";
        sc-revert = "sudo systemctl revert";
        sc-set-default = "sudo systemctl set-default";
        sc-set-environment = "sudo systemctl set-environment";
        sc-set-property = "sudo systemctl set-property";
        sc-start = "sudo systemctl start";
        sc-stop = "sudo systemctl stop";
        sc-switch-root = "sudo systemctl switch-root";
        sc-try-reload-or-restart = "sudo systemctl try-reload-or-restart";
        sc-try-restart = "sudo systemctl try-restart";
        sc-unmask = "sudo systemctl unmask";
        sc-unset-environment = "sudo systemctl unset-environment";

        # Sudo commands with --user flag
        scu-add-requires = "systemctl --user add-requires";
        scu-add-wants = "systemctl --user add-wants";
        scu-cancel = "systemctl --user cancel";
        scu-daemon-reexec = "systemctl --user daemon-reexec";
        scu-daemon-reload = "systemctl --user daemon-reload";
        scu-default = "systemctl --user default";
        scu-disable = "systemctl --user disable";
        scu-edit = "systemctl --user edit";
        scu-emergency = "systemctl --user emergency";
        scu-enable = "systemctl --user enable";
        scu-halt = "systemctl --user halt";
        scu-import-environment = "systemctl --user import-environment";
        scu-isolate = "systemctl --user isolate";
        scu-kexec = "systemctl --user kexec";
        scu-kill = "systemctl --user kill";
        scu-link = "systemctl --user link";
        scu-list-machines = "systemctl --user list-machines";
        scu-load = "systemctl --user load";
        scu-mask = "systemctl --user mask";
        scu-preset = "systemctl --user preset";
        scu-preset-all = "systemctl --user preset-all";
        scu-reenable = "systemctl --user reenable";
        scu-reload = "systemctl --user reload";
        scu-reload-or-restart = "systemctl --user reload-or-restart";
        scu-reset-failed = "systemctl --user reset-failed";
        scu-rescue = "systemctl --user rescue";
        scu-restart = "systemctl --user restart";
        scu-revert = "systemctl --user revert";
        scu-set-default = "systemctl --user set-default";
        scu-set-environment = "systemctl --user set-environment";
        scu-set-property = "systemctl --user set-property";
        scu-start = "systemctl --user start";
        scu-stop = "systemctl --user stop";
        scu-switch-root = "systemctl --user switch-root";
        scu-try-reload-or-restart = "systemctl --user try-reload-or-restart";
        scu-try-restart = "systemctl --user try-restart";
        scu-unmask = "systemctl --user unmask";
        scu-unset-environment = "systemctl --user unset-environment";

        # Power commands
        sc-hibernate = "systemctl hibernate";
        sc-hybrid-sleep = "systemctl hybrid-sleep";
        sc-poweroff = "systemctl poweroff";
        sc-reboot = "systemctl reboot";
        sc-suspend = "systemctl suspend";

        # --now commands
        sc-enable-now = "sudo systemctl enable --now";
        sc-disable-now = "sudo systemctl disable --now";
        sc-mask-now = "sudo systemctl mask --now";
        scu-enable-now = "systemctl --user enable --now";
        scu-disable-now = "systemctl --user disable --now";
        scu-mask-now = "systemctl --user mask --now";

        # --failed commands
        sc-failed = "systemctl --failed";
        scu-failed = "systemctl --user --failed";
      };

      programs.zsh = lib.mkIf config.programs.zsh.enable {
        initContent = ''
          # Systemd prompt info function
          function systemd_prompt_info {
            local unit
            for unit in "$@"; do
              echo -n "$ZSH_THEME_SYSTEMD_PROMPT_PREFIX"

              if [[ -n "$ZSH_THEME_SYSTEMD_PROMPT_CAPS" ]]; then
                echo -n "''${(U)unit:gs/%/%%}:"
              else
                echo -n "''${unit:gs/%/%%}:"
              fi

              if systemctl is-active "$unit" &>/dev/null; then
                echo -n "$ZSH_THEME_SYSTEMD_PROMPT_ACTIVE"
              elif systemctl --user is-active "$unit" &>/dev/null; then
                echo -n "$ZSH_THEME_SYSTEMD_PROMPT_ACTIVE"
              else
                echo -n "$ZSH_THEME_SYSTEMD_PROMPT_NOTACTIVE"
              fi

              echo -n "$ZSH_THEME_SYSTEMD_PROMPT_SUFFIX"
            done
          }
        '';
      };
    }
  ];
}
