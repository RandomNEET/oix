{ pkgs, ... }:
pkgs.writeShellScriptBin "gamespace" ''
  CLIENTS_JSON=$(hyprctl clients -j)
  ACTIVE_WINDOW=$(hyprctl activewindow -j)

  readarray -t ALL_STEAM < <(echo "$CLIENTS_JSON" | jq -r '.[] | select(.class == "steam" or (.class == "gamescope" and .title == "Steam Big Picture Mode")) | .address')

  readarray -t STRAY_STEAM < <(echo "$CLIENTS_JSON" | jq -r '.[] | select((.class == "steam" or (.class == "gamescope" and .title == "Steam Big Picture Mode")) and .workspace.name != "special:steam") | .address')

  FOCUSED_ADDR=$(echo "$ACTIVE_WINDOW" | jq -r '.address')

  if [ "''${#ALL_STEAM[@]}" -eq 0 ]; then
      notify-send -a "gamespace" -i input-gaming -u low "Steam" "Starting Steam..."
      hyprctl dispatch exec steam > /dev/null
      
      TIMEOUT=300
      COUNTER=0
      
      while [ $COUNTER -lt $TIMEOUT ]; do
          sleep 0.1
          NEW_CLIENTS=$(hyprctl clients -j)
          
          MAIN_STEAM_READY=$(echo "$NEW_CLIENTS" | jq '[.[] | select((.class == "steam" and .title == "Steam") or (.class == "gamescope" and .title == "Steam Big Picture Mode"))] | length')
          
          if [ "$MAIN_STEAM_READY" -gt 0 ]; then
              CLIENTS_JSON=$NEW_CLIENTS
              readarray -t ALL_STEAM < <(echo "$CLIENTS_JSON" | jq -r '.[] | select(.class == "steam" or (.class == "gamescope" and .title == "Steam Big Picture Mode")) | .address')
              readarray -t STRAY_STEAM < <(echo "$CLIENTS_JSON" | jq -r '.[] | select((.class == "steam" or (.class == "gamescope" and .title == "Steam Big Picture Mode")) and .workspace.name != "special:steam") | .address')
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

  IS_VISIBLE=$(hyprctl monitors -j | jq -r '.[] | .specialWorkspace.name' | grep -c "special:steam" || true)

  FOCUSED_WORKSPACE=$(echo "$ACTIVE_WINDOW" | jq -r '.workspace.name')

  if [ "''${#STRAY_STEAM[@]}" -gt 0 ]; then
      for addr in "''${STRAY_STEAM[@]}"; do
          hyprctl dispatch movetoworkspacesilent "special:steam,address:$addr" > /dev/null
      done
      
      if [ "$IS_VISIBLE" -eq 0 ]; then
          hyprctl dispatch togglespecialworkspace steam > /dev/null
          sleep 0.2
      fi
      
      CLIENTS_JSON=$(hyprctl clients -j)
      
      readarray -t GROUPABLE_STEAM < <(echo "$CLIENTS_JSON" | jq -r '.[] | select((.class == "steam" or (.class == "gamescope" and .title == "Steam Big Picture Mode")) and .title != "Sign in to Steam" and .workspace.name == "special:steam") | .address')

      if [ "''${#GROUPABLE_STEAM[@]}" -gt 0 ]; then
      
          for addr in "''${GROUPABLE_STEAM[@]}"; do
              IS_FLOAT=$(echo "$CLIENTS_JSON" | jq -r ".[] | select(.address == \"$addr\") | .floating")
              if [ "$IS_FLOAT" = "true" ]; then
                  hyprctl dispatch togglefloating "address:$addr" > /dev/null
              fi
          done
          
          sleep 0.1
          CLIENTS_JSON=$(hyprctl clients -j)

          FIRST_ADDR="''${GROUPABLE_STEAM[0]}"
          IS_FIRST_GROUPED=$(echo "$CLIENTS_JSON" | jq -r ".[] | select(.address == \"$FIRST_ADDR\") | .grouped | length")
          
          hyprctl dispatch focuswindow "address:$FIRST_ADDR" > /dev/null
          sleep 0.1
          
          if [ "$IS_FIRST_GROUPED" -eq 0 ]; then
              hyprctl dispatch togglegroup > /dev/null
              sleep 0.1
          fi
          
          for i in "''${!GROUPABLE_STEAM[@]}"; do
              if [ "$i" -eq 0 ]; then continue; fi
              
              addr="''${GROUPABLE_STEAM[$i]}"
              IS_ALREADY_GROUPED=$(echo "$CLIENTS_JSON" | jq -r ".[] | select(.address == \"$addr\") | .grouped | length")
              
              if [ "$IS_ALREADY_GROUPED" -eq 0 ]; then
                  hyprctl dispatch focuswindow "address:$addr" > /dev/null
                  sleep 0.1
                  hyprctl dispatch moveintogroup l > /dev/null
                  hyprctl dispatch moveintogroup r > /dev/null
                  hyprctl dispatch moveintogroup u > /dev/null
                  hyprctl dispatch moveintogroup d > /dev/null
              fi
          done
      fi

  elif [ "$IS_VISIBLE" -gt 0 ] && [ "$FOCUSED_WORKSPACE" = "special:steam" ]; then
      hyprctl dispatch togglespecialworkspace steam > /dev/null

  elif [ "$IS_VISIBLE" -eq 0 ]; then
      hyprctl dispatch togglespecialworkspace steam > /dev/null

  else
      hyprctl dispatch togglespecialworkspace steam > /dev/null
  fi
''
