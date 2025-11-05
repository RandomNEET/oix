{ opts, ... }:
{
  security.sudo = {
    extraConfig =
      opts.sudo.extraConfig or ''
        Defaults lecture = never
      '';
  };
}
