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
  version = "0.0.10";

  src = fetchurl {
    url = "https://registry.npmjs.org/obsidian-headless/-/obsidian-headless-${version}.tgz";
    hash = "sha256-czph1wQyBa5F613AVrH9ZwHI6sWcVgbEVmX3wianTF4=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-vg1udNOnkp/pnzf4VXJUe90biQsu3AOwGVOw4FQM+3g=";

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
