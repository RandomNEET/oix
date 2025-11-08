{ opts, ... }:
{
  security = {
    sudo = {
      enable = true;
      keepTerminfo = opts.sudo.keepTerminfo or true;
      execWheelOnly = opts.sudo.execWheelOnly or false;
      wheelNeedsPassword = opts.sudo.wheelNeedsPassword or true;
      configFile = ''
        Defaults lecture = never
      ''
      + (opts.sudo.configFile or "");
      defaultOptions = [ "SETENV" ] ++ (opts.sudo.defaultOptions or [ ]);
      extraConfig = '''' + (opts.sudo.extraConfig or "");
      extraRules = [ ] ++ (opts.sudo.extraRules or [ ]);
    };
  };
}
