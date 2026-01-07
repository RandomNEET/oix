{
  lib,
  pkgs,
  opts,
  ...
}:
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
      ) (opts.virtualisation.vm.hooks or { });
    };
    spiceUSBRedirection.enable = true;
  };

  programs.virt-manager.enable = opts.virtualisation.vm.virt-manager.enable or true;

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    spice-webdavd.enable = true;
  };

  environment.systemPackages = with pkgs; [
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    spice-vdagent
    virtio-win
    win-spice
  ];
}
