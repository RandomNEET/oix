# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/inputmethods/fcitx5/fcitx5-rime.nix
# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/ri/rime-ice/package.nix
# https://github.com/fcitx/fcitx5-rime
# https://github.com/iDvel/rime-ice
{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  fetchurl,
  pkg-config,
  cmake,
  extra-cmake-modules,
  gettext,
  zstd,
  fcitx5,
  librime,
  rime-data,
  symlinkJoin,
}:
let
  rime-ice = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "rime-ice";
    version = "2025.12.08";

    src = fetchFromGitHub {
      owner = "iDvel";
      repo = "rime-ice";
      tag = finalAttrs.version;
      hash = "sha256-GyiOlTr1Nw2ANTE7/fdyrPQkvRFWOyal3oAcDvsqF5A=";
    };

    installPhase = ''
      runHook preInstall
      rm -rf others README.md .git*
      mv default.yaml rime_ice_suggestion.yaml

      mkdir -p $out/share/rime-data
      cp -r . $out/share/rime-data
      runHook postInstall
    '';
  });

  combinedRimeData = symlinkJoin {
    name = "rime-data-combined";
    paths = [
      rime-data
      rime-ice
    ];
    postBuild = ''
      mkdir -p $out/share/rime-data
      [ -e "$out/share/rime-data/default.yaml" ] || touch "$out/share/rime-data/default.yaml"
    '';
  };
in
stdenv.mkDerivation rec {
  pname = "fcitx5-rime";
  version = "5.1.12";

  src = fetchurl {
    url = "https://download.fcitx-im.org/fcitx5/${pname}/${pname}-${version}.tar.zst";
    hash = "sha256-A7x7PQiyPAprJRg1tdk1Amq7pAhe8ney2KX9+9F0mK4=";
  };

  cmakeFlags = [
    "-DRIME_DATA_DIR=${placeholder "out"}/share/rime-data"
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    gettext
    zstd
  ];

  buildInputs = [
    fcitx5
    librime
  ];

  postInstall = ''
    mkdir -p $out/share/rime-data
    cp -pRL "${combinedRimeData}/share/rime-data/." $out/share/rime-data/
  '';

  meta = {
    description = "RIME support for Fcitx5 with Rime-Ice configuration";
    homepage = "https://github.com/iDvel/rime-ice";
    platforms = lib.platforms.linux;
  };
}
