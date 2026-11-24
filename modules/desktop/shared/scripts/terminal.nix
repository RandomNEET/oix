{ config, ... }:
let
  isFoot = (config.oix.defaults.terminal or null) == "foot";
in
{
  exe =
    if (isFoot && config.programs.foot.server.enable) then
      "footclient"
    else
      (config.oix.defaults.terminal or null);
  classFlag = if isFoot then "--app-id" else "--class";
}
