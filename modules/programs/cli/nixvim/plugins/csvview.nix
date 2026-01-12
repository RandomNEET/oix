{
  programs.nixvim = {
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
  };
}
