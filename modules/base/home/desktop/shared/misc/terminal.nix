{ config }:
let
  isFoot = config.defaultPrograms.terminal == "foot";
in
{
  exe =
    if (isFoot && config.programs.foot.server.enable) then
      "footclient"
    else
      config.defaultPrograms.terminal;
  classFlag = if isFoot then "--app-id" else "--class";
}
