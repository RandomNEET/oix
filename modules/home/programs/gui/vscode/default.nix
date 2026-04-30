{
  config,
  lib,
  pkgs,
  ...
}:
let
  homeDir = config.home.homeDirectory;
  dataDir = config.xdg.dataHome;
  userDataDir = "${dataDir}/vscode/data";
  extensionsDir = "${dataDir}/vscode/extensions";
in
{
  programs.vscode = {
    enable = true;
    package = (
      pkgs.vscode.override {
        commandLineArgs = [
          "--user-data-dir ${userDataDir}"
          "--extensions-dir ${extensionsDir}"
        ];
      }
    );
    mutableExtensionsDir = false;
    profiles = {
      default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = true;
        extensions = with pkgs.vscode-extensions; [
          asvetliakov.vscode-neovim

          ms-vscode-remote.remote-ssh
          ms-vscode-remote.remote-ssh-edit
          ms-vscode.remote-explorer
          ms-vscode.hexeditor

          bbenoist.nix
          ecmel.vscode-html-css
          ms-python.python
          vue.volar
          esbenp.prettier-vscode

          yzhang.markdown-all-in-one
          yzane.markdown-pdf
        ];
        userSettings = {
          vscode-neovim = {
            neovimInitVimPaths = {
              linux = "${userDataDir}/User/vscode-neovim.lua";
            };
          };
          markdown-pdf = {
            displayHeaderFooter = false;
            margin.top = "1cm";
          };
          extensions = {
            experimental = {
              affinity = {
                "asvetliakov.vscode-neovim" = 1;
              };
            };
          };
        };
      };
    };
  };

  home.file.".config/Code/User/vscode-neovim.lua".source = ./vscode-neovim.lua;

  # To solve VSCode wants to write settings.json
  # VSCode will reset per reboot/rebuild.
  systemd.user.services.vscode-setup = {
    Unit = {
      Description = "VSCode Setup service";
      After = [ "graphical-session-pre.target" ];
      Wants = [ "graphical-session-pre.target" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      Type = "oneshot";
      UMask = "0022";
      ExecStart = lib.getExe (
        pkgs.writeShellApplication {
          name = "vscode-setup";
          runtimeInputs = with pkgs; [
            coreutils
            gnutar
            jq
          ];
          text =
            let
              userSrc = "${homeDir}/.config/Code/User";
              userDst = "${userDataDir}/User";
              extSrc = "${homeDir}/.vscode/extensions";
              extDst = extensionsDir;

              dirsToPreserve = [
                "workspaceStorage"
                "History"
              ];
              backupCmds = builtins.concatStringsSep "\n" (
                map (dir: ''
                  if [ -e "${userDst}/${dir}" ]; then
                    echo "Backing up data/User/${dir}..."
                    mv "${userDst}/${dir}" "/tmp/vscode-${dir}-$$"
                  fi
                '') (dirsToPreserve ++ [ "globalStorage" ])
              );
              restoreCmds = builtins.concatStringsSep "\n" (
                map (dir: ''
                  if [ -e "/tmp/vscode-${dir}-$$" ]; then
                    echo "Restoring data/User/${dir}..."
                    mv "/tmp/vscode-${dir}-$$" "${userDst}/${dir}"
                  fi
                '') dirsToPreserve
              );
            in
            ''
              set -eu

              ${backupCmds}

              echo "Cleaning old directories..."
              rm -rf "${userDst}"
              rm -rf "${extDst}"

              mkdir -p "${userDataDir}"
              mkdir -p "${extDst}"

              echo "Copying user settings from ${userSrc}..."
              cp -r --dereference --no-preserve=mode,ownership ${userSrc} "${userDst}"

              echo "Copying extensions from ${extSrc}..."
              tar -h -C "${extSrc}" -cf - . | tar -C "${extDst}" -xf - --no-same-owner --no-same-permissions --mode='u=rX,go=rX'
              chmod u+w -R "${extDst}" 2>/dev/null || true

              ${restoreCmds}

              echo "Restoring and merging data/User/globalStorage..."
              if [ -e "/tmp/vscode-globalStorage-$$" ]; then
                cp -rT "/tmp/vscode-globalStorage-$$" "${userDst}/globalStorage"

                src_storage_json="${userSrc}/globalStorage/storage.json"
                dst_storage_json="${userDst}/globalStorage/storage.json"

                if [ -f "$src_storage_json" ] && [ -f "$dst_storage_json" ]; then
                  echo "Merging data/globalStorage/storage.json with new data..."
                  merged_json=$(mktemp)
                  jq -s '.[0] * .[1]' "$dst_storage_json" "$src_storage_json" > "$merged_json"
                  mv "$merged_json" "$dst_storage_json"
                  echo "Merge complete."
                else
                  echo "Skipping storage.json merge: one or both files do not exist."
                fi
              else
                echo "No backed-up globalStorage found to restore."
              fi

              echo "VSCode setup complete."
            '';
        }
      );
    };
  };
}
