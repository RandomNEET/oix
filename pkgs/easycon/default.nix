# Package the cross-platform main branch; the latest stable release
# only provides Windows binaries. Linux support is limited to x86_64 by
# the upstream OpenCvSharp native runtime.
#
# When updating, refresh the source revision/hash and regenerate deps.json
# with passthru.fetch-deps. Use NuGet v3 flat-container URLs in the dependency
# manifest, as the legacy www.nuget.org endpoint may be unavailable.
#
# The package provides the Avalonia GUI (easycon) and CLI (ezcon).
# Configuration is stored in ~/.config/easycon; logs and downloaded Amiibo
# files are stored in ~/.local/share/easycon. Serial devices require the
# appropriate permissions, usually membership in the dialout group on NixOS.

{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,
  gtk3,
  stdenv,
  fontconfig,
  libX11,
  libICE,
  libSM,
  libXrandr,
  libXi,
  libXcursor,
  libGL,
  sdl3,
  tesseract,
  leptonica,
}:

buildDotnetModule (finalAttrs: {
  pname = "easycon";
  version = "unstable-2026-09-17";

  src = fetchFromGitHub {
    owner = "EasyConNS";
    repo = "EasyCon";
    rev = "76cdb216d00fc5e0fb8510dede85390a6c5f3d40";
    hash = "sha256-FFlaxe5YnB1OhUy5lFpQh2U9CwESel+w3lrhL0GZtIk=";
  };

  projectFile = [
    "src/EasyCon2.Avalonia/EasyCon2.Avalonia.csproj"
    "src/EasyCon2.CLI/EasyCon2.CLI.csproj"
  ];
  nugetDeps = ./deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  # Work around .NET 10.0.12 server GC CPU detection in build sandboxes.
  # https://github.com/dotnet/runtime/issues/133449
  env.DOTNET_gcServer = "0";
  executables = [
    "EasyCon2.Avalonia"
    "EasyCon2.CLI"
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    imagemagick
  ];
  buildInputs = [
    stdenv.cc.cc.lib
    gtk3
  ];
  runtimeDeps = [
    fontconfig
    libX11
    libICE
    libSM
    libXrandr
    libXi
    libXcursor
    libGL
    sdl3
    tesseract
    leptonica
  ];

  postPatch = ''
    # Use Nix's Tesseract rather than the bundled Linux binary.
    rm src/EzTesseract/runtimes/linux-x64/native/libtesseract.so
    # The store is read-only: logs belong in the user's data directory.
    substituteInPlace src/EasyCon2.Avalonia.Core/Services/LogService.cs src/EasyCon2.CLI/Program.cs \
      --replace-fail 'Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "logs")' \
      'Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "easycon", "logs")'
    substituteInPlace src/EasyCon2.Avalonia/ViewModels/ESPConfigViewModel.cs \
      --replace-fail 'Path.Combine(AppContext.BaseDirectory, "Amiibo")' \
      'Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "easycon", "Amiibo")'
  '';

  postInstall = ''
    # Use Nix's SDL, with its platform backends already linked correctly.
    ln -sf ${lib.getLib sdl3}/lib/libSDL3.so.0 "$out/lib/easycon/libSDL3.so"
    ln -s ${tesseract}/share/tessdata "$out/lib/easycon/Tessdata"
    cp -r assets/fw "$out/lib/easycon/Firmware"
    mkdir -p "$out/share/icons/hicolor/256x256/apps"
    magick 'src/EasyCon2.Avalonia/Resources/Images/favicon.ico[0]' -resize 256x256 \
      "$out/share/icons/hicolor/256x256/apps/easycon.png"
  '';

  postFixup = ''
    mv "$out/bin/EasyCon2.Avalonia" "$out/bin/easycon"
    mv "$out/bin/EasyCon2.CLI" "$out/bin/ezcon"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "easycon";
      desktopName = "EasyCon";
      comment = "Nintendo Switch automation";
      exec = "easycon";
      icon = "easycon";
      categories = [ "Utility" ];
    })
  ];

  meta = {
    description = "Nintendo Switch automation with scripting, image recognition and controller input";
    homepage = "https://github.com/EasyConNS/EasyCon";
    license = lib.licenses.gpl3Only;
    # Upstream only ships the OpenCvSharp native runtime for Linux x86-64.
    platforms = [ "x86_64-linux" ];
    mainProgram = "easycon";
  };
})
