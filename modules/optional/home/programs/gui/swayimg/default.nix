{
  osConfig,
  config,
  lib,
  ...
}:
let
  themesEnabled = osConfig.desktop.themes.enable;
  colors = config.lib.stylix.colors.withHashtag;
  hex = c: builtins.substring 1 6 c;
in
{
  programs.swayimg = {
    enable = true;
    initLua = ''
      -- General settings

      swayimg.mode = "viewer"
      swayimg.overlay = true
      swayimg.antialiasing = true
      swayimg.exif_orientation = true
      swayimg.decoration = true

      -- Viewer / Slideshow appearance

      swayimg.viewer.default_scale = "optimal"
      swayimg.viewer.default_position = "center"
      swayimg.slideshow.default_scale = "fit"

      -- Info overlay

      swayimg.viewer.set_text("topleft", {
      	"+{name}",
      	"+{format}",
      	"+{sizehr}",
      	"+{frame.width}x{frame.height}",
      	"+{meta.Exif.Photo.DateTimeOriginal}",
      })
      swayimg.viewer.set_text("topright", {
      	"{list.index} of {list.total}",
      })
      swayimg.viewer.set_text("bottomleft", {
      	"{scale}",
      	"{frame.index} of {frame.total}",
      })
      swayimg.viewer.set_text("bottomright", {})
      swayimg.slideshow.set_text("topleft", {})
      swayimg.slideshow.set_text("topright", {})
      swayimg.slideshow.set_text("bottomleft", {})
      swayimg.slideshow.set_text("bottomright", {
      	"{dir}",
      })
      swayimg.gallery.set_text("topleft", {})
      swayimg.gallery.set_text("topright", {})
      swayimg.gallery.set_text("bottomleft", {})
      swayimg.gallery.set_text("bottomright", {
      	"{name}",
      })

      -- Helper functions

      local antialiasing_enabled = true
      local function toggle_antialiasing()
      	antialiasing_enabled = not antialiasing_enabled
      	swayimg.antialiasing = antialiasing_enabled
      	swayimg.text.status = "Anti-aliasing: " .. (antialiasing_enabled and "on" or "off")
      end
      local function toggle_info()
      	swayimg.text.visible = not swayimg.text.visible
      end
      local slideshow_timeout = 5
      local slideshow_paused = false
      local function toggle_slideshow_pause()
      	slideshow_paused = not slideshow_paused
      	if slideshow_paused then
      		swayimg.slideshow.timeout = 0
      		swayimg.text.status = "Slideshow: paused"
      	else
      		swayimg.slideshow.timeout = slideshow_timeout
      		swayimg.text.status = "Slideshow: resumed"
      	end
      end
      local function show_help()
      	swayimg.text.status = (
      		"Return/s:mode | hjkl:move | n/p:file | g/G:first/last | "
      			.. "+/-:zoom | 0/BS/f/w/z:scale | r:rot | v/x:flip | m:info | d:del"
      	)
      end

      -- Gallery mode key bindings

      swayimg.gallery.on_key("Escape", function()
      	swayimg.exit()
      end)
      swayimg.gallery.on_key("q", function()
      	swayimg.exit()
      end)
      -- Mode switching
      swayimg.gallery.on_key("Return", function()
      	swayimg.mode = "viewer"
      end)
      swayimg.gallery.on_key("s", function()
      	swayimg.mode = "slideshow"
      end)
      -- Thumbnail size
      swayimg.gallery.on_mouse("Ctrl-ScrollDown", function()
      	swayimg.gallery.thumb_size = math.max(10, swayimg.gallery.thumb_size - 20)
      end)
      swayimg.gallery.on_mouse("Ctrl-ScrollUp", function()
      	swayimg.gallery.thumb_size = swayimg.gallery.thumb_size + 20
      end)
      swayimg.gallery.on_key("Equal", function()
      	swayimg.gallery.thumb_size = swayimg.gallery.thumb_size + 10
      end)
      swayimg.gallery.on_key("Minus", function()
      	swayimg.gallery.thumb_size = math.max(10, swayimg.gallery.thumb_size - 10)
      end)
      -- Mouse click -> viewer
      swayimg.gallery.on_mouse("MouseLeft", function()
      	swayimg.mode = "viewer"
      end)
      -- Keyboard navigation
      swayimg.gallery.on_key("h", function()
      	swayimg.gallery.select("left")
      end)
      swayimg.gallery.on_key("j", function()
      	swayimg.gallery.select("down")
      end)
      swayimg.gallery.on_key("k", function()
      	swayimg.gallery.select("up")
      end)
      swayimg.gallery.on_key("l", function()
      	swayimg.gallery.select("right")
      end)
      swayimg.gallery.on_key("g", function()
      	swayimg.gallery.select("first")
      end)
      swayimg.gallery.on_key("Shift-g", function()
      	swayimg.gallery.select("last")
      end)
      swayimg.gallery.on_key("n", function()
      	swayimg.gallery.select("pgdown")
      end)
      swayimg.gallery.on_key("p", function()
      	swayimg.gallery.select("pgup")
      end)
      -- Mouse wheel navigation
      swayimg.gallery.on_mouse("ScrollDown", function()
      	swayimg.gallery.select("down")
      end)
      swayimg.gallery.on_mouse("ScrollUp", function()
      	swayimg.gallery.select("up")
      end)
      swayimg.gallery.on_mouse("ScrollLeft", function()
      	swayimg.gallery.select("right")
      end)
      swayimg.gallery.on_mouse("ScrollRight", function()
      	swayimg.gallery.select("left")
      end)
      -- Skip file
      swayimg.gallery.on_key("c", function()
      	swayimg.gallery.select("down")
      end)
      -- Delete file
      swayimg.gallery.on_key("Shift-d", function()
      	local entry = swayimg.gallery.get_image()
      	if entry then
      		os.remove(entry.path)
      		swayimg.text.status = "File removed: " .. entry.path
      		swayimg.gallery.select("down")
      	end
      end)
      -- Copy to ~/tmp
      swayimg.gallery.on_key("Shift-y", function()
      	local entry = swayimg.gallery.get_image()
      	if entry then
      		os.execute('cp "' .. entry.path .. '" ~/tmp/')
      		swayimg.text.status = "Copied: " .. entry.path
      	end
      end)
      -- Misc
      swayimg.gallery.on_key("r", function()
      	swayimg.gallery.reload()
      end)
      swayimg.gallery.on_key("m", toggle_info)
      swayimg.gallery.on_key("Shift-a", toggle_antialiasing)
      swayimg.gallery.on_key("Shift-?", show_help)

      -- Slideshow mode key bindings

      swayimg.slideshow.on_key("Escape", function()
      	swayimg.mode = "viewer"
      end)
      swayimg.slideshow.on_key("q", function()
      	swayimg.exit()
      end)
      swayimg.slideshow.on_key("Return", function()
      	swayimg.mode = "viewer"
      end)
      swayimg.slideshow.on_key("n", function()
      	swayimg.slideshow.open("next")
      end)
      swayimg.slideshow.on_key("p", function()
      	swayimg.slideshow.open("prev")
      end)
      swayimg.slideshow.on_key("g", function()
      	swayimg.slideshow.open("first")
      end)
      swayimg.slideshow.on_key("Shift-g", function()
      	swayimg.slideshow.open("last")
      end)
      swayimg.slideshow.on_key("Shift-n", function()
      	swayimg.slideshow.open("next_dir")
      end)
      swayimg.slideshow.on_key("Shift-p", function()
      	swayimg.slideshow.open("prev_dir")
      end)
      swayimg.slideshow.on_key("Shift-r", function()
      	swayimg.slideshow.open("random")
      end)
      swayimg.slideshow.on_key("Space", toggle_slideshow_pause)
      swayimg.slideshow.on_key("f", function()
      	swayimg.fullscreen = not swayimg.fullscreen
      end)
      swayimg.slideshow.on_key("i", toggle_info)
      swayimg.slideshow.on_key("Shift-?", show_help)

      -- Viewer mode key bindings

      swayimg.viewer.on_key("Escape", function()
      	swayimg.mode = "gallery"
      end)
      swayimg.viewer.on_key("q", function()
      	swayimg.exit()
      end)
      swayimg.viewer.on_key("Return", function()
      	swayimg.mode = "gallery"
      end)
      swayimg.viewer.on_key("s", function()
      	swayimg.mode = "slideshow"
      end)
      -- Pan: h/j/k/l = 10px, Shift = 1px, d/u = 100px
      local function pan(dx, dy)
      	local pos = swayimg.viewer.get_position()
      	swayimg.viewer.set_abs_position(pos.x + dx, pos.y + dy)
      end
      swayimg.viewer.on_key("h", function()
      	pan(-10, 0)
      end)
      swayimg.viewer.on_key("j", function()
      	pan(0, 10)
      end)
      swayimg.viewer.on_key("k", function()
      	pan(0, -10)
      end)
      swayimg.viewer.on_key("l", function()
      	pan(10, 0)
      end)
      swayimg.viewer.on_key("Shift-h", function()
      	pan(-1, 0)
      end)
      swayimg.viewer.on_key("Shift-j", function()
      	pan(0, 1)
      end)
      swayimg.viewer.on_key("Shift-k", function()
      	pan(0, -1)
      end)
      swayimg.viewer.on_key("Shift-l", function()
      	pan(1, 0)
      end)
      swayimg.viewer.on_key("d", function()
      	pan(0, 100)
      end)
      swayimg.viewer.on_key("u", function()
      	pan(0, -100)
      end)
      swayimg.viewer.on_mouse("ScrollDown", function()
      	pan(0, 5)
      end)
      swayimg.viewer.on_mouse("ScrollUp", function()
      	pan(0, -5)
      end)
      swayimg.viewer.on_mouse("ScrollLeft", function()
      	pan(5, 0)
      end)
      swayimg.viewer.on_mouse("ScrollRight", function()
      	pan(-5, 0)
      end)
      -- File navigation
      swayimg.viewer.on_key("n", function()
      	swayimg.viewer.open("next")
      end)
      swayimg.viewer.on_key("p", function()
      	swayimg.viewer.open("prev")
      end)
      swayimg.viewer.on_key("g", function()
      	swayimg.viewer.open("first")
      end)
      swayimg.viewer.on_key("Shift-g", function()
      	swayimg.viewer.open("last")
      end)
      swayimg.viewer.on_key("c", function()
      	swayimg.viewer.open("next")
      end)
      swayimg.viewer.on_key("Shift-n", function()
      	swayimg.viewer.open("next_dir")
      end)
      swayimg.viewer.on_key("Shift-p", function()
      	swayimg.viewer.open("prev_dir")
      end)
      swayimg.viewer.on_key("Shift-r", function()
      	swayimg.viewer.open("random")
      end)
      swayimg.viewer.on_mouse("Shift-ScrollDown", function()
      	swayimg.viewer.open("next")
      end)
      swayimg.viewer.on_mouse("Shift-ScrollUp", function()
      	swayimg.viewer.open("prev")
      end)
      -- Frame navigation
      swayimg.viewer.on_key(",", function()
      	local frame = swayimg.viewer.frame
      	if frame > 0 then
      		swayimg.viewer.frame = frame - 1
      	end
      end)
      swayimg.viewer.on_key(".", function()
      	swayimg.viewer.frame = swayimg.viewer.frame + 1
      end)
      swayimg.viewer.on_mouse("Alt-ScrollDown", function()
      	swayimg.viewer.frame = swayimg.viewer.frame + 1
      end)
      swayimg.viewer.on_mouse("Alt-ScrollUp", function()
      	local frame = swayimg.viewer.frame
      	if frame > 0 then
      		swayimg.viewer.frame = frame - 1
      	end
      end)
      -- Animation toggle
      swayimg.viewer.on_key("Space", function()
      	swayimg.viewer.animation = not swayimg.viewer.animation
      end)
      -- Fixed scale
      swayimg.viewer.on_key("0", function()
      	swayimg.viewer.set_fix_scale("real")
      end)
      swayimg.viewer.on_key("BackSpace", function()
      	swayimg.viewer.set_fix_scale("optimal")
      end)
      swayimg.viewer.on_key("f", function()
      	swayimg.viewer.set_fix_scale("fill")
      end)
      swayimg.viewer.on_key("w", function()
      	swayimg.viewer.set_fix_scale("width")
      end)
      swayimg.viewer.on_key("z", function()
      	swayimg.viewer.set_fix_scale("fit")
      end)
      -- Relative zoom (window center)
      swayimg.viewer.on_key("i", function()
      	swayimg.viewer.set_abs_scale(swayimg.viewer.scale * 1.1)
      end)
      swayimg.viewer.on_key("o", function()
      	swayimg.viewer.set_abs_scale(swayimg.viewer.scale / 1.1)
      end)
      swayimg.viewer.on_key("Equal", function()
      	swayimg.viewer.set_abs_scale(swayimg.viewer.scale * 1.1)
      end)
      swayimg.viewer.on_key("Plus", function()
      	swayimg.viewer.set_abs_scale(swayimg.viewer.scale * 1.1)
      end)
      swayimg.viewer.on_key("Minus", function()
      	swayimg.viewer.set_abs_scale(swayimg.viewer.scale / 1.1)
      end)
      -- Relative zoom (mouse position)
      swayimg.viewer.on_mouse("Ctrl-ScrollUp", function()
      	local m = swayimg.get_mouse_pos()
      	swayimg.viewer.set_abs_scale(swayimg.viewer.scale * 1.1, m.x, m.y)
      end)
      swayimg.viewer.on_mouse("Ctrl-ScrollDown", function()
      	local m = swayimg.get_mouse_pos()
      	swayimg.viewer.set_abs_scale(swayimg.viewer.scale / 1.1, m.x, m.y)
      end)
      -- Rotate / Flip
      swayimg.viewer.on_key("r", function()
      	swayimg.viewer.rotate(270)
      end)
      swayimg.viewer.on_key("Ctrl-r", function()
      	swayimg.viewer.rotate(90)
      end)
      swayimg.viewer.on_key("v", function()
      	swayimg.viewer.flip_vertical()
      end)
      swayimg.viewer.on_key("x", function()
      	swayimg.viewer.flip_horizontal()
      end)
      -- Delete file (no skip)
      swayimg.viewer.on_key("Shift-d", function()
      	local img = swayimg.viewer.get_image()
      	if img then
      		os.remove(img.path)
      		swayimg.text.status = "File removed: " .. img.path
      	end
      end)
      -- Copy to ~/tmp
      swayimg.viewer.on_key("Shift-y", function()
      	local img = swayimg.viewer.get_image()
      	if img then
      		os.execute('cp "' .. img.path .. '" ~/tmp/')
      		swayimg.text.status = "Copied: " .. img.path
      	end
      end)
      -- Misc
      swayimg.viewer.on_key("Shift-Ctrl-r", function()
      	swayimg.viewer.reload()
      end)
      swayimg.viewer.on_key("m", toggle_info)
      swayimg.viewer.on_key("Shift-a", toggle_antialiasing)
      swayimg.viewer.on_key("Shift-?", show_help)
    ''
    + lib.optionalString themesEnabled ''
      -- Theme settings (overrides defaults above)
      swayimg.text.font = "${(builtins.head osConfig.desktop.fonts.monospace).name}"
      swayimg.text.size = 12
      swayimg.text.color = 0xff${hex colors.base05}
      swayimg.text.background = 0x00${hex colors.base00}
      swayimg.text.shadow = 0xd0${hex colors.base00}
      swayimg.viewer.set_window_background(0x80${hex colors.base00})
      swayimg.gallery.window_color = 0x80${hex colors.base00}
    '';
  };
}
