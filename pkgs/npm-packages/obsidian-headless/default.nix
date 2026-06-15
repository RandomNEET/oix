{
  lib,
  buildNpmPackage,
  fetchurl,
  python3,
  pkg-config,
}:
buildNpmPackage rec {
  pname = "obsidian-headless";
  version = "0.0.11";

  src = fetchurl {
    url = "https://registry.npmjs.org/obsidian-headless/-/obsidian-headless-${version}.tgz";
    hash = "sha256-qFS4tmDE2nRgD94s5Fm58CsEcFjctIR4at1LkuTo+sE=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-W7lZzF0AfFIz/0S+3qEwUYFiqSzXziDohkqk+bLhwc8=";

  nativeBuildInputs = [
    python3
    pkg-config
  ];

  dontNpmBuild = true;

  meta = with lib; {
    description = "Headless client for Obsidian services";
    homepage = "https://github.com/obsidianmd/obsidian-headless";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
