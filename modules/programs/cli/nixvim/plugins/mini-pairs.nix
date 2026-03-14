{
  programs.nixvim = {
    plugins.mini-pairs = {
      enable = true;
      settings = {
        modes = {
          insert = true;
          command = false;
          terminal = false;
        };
      };
    };
  };
}
