{
  home-manager.sharedModules = [
    (_: {
      programs.fzf = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        tmux.enableShellIntegration = true;
        colors = {
          "bg+" = "#313244";
          bg = "#1E1E2E";
          spinner = "#F5E0DC";
          hl = "#F38BA8";
          fg = "#CDD6F4";
          header = "#F38BA8";
          info = "#CBA6F7";
          pointer = "#F5E0DC";
          marker = "#B4BEFE";
          "fg+" = "#CDD6F4";
          prompt = "#CBA6F7";
          "hl+" = "#F38BA8";
          "selected-bg" = "#45475A";
          border = "#313244";
          label = "#CDD6F4";
        };
      };
      programs.zsh = {
        initContent = ''
          bindkey '^f' "fzf-file-widget"
        '';
      };
    })
  ];
}
