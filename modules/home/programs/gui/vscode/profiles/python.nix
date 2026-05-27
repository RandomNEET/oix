{ pkgs }:
{
  extensions = with pkgs.vscode-extensions; [
    ms-python.python
  ];
}
