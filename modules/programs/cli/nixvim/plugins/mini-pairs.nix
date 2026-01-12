{
  programs.nixvim = {
    plugins.mini-pairs = {
      enable = true;
      settins = {
        modes = {
          command = true;
          insert = true;
          terminal = false;
        };
      };
    };
  };
}
