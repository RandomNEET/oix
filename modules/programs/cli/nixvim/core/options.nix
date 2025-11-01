{
  programs.nixvim = {
    config = {
      opts = {
        number = true;
        relativenumber = true;
        splitright = true;
        splitbelow = true;
      };
      diagnostic.settings = {
        virtual_text = false;
      };
    };
  };
}
