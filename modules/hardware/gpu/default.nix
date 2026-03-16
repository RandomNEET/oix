{ lib, opts, ... }:
{
  imports = lib.optional (opts ? gpu) ./${opts.gpu};
}
