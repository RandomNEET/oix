{
  lib,
  buildNpmPackage,
  fetchurl,
  python3,
  pkg-config,
}:
buildNpmPackage rec {
  pname = "obsidian-headless";
  version = "0.0.12";

  src = fetchurl {
    url = "https://registry.npmjs.org/obsidian-headless/-/obsidian-headless-${version}.tgz";
    hash = "sha256-bSZ/1XdTEgAH4atw/NPx0OsP2ul78T1ea4xpu+7w/n0=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-b223nQmtFPIUln4YzQxzsNgpICsFmahirPXqAuupvXo=";

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
