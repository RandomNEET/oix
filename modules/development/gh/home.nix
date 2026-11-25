{ config, ... }:
{
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      editor = config.oix.defaults.editor;
    };
  };
}
