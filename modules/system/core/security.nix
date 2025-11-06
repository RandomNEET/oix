{ opts, ... }:
{
  security.sudo = {
    extraConfig = ''
      Defaults lecture = never
    ''
    + (opts.sudo.extraConfig or "");
  };
}
