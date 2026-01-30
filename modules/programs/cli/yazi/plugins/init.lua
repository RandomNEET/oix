require("git"):setup()

require("recycle-bin"):setup({
	-- Optional: Override automatic trash directory discovery
	-- trash_dir = "~/.local/share/Trash/",  -- Uncomment to use specific directory
})

require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
})

require("yatline"):setup({
	section_separator = { open = "", close = "" },
	inverse_separator = { open = "", close = "" },
	part_separator = { open = "|", close = "|" },

	tab_width = 20,

	show_background = true,

	display_header_line = true,
	display_status_line = true,

	header_line = {
		left = {
			section_a = {
				{ type = "line", custom = false, name = "tabs", params = { "left" } },
			},
			section_b = {},
			section_c = {},
		},
		right = {
			section_a = {},
			section_b = {},
			section_c = {
				{ type = "string", custom = false, name = "tab_path" },
			},
		},
	},

	status_line = {
		left = {
			section_a = {
				{ type = "string", custom = false, name = "tab_mode" },
			},
			section_b = {
				{ type = "coloreds", custom = false, name = "count", params = { true } },
			},
			section_c = {},
		},
		right = {
			section_a = {
				{ type = "string", custom = false, name = "cursor_position" },
			},
			section_b = {
				{ type = "string", custom = false, name = "cursor_percentage" },
			},
			section_c = {
				{ type = "coloreds", custom = false, name = "permissions" },
				{ type = "string", custom = false, name = "hovered_file_extension", params = { true } },
				{ type = "string", custom = false, name = "hovered_size" },
				{ type = "string", custom = false, name = "hovered_name" },
			},
		},
	},
})
