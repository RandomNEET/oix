{
  programs.nixvim = {
    config = {
      opts = {
        ignorecase = true;
        smartcase = true;
        hlsearch = true;
        incsearch = true;

        wildmenu = true;
        wildmode = "longest:full,full";
        wildignorecase = true;

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
