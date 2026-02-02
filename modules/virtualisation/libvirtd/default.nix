{
  lib,
  pkgs,
  opts,
  ...
}:
let
  desktop = opts.desktop or "";
  hasDesktop = desktop != "";
in
{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
      hooks = lib.mapAttrs (
        type: scripts:
        lib.mapAttrs (
          name: scriptContent:
          pkgs.writeShellScript name ''
            export PATH="${
              lib.makeBinPath [
                pkgs.util-linux
                pkgs.coreutils
              ]
            }:$PATH"
            ${scriptContent}
          ''
        ) scripts
      ) (opts.libvirtd.hooks or { });
    };
    spiceUSBRedirection.enable = true;
  };

  programs.virt-manager.enable = hasDesktop;

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    spice-webdavd.enable = true;
  };

  environment.systemPackages = with pkgs; [
    spice
    spice-gtk
    spice-protocol
    spice-vdagent
    virtio-win
    win-spice
  ];
}
