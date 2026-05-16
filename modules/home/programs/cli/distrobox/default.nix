{
  programs.distrobox = {
    enable = true;
    enableSystemdUnit = true;
    settings = {
      container_always_pull = "1";
      container_generate_entry = 0;
      container_user_custom_home = "$HOME/.distrobox/home";
    };
  };
}
