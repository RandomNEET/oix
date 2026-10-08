{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "csakura";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "realstrawhat";
    repo = "csakura";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9u1cpeMpSVnWJttEpTHcD9eRDARPC55LkObMblRiA/U=";
  };

  buildInputs = [ ncurses ];
  makeFlags = [ "PREFIX=$(out)" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-v";
  doInstallCheck = true;

  meta = {
    description = "A sakura tree with falling petals for your terminal — in the spirit of cmatrix and cava, but prettier.";
    homepage = "https://github.com/realstrawhat/csakura";
    platforms = ncurses.meta.platforms;
    license = lib.licenses.mit;
    mainProgram = "csakura";
  };
})
