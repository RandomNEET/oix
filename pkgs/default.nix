{
  lib,
  pkgs,
  prev,
}:
lib.mergeAttrsList [
  { csakura = pkgs.callPackage ./csakura { }; }
  { easycon = pkgs.callPackage ./easycon { }; }
  {
    obsidianPlugins = {
      trash-explorer = pkgs.callPackage ./obsidian-plugins/trash-explorer { };
    };
  }
  {
    vscode-extensions = prev.vscode-extensions // {
      CL.eide = pkgs.callPackage ./vscode-extensions/CL.eide { };
      mcu-debug = {
        debug-tracker-vscode = pkgs.callPackage ./vscode-extensions/mcu-debug.debug-tracker-vscode { };
        memory-view = pkgs.callPackage ./vscode-extensions/mcu-debug.memory-view { };
        peripheral-viewer = pkgs.callPackage ./vscode-extensions/mcu-debug.peripheral-viewer { };
        rtos-views = pkgs.callPackage ./vscode-extensions/mcu-debug.rtos-views { };
      };
      ms-vscode = prev.vscode-extensions.ms-vscode // {
        vscode-serial-monitor = pkgs.callPackage ./vscode-extensions/ms-vscode.vscode-serial-monitor { };
      };
      openai.chatgpt = pkgs.callPackage ./vscode-extensions/openai.chatgpt { };
    };
  }
]
