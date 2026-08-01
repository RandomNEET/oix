{
  lib,
  buildNpmPackage,
  fetchurl,
  python3,
  pkg-config,
}:
buildNpmPackage rec {
  pname = "obsidian-headless";
  version = "0.0.14";

  src = fetchurl {
    url = "https://registry.npmjs.org/obsidian-headless/-/obsidian-headless-${version}.tgz";
    hash = "sha256-73UpjtOjVtyypN6Yxu/hCyrGSwBVYAcRi2rHBTXnMVY=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-Pcy6hxgc9MyTe/a7bE4pMtXjG9hx4HNwZgbfIzTtVRQ=";

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
