{ lib, ... }:
{
  util = {
    # Smart path scanner
    # Takes a target path and a configuration attribute set
    scanPaths =
      path:
      {
        types ? [
          "directory"
          "regular"
        ], # Allowed types to collect: "directory", "regular", "symlink"
        exclude ? [ "default.nix" ], # Blacklist of names to exclude
        extension ? ".nix", # Extension that regular files must match (pass null for no restriction)
        depth ? 1, # Scan depth: 1 means scanning only the current directory without going deeper
      }:
      let
        # Internal recursive function
        scan =
          currentPath: currentDepth:
          let
            content = builtins.readDir currentPath;

            # 1. Filter out names in the blacklist
            filtered = lib.filterAttrs (name: _: !(builtins.elem name exclude)) content;

            # 2. Collect targets matching the criteria at the current level
            matches = lib.mapAttrsToList (
              name: type:
              let
                fullPath = currentPath + "/${name}";
                isMatchDir = type == "directory" && builtins.elem "directory" types;
                isMatchFile =
                  type == "regular"
                  && builtins.elem "regular" types
                  && (extension == null || lib.hasSuffix extension name);
                isMatchSymlink = type == "symlink" && builtins.elem "symlink" types;
              in
              if isMatchDir || isMatchFile || isMatchSymlink then fullPath else null
            ) filtered;

            # Filter out null values
            currentLevelItems = builtins.filter (x: x != null) matches;

            # 3. Pick out directories to prepare for potential recursive drill-down
            dirsToRecurse = lib.mapAttrsToList (
              name: type: if type == "directory" then currentPath + "/${name}" else null
            ) filtered;

            validDirs = builtins.filter (x: x != null) dirsToRecurse;

            # 4. If the maximum depth hasn't been reached, recursively merge results from subdirectories
            subItems =
              if currentDepth < depth then
                builtins.concatLists (builtins.map (d: scan d (currentDepth + 1)) validDirs)
              else
                [ ];
          in
          currentLevelItems ++ subItems;
      in
      scan path 1;
  };
}
