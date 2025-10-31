{ ... }:
{
  home-manager.sharedModules = [
    (_: {
      services.swww = {
        enable = true;
      };
    })
  ];
}
