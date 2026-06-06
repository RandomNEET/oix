{ config, ... }:
{
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      editor = config.defaultPrograms.editor;
    };
  };
}
