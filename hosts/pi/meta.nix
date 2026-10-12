{
  system = "aarch64-linux";
  platform = "nixos";
  systemBuilder = "nixos-raspberrypi";
  channel = "unstable";
  allowUnfree = true;
  stateVersion = "26.11";
  flake = "/home/howl/oix";
}
