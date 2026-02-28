{
  lib,
  fetchFromGitHub,
  pkgs,
  stdenv,
  config,
}:

let
  rtpPath = "share/tmux-plugins";

  addRtp =
    path: rtpFilePath: attrs: derivation:
    derivation
    // {
      rtp = "${derivation}/${path}/${rtpFilePath}";
    }
    // {
      overrideAttrs = f: mkTmuxPlugin (attrs // (if lib.isFunction f then f attrs else f));
    };

  mkTmuxPlugin =
    a@{
      pluginName,
      rtpFilePath ? (builtins.replaceStrings [ "-" ] [ "_" ] pluginName) + ".tmux",
      namePrefix ? "tmuxplugin-",
      src,
      unpackPhase ? "",
      configurePhase ? ":",
      buildPhase ? ":",
      addonInfo ? null,
      preInstall ? "",
      postInstall ? "",
      path ? lib.getName pluginName,
      ...
    }:
    if lib.hasAttr "dependencies" a then
      throw "dependencies attribute is obselete. see NixOS/nixpkgs#118034" # added 2021-04-01
    else
      addRtp "${rtpPath}/${path}" rtpFilePath a (
        stdenv.mkDerivation (
          a
          // {
            pname = namePrefix + pluginName;

            strictDeps = true;

            inherit
              pluginName
              unpackPhase
              configurePhase
              buildPhase
              addonInfo
              preInstall
              postInstall
              ;

            installPhase = ''
              runHook preInstall

              target=$out/${rtpPath}/${path}
              mkdir -p $out/${rtpPath}
              cp -r . $target
              if [ -n "$addonInfo" ]; then
                echo "$addonInfo" > $target/addon-info.json
              fi

              runHook postInstall
            '';
          }
        )
      );

in
{
  inherit mkTmuxPlugin;

  dotbar = mkTmuxPlugin rec {
    pluginName = "dotbar";
    version = "0.3.1";
    src = fetchFromGitHub {
      owner = "vaaleyard";
      repo = "tmux-dotbar";
      tag = version;
      hash = "sha256-tL9cB27toxE3ZfJ+5srk1wSIyOkno7/SRKQBvgcfFPM=";
    };
    meta = {
      homepage = "https://github.com/vaaleyard/tmux-dotbar";
      downloadPage = "https://github.com/vaaleyard/tmux-dotbar";
      description = "Simple and minimalist status bar for tmux";
      changelog = "https://github.com/vaaleyard/tmux-dotbar/releases/tag/${version}";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
    };
  };
}
