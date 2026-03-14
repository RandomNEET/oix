{ pkgs }:
let
  pythonEnv = pkgs.python3.withPackages (
    ps: with ps; [
      pip
      setuptools
      virtualenv
    ]
  );
in
pkgs.mkShell {
  packages = [ pythonEnv ];
  shellHook = ''
    echo "Python Dev Environment Loaded"

    if [ ! -d ".venv" ]; then
      echo "Creating virtual environment..."
      python -m venv .venv
    fi

    source .venv/bin/activate

    export LD_LIBRARY_PATH="${
      pkgs.lib.makeLibraryPath [
        pkgs.stdenv.cc.cc
        pkgs.zlib
      ]
    }:$LD_LIBRARY_PATH"
  '';
}
