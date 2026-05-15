# https://github.com/obsidianmd/obsidian-headless
{
  lib,
  buildNpmPackage,
  fetchurl,
  python3,
  pkg-config,
}:

buildNpmPackage rec {
  pname = "obsidian-headless";
  version = "0.0.8";

  src = fetchurl {
    url = "https://registry.npmjs.org/obsidian-headless/-/obsidian-headless-${version}.tgz";
    hash = "sha256-+fg6tr69/7n73KhlJxAb4ujMOvH64hLwIt/6MeAiNtU=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-/g3PV+VJ7zotOn70a3J6lJR5Bz0v24vyI540Pe10MJI= ";

  nativeBuildInputs = [
    python3
    pkg-config
  ];

  dontNpmBuild = true;

  meta = with lib; {
    description = "Headless client for Obsidian services";
    homepage = "https://obsidian.md";
    license = licenses.unfree;
    maintainers = [ ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
