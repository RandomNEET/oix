{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        ControlMaster = "auto";
        ControlPath = "/run/user/%i/ssh-%r@%h:%p";
        ControlPersist = "10m";
      };
    };
  };
}
