{ pkgs }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    gcc
    gnumake
    cmake
    gdb
    pkg-config
    clang-tools
  ];
  buildInputs = with pkgs; [ zlib ];
  shellHook = ''
    echo "C/C++ Dev Environment Loaded"
    echo "Compiler: $(gcc --version | head -n1)"
  '';
}
