{ pkgs, ... }:
{
  security = {
    sudo = {
      enable = true;
      configFile = ''
        Defaults lecture = never
      '';
    };
    rtkit.enable = true;
    polkit.enable = true;
    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
      packages = [ pkgs.apparmor-profiles ];
    };
    # Prevent replacing the running kernel without a reboot
    protectKernelImage = true;
    acme.acceptTerms = true;
  };
}
