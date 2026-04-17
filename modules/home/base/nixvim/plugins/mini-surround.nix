{ lib, meta, ... }:
{
  programs.nixvim = {
    plugins.mini-surround = {
      enable = true;
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
  }
  // lib.optionalAttrs (meta.channel == "unstable") {
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
  };
}
