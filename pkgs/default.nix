{
  lib,
  pkgs,
  prev,
}:
lib.mergeAttrsList [
  { fcitx5-rime-ice = pkgs.callPackage ./fcitx5-rime-ice { }; }
  {
    npmPackages = {
      obsidian-headless = pkgs.callPackage ./npm-packages/obsidian-headless { };
    };
  }
  {
    hyprlandPlugins = prev.hyprlandPlugins // {
      # hyprspace = (pkgs.callPackage ./hyprland-plugins { }).hyprspace;
    };
  }
  {
    obsidianPlugins = {
      # livesync = pkgs.callPackage ./obsidian-plugins/livesync { };
      trash-explorer = pkgs.callPackage ./obsidian-plugins/trash-explorer { };
    };
  }
  {
    tmuxPlugins = prev.tmuxPlugins // {
      # dotbar = (pkgs.callPackage ./tmux-plugins { }).dotbar;
    };
  }
  {
    vscode-extensions = prev.vscode-extensions // {
      CL.eide = pkgs.callPackage ./vscode-extensions/CL.eide { };
      mcu-debug.debug-tracker-vscode =
        pkgs.callPackage ./vscode-extensions/mcu-debug.debug-tracker-vscode
          { };
      mcu-debug.memory-view = pkgs.callPackage ./vscode-extensions/mcu-debug.memory-view { };
      mcu-debug.peripheral-viewer = pkgs.callPackage ./vscode-extensions/mcu-debug.peripheral-viewer { };
      mcu-debug.rtos-views = pkgs.callPackage ./vscode-extensions/mcu-debug.rtos-views { };
    };
  }
]
