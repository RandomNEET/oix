{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cliwt";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "HenryLoM";
    repo = "CliWaifuTamagotchi";
    rev = "v${version}";
    hash = "sha256-2Hh68ff6jopHAIziR4v0VjjTLnwhItrJulThbCQLxaU=";
  };

  vendorHash = "sha256-SZLAIcWBX/WC0vBxKK0bbLICWOqlIOMjGtk1xXPlSNc=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "CLI ASCII avatar for entertainment and motivational purposes";
    homepage = "https://github.com/HenryLoM/CliWaifuTamagotchi/";
    license = licenses.gpl3Only;
    mainProgram = "cliwt";
    platforms = platforms.linux;
  };
}
