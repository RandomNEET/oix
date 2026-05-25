{ osConfig, lib, ... }:
{
  config = lib.mkIf osConfig.desktop.plasma.enable {
    stylix.targets = {
      qt.enable = lib.mkForce false;
      kde.enable = true;
    };
  };
}
