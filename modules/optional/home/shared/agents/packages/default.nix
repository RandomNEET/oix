{ pkgs, ... }: {
  home.packages = with pkgs; [
    bubblewrap
    bun
    nodejs
    uv
  ];
}
