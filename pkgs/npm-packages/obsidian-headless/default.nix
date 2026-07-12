{
  lib,
  buildNpmPackage,
  fetchurl,
  python3,
  pkg-config,
}:
buildNpmPackage rec {
  pname = "obsidian-headless";
  version = "0.0.13";

  src = fetchurl {
    url = "https://registry.npmjs.org/obsidian-headless/-/obsidian-headless-${version}.tgz";
    hash = "sha256-m44a05F6ZdU8WrdNBqz17I2UHjsCvZvV0DXWgA5TMZg=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-9CrEHMWe3fhqk6gK/jtU01RaZWVxcKEG5ItRgIYO0FQ=";

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
