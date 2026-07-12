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

      swayimg.set_mode("viewer")
      swayimg.enable_overlay(true)
      swayimg.enable_antialiasing(true)
      swayimg.enable_exif_orientation(true)
      swayimg.enable_decoration(true)

      -- Viewer / Slideshow appearance

      swayimg.viewer.set_default_scale("optimal")
      swayimg.viewer.set_default_position("center")
      swayimg.slideshow.set_default_scale("fit")

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
      swayimg.viewer.set_text("bottomright", {
      	"{status}",
      })
      swayimg.slideshow.set_text("topleft", {})
      swayimg.slideshow.set_text("topright", {})
      swayimg.slideshow.set_text("bottomleft", {})
      swayimg.slideshow.set_text("bottomright", {
      	"{dir}",
      	"{status}",
      })
      swayimg.gallery.set_text("topleft", {})
      swayimg.gallery.set_text("topright", {})
      swayimg.gallery.set_text("bottomleft", {})
      swayimg.gallery.set_text("bottomright", {
      	"{name}",
      	"{status}",
      })

      -- Helper functions

      local antialiasing_enabled = true
      local function toggle_antialiasing()
      	antialiasing_enabled = not antialiasing_enabled
      	swayimg.enable_antialiasing(antialiasing_enabled)
      	swayimg.text.set_status("Anti-aliasing: " .. (antialiasing_enabled and "on" or "off"))
      end
      local function toggle_info()
      	if swayimg.text.visible() then
      		swayimg.text.hide()
      	else
      		swayimg.text.show()
      	end
      end
      local slideshow_timeout = 5
      local slideshow_paused = false
      local function toggle_slideshow_pause()
      	slideshow_paused = not slideshow_paused
      	if slideshow_paused then
      		swayimg.slideshow.set_timeout(0)
      		swayimg.text.set_status("Slideshow: paused")
      	else
      		swayimg.slideshow.set_timeout(slideshow_timeout)
      		swayimg.text.set_status("Slideshow: resumed")
      	end
      end
      local function show_help()
      	swayimg.text.set_status(
      		"Esc/q:exit | Return/s:mode | Space:pause | hjkl:move | n/p:file | "
      			.. "g/G:first/last | +/-:zoom | r:rot | v/x:flip | m:info | d:del"
      	)
      end

      -- Gallery mode key bindings (using switch_image, compatible with 5.0+)

      swayimg.gallery.on_key("Escape", function()
      	swayimg.exit()
      end)
      swayimg.gallery.on_key("q", function()
      	swayimg.exit()
      end)
      -- Mode switching
      swayimg.gallery.on_key("Return", function()
      	swayimg.set_mode("viewer")
      end)
      swayimg.gallery.on_key("s", function()
      	swayimg.set_mode("slideshow")
      end)
      -- Thumbnail size
      swayimg.gallery.on_mouse("Ctrl-ScrollDown", function()
      	swayimg.gallery.set_thumb_size(math.max(10, swayimg.gallery.get_thumb_size() - 20))
      end)
      swayimg.gallery.on_mouse("Ctrl-ScrollUp", function()
      	swayimg.gallery.set_thumb_size(swayimg.gallery.get_thumb_size() + 20)
      end)
      swayimg.gallery.on_key("Equal", function()
      	swayimg.gallery.set_thumb_size(swayimg.gallery.get_thumb_size() + 10)
      end)
      swayimg.gallery.on_key("Minus", function()
      	swayimg.gallery.set_thumb_size(math.max(10, swayimg.gallery.get_thumb_size() - 10))
      end)
      -- Mouse click -> viewer
      swayimg.gallery.on_mouse("MouseLeft", function()
      	swayimg.set_mode("viewer")
      end)
      -- Keyboard navigation
      swayimg.gallery.on_key("h", function()
      	swayimg.gallery.switch_image("left")
      end)
      swayimg.gallery.on_key("j", function()
      	swayimg.gallery.switch_image("down")
      end)
      swayimg.gallery.on_key("k", function()
      	swayimg.gallery.switch_image("up")
      end)
      swayimg.gallery.on_key("l", function()
      	swayimg.gallery.switch_image("right")
      end)
      swayimg.gallery.on_key("g", function()
      	swayimg.gallery.switch_image("first")
      end)
      swayimg.gallery.on_key("Shift-g", function()
      	swayimg.gallery.switch_image("last")
      end)
      swayimg.gallery.on_key("n", function()
      	swayimg.gallery.switch_image("pgdown")
      end)
      swayimg.gallery.on_key("p", function()
      	swayimg.gallery.switch_image("pgup")
      end)
      -- Mouse wheel navigation
      swayimg.gallery.on_mouse("ScrollDown", function()
      	swayimg.gallery.switch_image("down")
      end)
      swayimg.gallery.on_mouse("ScrollUp", function()
      	swayimg.gallery.switch_image("up")
      end)
      swayimg.gallery.on_mouse("ScrollLeft", function()
      	swayimg.gallery.switch_image("right")
      end)
      swayimg.gallery.on_mouse("ScrollRight", function()
      	swayimg.gallery.switch_image("left")
      end)
      -- Skip file
      swayimg.gallery.on_key("c", function()
      	swayimg.gallery.switch_image("down")
      end)
      -- Delete file
      swayimg.gallery.on_key("Shift-d", function()
      	local entry = swayimg.gallery.get_image()
      	if entry then
      		os.remove(entry.path)
      		swayimg.text.set_status("File removed: " .. entry.path)
      		swayimg.gallery.switch_image("down")
      	end
      end)
      -- Copy to ~/tmp
      swayimg.gallery.on_key("Shift-y", function()
      	local entry = swayimg.gallery.get_image()
      	if entry then
      		os.execute('cp "' .. entry.path .. '" ~/tmp/')
      		swayimg.text.set_status("Copied: " .. entry.path)
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
      	swayimg.set_mode("viewer")
      end)
      swayimg.slideshow.on_key("q", function()
      	swayimg.exit()
      end)
      swayimg.slideshow.on_key("Return", function()
      	swayimg.set_mode("viewer")
      end)
      swayimg.slideshow.on_key("n", function()
      	swayimg.slideshow.switch_image("next")
      end)
      swayimg.slideshow.on_key("p", function()
      	swayimg.slideshow.switch_image("prev")
      end)
      swayimg.slideshow.on_key("g", function()
      	swayimg.slideshow.switch_image("first")
      end)
      swayimg.slideshow.on_key("Shift-g", function()
      	swayimg.slideshow.switch_image("last")
      end)
      swayimg.slideshow.on_key("Shift-n", function()
      	swayimg.slideshow.switch_image("next_dir")
      end)
      swayimg.slideshow.on_key("Shift-p", function()
      	swayimg.slideshow.switch_image("prev_dir")
      end)
      swayimg.slideshow.on_key("Shift-r", function()
      	swayimg.slideshow.switch_image("random")
      end)
      swayimg.slideshow.on_key("Space", toggle_slideshow_pause)
      swayimg.slideshow.on_key("f", function()
      	swayimg.set_fullscreen()
      end)
      swayimg.slideshow.on_key("i", toggle_info)
      swayimg.slideshow.on_key("Shift-?", show_help)

      -- Viewer mode key bindings

      swayimg.viewer.on_key("Escape", function()
      	swayimg.set_mode("gallery")
      end)
      swayimg.viewer.on_key("q", function()
      	swayimg.exit()
      end)
      swayimg.viewer.on_key("Return", function()
      	swayimg.set_mode("gallery")
      end)
      swayimg.viewer.on_key("s", function()
      	swayimg.set_mode("slideshow")
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
      	swayimg.viewer.switch_image("next")
      end)
      swayimg.viewer.on_key("p", function()
      	swayimg.viewer.switch_image("prev")
      end)
      swayimg.viewer.on_key("g", function()
      	swayimg.viewer.switch_image("first")
      end)
      swayimg.viewer.on_key("Shift-g", function()
      	swayimg.viewer.switch_image("last")
      end)
      swayimg.viewer.on_key("c", function()
      	swayimg.viewer.switch_image("next")
      end)
      swayimg.viewer.on_key("Shift-n", function()
      	swayimg.viewer.switch_image("next_dir")
      end)
      swayimg.viewer.on_key("Shift-p", function()
      	swayimg.viewer.switch_image("prev_dir")
      end)
      swayimg.viewer.on_key("Shift-r", function()
      	swayimg.viewer.switch_image("random")
      end)
      swayimg.viewer.on_mouse("Shift-ScrollDown", function()
      	swayimg.viewer.switch_image("next")
      end)
      swayimg.viewer.on_mouse("Shift-ScrollUp", function()
      	swayimg.viewer.switch_image("prev")
      end)
      -- Frame navigation
      swayimg.viewer.on_key(",", function()
      	swayimg.viewer.prev_frame()
      end)
      swayimg.viewer.on_key(".", function()
      	swayimg.viewer.next_frame()
      end)
      swayimg.viewer.on_mouse("Alt-ScrollDown", function()
      	swayimg.viewer.next_frame()
      end)
      swayimg.viewer.on_mouse("Alt-ScrollUp", function()
      	swayimg.viewer.prev_frame()
      end)
      -- Animation toggle
      swayimg.viewer.on_key("Space", function()
      	swayimg.viewer.set_animation()
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
      	swayimg.viewer.set_abs_scale(swayimg.viewer.get_scale() * 1.1)
      end)
      swayimg.viewer.on_key("o", function()
      	swayimg.viewer.set_abs_scale(swayimg.viewer.get_scale() / 1.1)
      end)
      swayimg.viewer.on_key("Equal", function()
      	swayimg.viewer.set_abs_scale(swayimg.viewer.get_scale() * 1.1)
      end)
      swayimg.viewer.on_key("Plus", function()
      	swayimg.viewer.set_abs_scale(swayimg.viewer.get_scale() * 1.1)
      end)
      swayimg.viewer.on_key("Minus", function()
      	swayimg.viewer.set_abs_scale(swayimg.viewer.get_scale() / 1.1)
      end)
      -- Relative zoom (mouse position)
      swayimg.viewer.on_mouse("Ctrl-ScrollUp", function()
      	local m = swayimg.get_mouse_pos()
      	swayimg.viewer.set_abs_scale(swayimg.viewer.get_scale() * 1.1, m.x, m.y)
      end)
      swayimg.viewer.on_mouse("Ctrl-ScrollDown", function()
      	local m = swayimg.get_mouse_pos()
      	swayimg.viewer.set_abs_scale(swayimg.viewer.get_scale() / 1.1, m.x, m.y)
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
      		swayimg.text.set_status("File removed: " .. img.path)
      	end
      end)
      -- Copy to ~/tmp
      swayimg.viewer.on_key("Shift-y", function()
      	local img = swayimg.viewer.get_image()
      	if img then
      		os.execute('cp "' .. img.path .. '" ~/tmp/')
      		swayimg.text.set_status("Copied: " .. img.path)
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
      swayimg.text.set_font("${(builtins.head osConfig.desktop.fonts.monospace).name}")
      swayimg.text.set_size(12)
      swayimg.text.set_foreground(0xff${hex colors.base05})
      swayimg.text.set_background(0x00${hex colors.base00})
      swayimg.text.set_shadow(0xd0${hex colors.base00})
      swayimg.viewer.set_window_background(0x80${hex colors.base00})
    '';
  };
}
