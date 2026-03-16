{ pkgs, isExt, ... }:
if isExt then
  pkgs.writeShellScriptBin "gen-diff" ''
    # Dependency
    NIX_DIFF="${pkgs.nix-diff}/bin/nix-diff"
    NVD="${pkgs.nvd}/bin/nvd"
    AWK="${pkgs.gawk}/bin/awk"
    COREUTILS="${pkgs.coreutils}/bin/coreutils"
    FZF="${pkgs.fzf}/bin/fzf"
    LESS="${pkgs.less}/bin/less"

    # --- Generate Generation List ---
    gen_list=$(
      for link in $HOME/.local/state/nix/profiles/home-manager-*-link; do
        if [ -L "$link" ] && [ -e "$link" ]; then
          num=$(basename "$link" | sed 's/home-manager-\([0-9]*\)-link/\1/')
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
      --preview "$NVD diff {3} $HOME/.local/state/nix/profiles/home-manager 2>/dev/null | head -n 50")

    [ -z "''$selection" ] && exit 0

    paths=($(echo "''$selection" | $AWK -F ' | ' '{print ''$NF}' | head -n 2))

    # --- Execution Logic ---
    DIFF_OPTS=(
        "--color" "always"
    )
    LESS_OPTS="-RFX"

    if [ ''${#paths[@]} -eq 2 ]; then
        echo -e "\033[1;32mComparing Gen ''${paths[1]} (Old) <-> Gen ''${paths[0]} (New)...\033[0m"
        $NIX_DIFF "''${DIFF_OPTS[@]}" "''${paths[1]}" "''${paths[0]}" | $LESS ''$LESS_OPTS
    elif [ ''${#paths[@]} -eq 1 ]; then
        current=$(readlink -f $HOME/.local/state/nix/profiles/home-manager)
        echo -e "\033[1;32mComparing Gen ''${paths[0]} <-> Current System...\033[0m"
        $NIX_DIFF "''${DIFF_OPTS[@]}" "''${paths[0]}" "''$current" | $LESS ''$LESS_OPTS
    else
        echo -e "\033[1;31mError: Invalid selection.\033[0m"
    fi
  ''
else
  pkgs.writeShellScriptBin "gen-diff" ''
    # Dependency
    NIX_DIFF="${pkgs.nix-diff}/bin/nix-diff"
    NVD="${pkgs.nvd}/bin/nvd"
    AWK="${pkgs.gawk}/bin/awk"
    COREUTILS="${pkgs.coreutils}/bin/coreutils"
    FZF="${pkgs.fzf}/bin/fzf"
    LESS="${pkgs.less}/bin/less"

    # --- Generate Generation List ---
    gen_list=$(
      for link in /nix/var/nix/profiles/system-*-link; do
        if [ -L "$link" ] && [ -e "$link" ]; then
          num=$(basename "$link" | cut -d- -f2)
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
      --preview "$NVD diff {3} /nix/var/nix/profiles/system 2>/dev/null | head -n 50")

    [ -z "''$selection" ] && exit 0

    paths=($(echo "''$selection" | $AWK -F ' | ' '{print ''$NF}' | head -n 2))

    # --- Execution Logic ---
    DIFF_OPTS=(
        "--color" "always"
    )
    LESS_OPTS="-RFX"

    if [ ''${#paths[@]} -eq 2 ]; then
        echo -e "\033[1;32mComparing Gen ''${paths[1]} (Old) <-> Gen ''${paths[0]} (New)...\033[0m"
        $NIX_DIFF "''${DIFF_OPTS[@]}" "''${paths[1]}" "''${paths[0]}" | $LESS ''$LESS_OPTS
    elif [ ''${#paths[@]} -eq 1 ]; then
        current=$(readlink -f /nix/var/nix/profiles/system)
        echo -e "\033[1;32mComparing Gen ''${paths[0]} <-> Current System...\033[0m"
        $NIX_DIFF "''${DIFF_OPTS[@]}" "''${paths[0]}" "''$current" | $LESS ''$LESS_OPTS
    else
        echo -e "\033[1;31mError: Invalid selection.\033[0m"
    fi
  ''
