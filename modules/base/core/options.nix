{ lib, meta, ... }:
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
          The target CPU architecture for this host. 
          This must match the hardware or the emulation environment where the system will run.
        '';
      };
      channel = mkOption {
        type = types.enum [
          "unstable"
          "stable"
        ];
        default = "unstable";
        description = "The Nixpkgs release stream this host should follow. ";
      };
      stateVersion = mkOption {
        type = types.str;
        default = "26.05";
        description = ''
          This option defines the first version of NixOS you have installed on this particular machine,
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
        description = ''
          The absolute path to the Flake configuration directory on this machine.

          This is useful for automation scripts (like a custom 'rebuild' alias) 
          to know where the source of truth is located without hardcoding paths.
        '';
      };
      hostname = mkOption {
        type = types.str;
        description = "The dynamically injected hostname of the machine.";
      };
      username = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "The dynamically injected username (Home Manager only).";
      };
    };
  };
  config = {
    meta = meta;
  };
}
