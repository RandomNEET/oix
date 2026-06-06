{
  programs.fd = {
    enable = true;
    hidden = true;
    ignores = [
      ".git/"
    ];
  };
  home.shellAliases = {
    fda = "fd --no-ignore --absolute-path";
  };
}
