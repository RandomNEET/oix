{
  config,
  lib,
  pkgs,
  opts,
  hostname,
  isExt,
  isWsl,
  ...
}:
let
  # Function to recursively find all .nix files
  findNixFiles =
    {
      path,
      isTopLevel ? false,
    }:
    let
      # Use readDir to get all entries in the directory
      entries = builtins.readDir path;

      # Filter: must be a .nix file and not 'default.nix' if at top level
      nixFileFilter =
        name: type:
        type == "regular" && lib.hasSuffix ".nix" name && (!isTopLevel || name != "default.nix");

      # Collect matching files in current directory
      files = lib.filterAttrs nixFileFilter entries;
      filePaths = map (name: path + "/${name}") (lib.attrNames files);

      # Collect subdirectories for recursion
      dirs = lib.filterAttrs (_: type: type == "directory") entries;
      subDirPaths = map (name: path + "/${name}") (lib.attrNames dirs);

      # Recurse into subdirectories
      subFiles = lib.concatMap (dir: findNixFiles { path = dir; }) subDirPaths;
    in
    filePaths ++ subFiles;

  # Core logic to scan, import, and validate script derivations
  collectScripts =
    targetPath:
    # Check if the path exists (Git/Flakes will ignore empty directories)
    if !(builtins.pathExists targetPath) then
      builtins.trace "Notice: ${toString targetPath} does not exist or is empty, skipping." [ ]
    else
      let
        # Find all .nix files in the target directory
        nixFiles = findNixFiles {
          path = targetPath;
          isTopLevel = true;
        };

        # Import each file and ensure it returns a derivation
        importScript =
          file:
          let
            fileName = builtins.baseNameOf file;
            # Import the file with the scope's arguments
            imported = import file {
              inherit
                config
                lib
                pkgs
                opts
                hostname
                isExt
                isWsl
                ;
            };

            # Check if it's a function (like pkgs: ...) or a direct derivation
            isFunction = builtins.isFunction imported;
            drv = if isFunction then imported pkgs else imported;
          in
          {
            inherit file fileName drv;
            isValid = lib.isDerivation drv;
            error = "Script '${fileName}' did not evaluate to a valid derivation";
          };

        # Process all found files
        allResults = map importScript nixFiles;

        # Log warnings for invalid scripts
        invalid = builtins.filter (s: !s.isValid) allResults;
        _ = builtins.map (s: builtins.trace "Warning: ${s.error} (${toString s.file})" null) invalid;

        # Return only valid derivations
        validDrvs = builtins.map (s: s.drv) (builtins.filter (s: s.isValid) allResults);
      in
      validDrvs;

  # Scan both directories
  homeScripts = collectScripts ./home;
  systemScripts = collectScripts ./system;

  # Summary trace for debugging
  _ = builtins.trace "Script Scanner: Found ${toString (builtins.length homeScripts)} home scripts and ${toString (builtins.length systemScripts)} system scripts." null;
in
{
  # User-level packages (Home Manager)
  home-manager.sharedModules = [ { home.packages = homeScripts; } ];

  # System-level packages (NixOS)
  environment.systemPackages = systemScripts;
}
