{ pkgs }:
{
  extensions = with pkgs.vscode-extensions; [
    CL.eide
    # System requirements for eide:
    # services.udev.packages = with pkgs; [ openocd ];
    # users.groups.plugdev.members = [ "username" ];
    # environment.systemPackages = with pkgs; [
    #   dotnet-sdk_6
    #   gcc-arm-embedded
    #   openocd
    # ];
    # nixpkgs.config.permittedInsecurePackages = [ "dotnet-sdk-6.0.428" ];
    marus25.cortex-debug # required by CL.eide
    mcu-debug.debug-tracker-vscode # required by marus25.cortex-debug
    mcu-debug.memory-view # required by marus25.cortex-debug
    mcu-debug.peripheral-viewer # required by marus25.cortex-debug
    mcu-debug.rtos-views # required by marus25.cortex-debug
    ms-vscode.cpptools-extension-pack
  ];
}
