{
  inputs,
  lib,
  mylib,
  meta,
  ...
}:
{
  oix.defaults.editor = lib.mkDefault "nvim";
  imports = [
    (
      if (meta.channel == "unstable") then
        inputs.nixvim.homeModules.nixvim
      else
        inputs.nixvim-stable.homeModules.nixvim
    )
  ]
  ++ mylib.util.scanPaths ./. { types = [ "directory" ]; };
}
