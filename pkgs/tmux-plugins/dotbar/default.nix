{
  lib,
  fetchFromGitHub,
  mkTmuxPlugin,
}:
mkTmuxPlugin rec {
  pluginName = "dotbar";
  version = "0.3.2";
  src = fetchFromGitHub {
    owner = "vaaleyard";
    repo = "tmux-dotbar";
    tag = version;
    hash = "sha256-WaRKepmPqiE+W8Tm0dBc6hGiqqZP122eXjrG0rJnt0w=";
  };
  meta = {
    homepage = "https://github.com/vaaleyard/tmux-dotbar";
    downloadPage = "https://github.com/vaaleyard/tmux-dotbar";
    description = "Simple and minimalist status bar for tmux";
    changelog = "https://github.com/vaaleyard/tmux-dotbar/releases/tag/${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
