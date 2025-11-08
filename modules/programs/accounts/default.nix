{
  imports = map (d: ./${d}) (
    builtins.filter (n: n != "default.nix" && (builtins.readDir ./.).${n} == "directory") (
      builtins.attrNames (builtins.readDir ./.)
    )
  );
}
