require("bookmarks"):setup({
	last_directory = { enable = true, persist = false, mode = "dir" },
	persist = "all",
	desc_format = "full",
	file_pick_mode = "hover",
	custom_desc_input = false,
	show_keys = false,
	notify = {
		enable = true,
		timeout = 1,
		message = {
			new = "New bookmark '<key>' -> '<folder>'",
			delete = "Deleted bookmark in '<key>'",
			delete_all = "Deleted all bookmarks",
		},
	},
})

require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
})

require("git"):setup({
	-- Order of status signs showing in the linemode
	order = 1500,
})

require("recycle-bin"):setup({
	-- Optional: Override automatic trash directory discovery
	-- trash_dir = "~/.local/share/Trash/",  -- Uncomment to use specific directory
})

require("restore"):setup({
	-- Set the position for confirm and overwrite prompts.
	-- Don't forget to set height: `h = xx`
	-- https://yazi-rs.github.io/docs/plugins/utils/#ya.input
	position = { "center", w = 70, h = 40 }, -- Optional

	-- Show confirm prompt before restore.
	-- NOTE: even if set this to false, overwrite prompt still pop up
	show_confirm = true, -- Optional

	-- Suppress success notification when all files or folder are restored.
	suppress_success_notification = true, -- Optional
})
