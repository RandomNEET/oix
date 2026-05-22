{ pkgs, ... }:
pkgs.writeShellScriptBin "gamespace" ''
    CLIENTS_JSON=$(hyprctl clients -j)
    ACTIVE_WINDOW=$(hyprctl activewindow -j)

    readarray -t ALL_STEAM < <(echo "$CLIENTS_JSON" | jq -r '.[] | select(.class == "steam" or (.class == "gamescope" and .title == "Steam Big Picture Mode")) | .address')

  readarray -t STRAY_STEAM < <(echo "$CLIENTS_JSON" | jq -r '.[] | select((.class == "steam" or (.class == "gamescope" and .title == "Steam Big Picture Mode")) and .workspace.name != "special:gamespace") | .address')

    FOCUSED_ADDR=$(echo "$ACTIVE_WINDOW" | jq -r '.address')

    if [ "''${#ALL_STEAM[@]}" -eq 0 ]; then
        notify-send -a "gamespace" -i input-gaming -u low "Steam" "Starting Steam..."
        hyprctl dispatch 'hl.dsp.exec_cmd("steam")' > /dev/null
        
        TIMEOUT=300
        COUNTER=0
        
        while [ $COUNTER -lt $TIMEOUT ]; do
            sleep 0.1
            NEW_CLIENTS=$(hyprctl clients -j)
            
            MAIN_STEAM_READY=$(echo "$NEW_CLIENTS" | jq '[.[] | select((.class == "steam" and .title == "Steam") or (.class == "gamescope" and .title == "Steam Big Picture Mode"))] | length')
            
            if [ "$MAIN_STEAM_READY" -gt 0 ]; then
                CLIENTS_JSON=$NEW_CLIENTS
                readarray -t ALL_STEAM < <(echo "$CLIENTS_JSON" | jq -r '.[] | select(.class == "steam" or (.class == "gamescope" and .title == "Steam Big Picture Mode")) | .address')
                readarray -t STRAY_STEAM < <(echo "$CLIENTS_JSON" | jq -r '.[] | select((.class == "steam" or (.class == "gamescope" and .title == "Steam Big Picture Mode")) and .workspace.name != "special:gamespace") | .address')
                notify-send -a "gamespace" -i input-gaming -u low "Steam" "Main interface loaded, moving to gamespace."
                break
            fi
            ((COUNTER++))
        done
        
        if [ $COUNTER -eq $TIMEOUT ]; then
            notify-send -a "gamespace" -i input-gaming -u normal "Steam" "Waiting for Steam timed out. Please run the script again."
            exit 1
        fi
    fi

    IS_VISIBLE=$(hyprctl monitors -j | jq -r '.[] | .specialWorkspace.name' | grep -c "special:gamespace" || true)

    FOCUSED_WORKSPACE=$(echo "$ACTIVE_WINDOW" | jq -r '.workspace.name')

    if [ "''${#STRAY_STEAM[@]}" -gt 0 ]; then
        for addr in "''${STRAY_STEAM[@]}"; do
            hyprctl dispatch "hl.dsp.window.move({ workspace = \"special:gamespace\", window = \"address:$addr\", follow = false })" > /dev/null
        done
        
        if [ "$IS_VISIBLE" -eq 0 ]; then
            hyprctl dispatch 'hl.dsp.workspace.toggle_special("gamespace")'> /dev/null
            sleep 0.2
        fi
        
        CLIENTS_JSON=$(hyprctl clients -j)
        
        readarray -t GROUPABLE_STEAM < <(echo "$CLIENTS_JSON" | jq -r '.[] | select((.class == "steam" or (.class == "gamescope" and .title == "Steam Big Picture Mode")) and .title != "Sign in to Steam" and .workspace.name == "special:gamespace") | .address')

        if [ "''${#GROUPABLE_STEAM[@]}" -gt 0 ]; then
        
            for addr in "''${GROUPABLE_STEAM[@]}"; do
                IS_FLOAT=$(echo "$CLIENTS_JSON" | jq -r ".[] | select(.address == \"$addr\") | .floating")
                if [ "$IS_FLOAT" = "true" ]; then
                    hyprctl dispatch "hl.dsp.window.float({ action = \"toggle\", window = \"address:$addr\" })" > /dev/null
                fi
            done
            
            sleep 0.1
            CLIENTS_JSON=$(hyprctl clients -j)

            FIRST_ADDR="''${GROUPABLE_STEAM[0]}"
            IS_FIRST_GROUPED=$(echo "$CLIENTS_JSON" | jq -r ".[] | select(.address == \"$FIRST_ADDR\") | .grouped | length")
            
            hyprctl dispatch "hl.dsp.focus({ window = \"$FIRST_ADDR\" })" > /dev/null
            sleep 0.1
            
            if [ "$IS_FIRST_GROUPED" -eq 0 ]; then
                hyprctl dispatch 'hl.dsp.group()' > /dev/null
                sleep 0.1
            fi
            
            for i in "''${!GROUPABLE_STEAM[@]}"; do
                if [ "$i" -eq 0 ]; then continue; fi
                
                addr="''${GROUPABLE_STEAM[$i]}"
                IS_ALREADY_GROUPED=$(echo "$CLIENTS_JSON" | jq -r ".[] | select(.address == \"$addr\") | .grouped | length")
                
                if [ "$IS_ALREADY_GROUPED" -eq 0 ]; then
                    hyprctl dispatch "hl.dsp.window.move({ into_group = \"l\", window = \"$addr\" })" > /dev/null
                    hyprctl dispatch "hl.dsp.window.move({ into_group = \"r\", window = \"$addr\" })" > /dev/null
                    hyprctl dispatch "hl.dsp.window.move({ into_group = \"u\", window = \"$addr\" })" > /dev/null
                    hyprctl dispatch "hl.dsp.window.move({ into_group = \"d\", window = \"$addr\" })" > /dev/null
                fi
            done
        fi

    elif [ "$IS_VISIBLE" -gt 0 ] && [ "$FOCUSED_WORKSPACE" = "special:steam" ]; then
        hyprctl dispatch 'hl.dsp.workspace.toggle_special("gamespace")' > /dev/null

    elif [ "$IS_VISIBLE" -eq 0 ]; then
        hyprctl dispatch 'hl.dsp.workspace.toggle_special("gamespace")' > /dev/null

    else
        hyprctl dispatch 'hl.dsp.workspace.toggle_special("gamespace")' > /dev/null
    fi
''
