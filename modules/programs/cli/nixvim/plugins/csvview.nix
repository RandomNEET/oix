{
  programs.nixvim = {
    keymaps = [
      {
        mode = [
          "n"
        ];
        key = "<leader>cv";
        action = "<cmd>CsvViewToggle<cr>";
        options = {
          desc = "Toggle CSV view";
        };
      }
    ];
    plugins.csvview = {
      enable = true;
      settings = {
        parser = {
          async_chunksize = 50;
        };
        view = {
          display_mode = "border";
          spacing = 2;
        };
      };
    };
  };
}
