{
  programs.nixvim = {
    plugins.mini-surround = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings = {
          keys = [
            "gsa"
            "gsd"
            "gsf"
            "gsF"
            "gsh"
            "gsr"
            "gsn"
          ];
        };
      };
      settings = {
        mappings = {
          add = "gsa";
          delete = "gsd";
          find = "gsf";
          find_left = "gsF";
          highlight = "gsh";
          replace = "gsr";
          update_n_lines = "gsn";
        };
      };
    };
  };
}
