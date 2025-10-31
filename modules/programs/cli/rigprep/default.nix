{ ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.ripgrep = {
        enable = true;
        arguments = [
          "--max-columns-preview"
          "--colors=line:style:bold"
        ];
      };
    })
  ];
}
