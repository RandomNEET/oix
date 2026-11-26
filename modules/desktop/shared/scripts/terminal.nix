{ config }:
let
  isFoot = config.oix.defaults.terminal == "foot";
in
{
  exe =
    if (isFoot && config.programs.foot.server.enable) then
      "footclient"
    else
      config.oix.defaults.terminal;
  classFlag = if isFoot then "--app-id" else "--class";
}
