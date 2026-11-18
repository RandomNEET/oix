{
  inputs,
  config,
  pkgs,
  ...
}:
{
  microvm.vms = {
    agent = {
      autostart = true;
      restartIfChanged = true;
      evaluatedConfig = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.microvm.nixosModules.microvm
          inputs.home-manager.nixosModules.home-manager
          ./guest.nix
        ];
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          mylib = import ../../../../lib { inherit (inputs.nixpkgs) lib; };
          meta = import ../../meta.nix // {
            hostname = "voile-agent";
            channel = "unstable";
          };
        };
      };
    };
  };
  systemd = {
    services = {
      "microvm@agent" = {
        wants = [ "xray.service" ];
        after = [ "xray.service" ];
        serviceConfig = {
          UMask = "0077";
        };
      };
      "microvm-virtiofsd@agent" = {
        requires = [ "voile-agent-ssh.service" ];
        after = [ "voile-agent-ssh.service" ];
      };
      voile-agent-ssh = {
        description = "Prepare authorized SSH keys for the agent MicroVM";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          RuntimeDirectory = "voile-agent-ssh";
          RuntimeDirectoryMode = "0755";
        };
        script = ''
          ${pkgs.coreutils}/bin/install -m 0444 ${
            config.sops.secrets."ssh/howl@voile".path
          } /run/voile-agent-ssh/authorized_keys
        '';
      };
    };
  };
}
