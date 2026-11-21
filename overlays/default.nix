{ inputs, mylib }:
builtins.map (file: import file { inherit inputs; }) (mylib.util.scanPaths ./. { })
