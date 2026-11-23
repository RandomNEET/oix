{ config, ... }:
let
  isFoot = config.defaultPrograms.terminal.default == "foot";
in
{
  exe =
    if (isFoot && config.programs.foot.server.enable) then
      "footclient"
    else
      config.defaultPrograms.terminal.default;
  classFlag = if isFoot then "--app-id" else "--class";
}
