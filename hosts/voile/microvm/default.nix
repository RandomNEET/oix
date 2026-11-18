{ inputs, pkgs, ... }:
{
  imports = [
    inputs.microvm.nixosModules.host
    ./agent
  ];
  environment = {
    systemPackages = with pkgs; [ socat ];
  };
}
