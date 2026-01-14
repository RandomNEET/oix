{
  programs.nixvim = {
    plugins.mini-pairs = {
      enable = true;
      settins = {
        modes = {
          insert = true;
          command = false;
          terminal = false;
        };
      };
    };
  };
}
