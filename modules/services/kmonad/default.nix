{ opts, ... }:
{
  services.kmonad = {
    enable = true;
    keyboards = opts.kmonad.keyboards or { };
  };
}
