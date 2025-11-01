{
  programs.nixvim = {
    plugins.persistence = {
      enable = true;
      settings = {
        dir.__raw = ''vim.fn.stdpath("state") .. "/sessions/"'';
        need = 1;
        branch = true;
      };
    };
  };
}
