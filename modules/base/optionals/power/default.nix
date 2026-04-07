{
  services = {
    power-profiles-daemon = {
      enable = true;
    };
    upower = {
      enable = true;
      usePercentageForPolicy = true;
    };
  };
}
