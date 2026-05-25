{ pkgs, ... }:
let
  isNixos = true;
  profileDir = if isNixos then "/nix/var/nix/profiles" else "$HOME/.local/state/nix/profiles";
  profileName = if isNixos then "system" else "home-manager";
  profilePattern = "${profileDir}/${profileName}-*-link";
  currentProfile = "${profileDir}/${profileName}";
  gen-diff = pkgs.writeShellScriptBin "gen-diff" ''
    # Dependency
    COREUTILS="${pkgs.coreutils}/bin/coreutils"
    SED="${pkgs.gnused}/bin/sed"
    AWK="${pkgs.gawk}/bin/awk"
    LESS="${pkgs.less}/bin/less"
    NIX_DIFF="${pkgs.nix-diff}/bin/nix-diff"
    NVD="${pkgs.nvd}/bin/nvd"
    FZF="${pkgs.fzf}/bin/fzf"

    # --- Generate Generation List ---
    gen_list=$(
      for link in ${profilePattern}; do
        if [ -L "$link" ] && [ -e "$link" ]; then
          num=$(basename "$link" | sed 's/.*-\([0-9]*\)-link/\1/')
          date=$($COREUTILS/bin/stat -c %y "$link" 2>/dev/null | cut -d. -f1 || echo "Unknown Date")
          echo "$num | $date | $link"
        fi
      done | sort -rn
    )

    # --- Interactive Selection ---
    selection=$(echo "''$gen_list" | $FZF \
      --multi=2 \
      --ansi \
      --delimiter ' \| ' \
      --header "Tab: Select TWO to diff | Enter: Run Comparison" \
      --preview "$NVD diff {3} ${currentProfile} 2>/dev/null | head -n 50")

    [ -z "''$selection" ] && exit 0

    paths=($(echo "''$selection" | $AWK -F ' | ' '{print ''$NF}' | head -n 2))

    # --- Execution Logic ---
    DIFF_OPTS=(
        "--character-oriented"
        "--color" "always"
    )
    LESS_OPTS="-RFX"

    if [ ''${#paths[@]} -eq 2 ]; then
        echo -e "\033[1;32mComparing Gen ''${paths[1]} (Old) <-> Gen ''${paths[0]} (New)...\033[0m"
        $NIX_DIFF "''${DIFF_OPTS[@]}" "''${paths[1]}" "''${paths[0]}" | $SED -e 's/41m/31;1m/g' -e 's/42m/32;1m/g' | $LESS ''$LESS_OPTS
    elif [ ''${#paths[@]} -eq 1 ]; then
        current=$(readlink -f ${currentProfile})
        echo -e "\033[1;32mComparing Gen ''${paths[0]} <-> Current System...\033[0m"
        $NIX_DIFF "''${DIFF_OPTS[@]}" "''${paths[0]}" "''$current" | $SED -e 's/41m/31;1m/g' -e 's/42m/32;1m/g' | $LESS ''$LESS_OPTS
    else
        echo -e "\033[1;31mError: Invalid selection.\033[0m"
    fi
  '';
in
{
  environment.systemPackages = [ gen-diff ];
}
