{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "csakura";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "realstrawhat";
    repo = "csakura";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qf7u6BwHviL7kQuOTs936zsY5PiMzrtkcy007xr3p7M=";
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
