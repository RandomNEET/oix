{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {
    meta = {
      system = mkOption {
        type = types.enum [
          "x86_64-linux"
          "aarch64-linux"
        ];
        default = "x86_64-linux";
        description = ''
          System platform tuple (for example, `x86_64-linux` or `aarch64-linux`) for which this host configuration is built.
        '';
      };
      platform = mkOption {
        type = types.enum [
          "nixos"
          "home-manager"
        ];
        default = "nixos";
        description = ''
          Deployment target for this host.

          - `"nixos"`: Build a full NixOS system configuration with integrated Home Manager.
          - `"home-manager"`: Build standalone Home Manager configurations for non-NixOS hosts.
        '';
      };
      systemBuilder = mkOption {
        type = types.enum [
          "nixpkgs"
          "nixos-raspberrypi"
        ];
        default = "nixpkgs";
        description = ''
          Builder function used to evaluate the NixOS system configuration.

          - `"nixpkgs"`: Standard `nixpkgs.lib.nixosSystem` builder.
          - `"nixos-raspberrypi"`: `nixos-raspberrypi.lib.nixosSystem` builder tailored for Raspberry Pi hardware.
        '';
      };
      channel = mkOption {
        type = types.enum [
          "unstable"
          "stable"
        ];
        default = "unstable";
        description = ''
          Release channel to follow for Nixpkgs, Home Manager, and companion flake inputs (`"unstable"` or `"stable"`).
        '';
      };
      allowUnfree = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to allow packages with unfree licenses via `nixpkgs.config.allowUnfree`.";
      };
      stateVersion = mkOption {
        type = types.str;
        default = "26.05";
        description = ''
          This option defines the first version of NixOS (and Home Manager) you have installed on this particular machine,
          and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.

          For example, if NixOS version XX.YY ships with AwesomeDB version N by default, and is then
          upgraded to version XX.YY+1, which ships AwesomeDB version N+1, the existing databases
          may no longer be compatible, causing applications to fail, or even leading to data loss.

          The `stateVersion` mechanism avoids this situation by making the default version of such packages
          conditional on the first version of NixOS you've installed (encoded in `stateVersion`), instead of
          simply always using the latest one.

          Note that this generally only affects applications that can't upgrade their data automatically -
          applications and services supporting automatic migrations will remain on latest versions when
          you upgrade.

          Most users should **never** change this value after the initial install, for any reason,
          even if you've upgraded your system to a new NixOS release.

          This value does **not** affect the Nixpkgs version your packages and OS are pulled from,
          so changing it will **not** upgrade your system.

          This value being lower than the current NixOS release does **not** mean your system is
          out of date, out of support, or vulnerable.

          Do **not** change this value unless you have manually inspected all the changes it would
          make to your configuration, and migrated your data accordingly.
        '';
      };
      flake = mkOption {
        type = types.path;
        description = "Absolute path to the local flake repository checkout on this machine.";
      };
      hostname = mkOption {
        type = types.str;
        description = "Host name of the machine, automatically injected from its directory name under `hosts/`.";
      };
      username = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "User name for standalone Home Manager evaluations, or `null` when evaluating system-wide NixOS configurations.";
      };
    };
  };
}
