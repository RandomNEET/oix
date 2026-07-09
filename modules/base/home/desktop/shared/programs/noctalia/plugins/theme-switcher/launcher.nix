{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) optionalString;
  defaultTheme =
    if osConfig.desktop.themes.enable then builtins.head osConfig.desktop.themes.list else "default";
in
''
  local SPEC_DIR = noctalia.expandPath(noctalia.getConfig("spec_dir"))
  local BASE_GEN = noctalia.expandPath(noctalia.getConfig("base_gen"))
  local DEFAULT_THEME = "default"

  local function listThemes()
    local themes = {}
    local ok, entries = pcall(noctalia.listDir, SPEC_DIR)
    if ok and entries then
      for _, name in ipairs(entries) do
        if name ~= "" and name ~= "." and name ~= ".." then
          themes[#themes + 1] = name
        end
      end
    end
    return themes
  end

  local function runActivationAndHooks(selectedTheme)
    local activatePath = selectedTheme == "__default__" and (BASE_GEN .. "/activate")
      or (SPEC_DIR .. "/" .. selectedTheme .. "/activate")
    local wpTheme = selectedTheme == "__default__" and "${defaultTheme}" or selectedTheme

    noctalia.runAsync(string.format(
      [[
      set -e
      
      "%s"

      ${optionalString (config.desktop.wallpaper.enable && osConfig.base.display.info != [ ]) (
        let
          genWallpaperCmd = m: ''
            CURRENT_WP=$(noctalia msg wallpaper-get "${m.output}")

            if [ -n "$CURRENT_WP" ]; then
              NEW_WP=$(echo "$CURRENT_WP" | sed -E 's@/(themed/[^/]+|original)/@/themed/%s/@')

              if [ -f "$NEW_WP" ]; then
                noctalia msg wallpaper-set "${m.output}" "$NEW_WP"
              else
                notify-send -a "Theme Switcher" -u normal "Wallpaper not found" "Path: $NEW_WP"
              fi
            fi
          '';
        in
        lib.concatMapStringsSep "\n" genWallpaperCmd osConfig.base.display.info
      )}

      noctalia msg config-reload || true
      
      ${optionalString osConfig.desktop.mango.enable ''
        if systemctl --user -q is-active mango-session.target; then
          mmsg dispatch reload_config
        fi
      ''}
      
      ${optionalString (config.i18n.inputMethod.type == "fcitx5") ''
        systemctl --user restart fcitx5-daemon
      ''}
      
      ${optionalString config.programs.tmux.enable ''
        if tmux ls > /dev/null 2>&1; then
          tmux source-file ${config.xdg.configHome}/tmux/tmux.conf
        fi
      ''} 
      
      ${optionalString config.programs.nixvim.enable ''
        RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(${pkgs.coreutils}/bin/id -u)}"
        if pgrep -x "nvim" >/dev/null; then
          for server in "$RUNTIME_DIR"/nvim.*.0; do
            [ -e "$server" ] || continue
            pid=$(basename "$server" | cut -d. -f2)
            if kill -0 "$pid" 2>/dev/null; then
              nvim --server "$server" --remote-expr "execute('lua if _G.reload_theme then _G.reload_theme() end')" >/dev/null 2>&1 &
            else
              rm -f "$server"
            fi
          done
        fi
      ''} 
    ]],
      activatePath,
      wpTheme:gsub("'", "'\\''''")
  	))
  end

  local function makeResult(theme)
  	return {
  		id = theme,
  		title = theme,
  		subtitle = SPEC_DIR .. "/" .. theme,
  		glyph = "palette",
  	}
  end

  function onQuery(text)
  	if text == "" then
  		local results = {}
  		for _, theme in ipairs(listThemes()) do
  			results[#results + 1] = makeResult(theme)
  		end
  		results[#results + 1] = {
  			id = "__default__",
  			title = "${defaultTheme}",
  			subtitle = "Activate the default home-manager profile",
  		  glyph = "palette",
  		}
  		launcher.setResults(text, results)
  		return
  	end

  	local lower = text:lower()
  	local results = {}

  	for _, theme in ipairs(listThemes()) do
  		if theme:lower():find(lower, 1, true) then
  			results[#results + 1] = makeResult(theme)
  		end
  	end

  	if DEFAULT_THEME:lower():find(lower, 1, true) then
  		results[#results + 1] = {
  			id = "__default__",
  			title = "${defaultTheme}",
  			subtitle = "Activate the default home-manager profile",
  		  glyph = "palette",
  		}
  	end

  	if #results == 0 then
  		results[#results + 1] = { id = "__none__", title = "No matching theme", glyph = "search-off" }
  	end

  	launcher.setResults(text, results)
  end

  function onActivate(id)
  	if id ~= "__none__" and id ~= "" then
  		runActivationAndHooks(id)
  	end
  end
''
