# vim:fileencoding=utf-8:foldmethod=marker


def hex_to_rgba(hex_color, alpha=1.0):
    """Convert hex color to rgba format with alpha channel"""
    hex_color = hex_color.lstrip("#")
    r, g, b = tuple(int(hex_color[i : i + 2], 16) for i in (0, 2, 4))
    return f"rgba({r}, {g}, {b}, {alpha})"


def setup(c, flavour, samecolorrows=False):
    palette = {}

    # flavours {{{
    if flavour == "latte":
        palette = {
            "rosewater": "#dc8a78",
            "flamingo": "#dd7878",
            "pink": "#ea76cb",
            "mauve": "#8839ef",
            "red": "#d20f39",
            "maroon": "#e64553",
            "peach": "#fe640b",
            "yellow": "#df8e1d",
            "green": "#40a02b",
            "teal": "#179299",
            "sky": "#04a5e5",
            "sapphire": "#209fb5",
            "blue": "#1e66f5",
            "lavender": "#7287fd",
            "text": "#4c4f69",
            "subtext1": "#5c5f77",
            "subtext0": "#6c6f85",
            "overlay2": "#7c7f93",
            "overlay1": "#8c8fa1",
            "overlay0": "#9ca0b0",
            "surface2": "#acb0be",
            "surface1": "#bcc0cc",
            "surface0": "#ccd0da",
            "base": "#eff1f5",
            "mantle": "#e6e9ef",
            "crust": "#dce0e8",
        }
    elif flavour == "frappe":
        palette = {
            "rosewater": "#f2d5cf",
            "flamingo": "#eebebe",
            "pink": "#f4b8e4",
            "mauve": "#ca9ee6",
            "red": "#e78284",
            "maroon": "#ea999c",
            "peach": "#ef9f76",
            "yellow": "#e5c890",
            "green": "#a6d189",
            "teal": "#81c8be",
            "sky": "#99d1db",
            "sapphire": "#85c1dc",
            "blue": "#8caaee",
            "lavender": "#babbf1",
            "text": "#c6d0f5",
            "subtext1": "#b5bfe2",
            "subtext0": "#a5adce",
            "overlay2": "#949cbb",
            "overlay1": "#838ba7",
            "overlay0": "#737994",
            "surface2": "#626880",
            "surface1": "#51576d",
            "surface0": "#414559",
            "base": "#303446",
            "mantle": "#292c3c",
            "crust": "#232634",
        }
    elif flavour == "macchiato":
        palette = {
            "rosewater": "#f4dbd6",
            "flamingo": "#f0c6c6",
            "pink": "#f5bde6",
            "mauve": "#c6a0f6",
            "red": "#ed8796",
            "maroon": "#ee99a0",
            "peach": "#f5a97f",
            "yellow": "#eed49f",
            "green": "#a6da95",
            "teal": "#8bd5ca",
            "sky": "#91d7e3",
            "sapphire": "#7dc4e4",
            "blue": "#8aadf4",
            "lavender": "#b7bdf8",
            "text": "#cad3f5",
            "subtext1": "#b8c0e0",
            "subtext0": "#a5adcb",
            "overlay2": "#939ab7",
            "overlay1": "#8087a2",
            "overlay0": "#6e738d",
            "surface2": "#5b6078",
            "surface1": "#494d64",
            "surface0": "#363a4f",
            "base": "#24273a",
            "mantle": "#1e2030",
            "crust": "#181926",
        }
    else:
        palette = {
            "rosewater": "#f5e0dc",
            "flamingo": "#f2cdcd",
            "pink": "#f5c2e7",
            "mauve": "#cba6f7",
            "red": "#f38ba8",
            "maroon": "#eba0ac",
            "peach": "#fab387",
            "yellow": "#f9e2af",
            "green": "#a6e3a1",
            "teal": "#94e2d5",
            "sky": "#89dceb",
            "sapphire": "#74c7ec",
            "blue": "#89b4fa",
            "lavender": "#b4befe",
            "text": "#cdd6f4",
            "subtext1": "#bac2de",
            "subtext0": "#a6adc8",
            "overlay2": "#9399b2",
            "overlay1": "#7f849c",
            "overlay0": "#6c7086",
            "surface2": "#585b70",
            "surface1": "#45475a",
            "surface0": "#313244",
            "base": "#1e1e2e",
            "mantle": "#181825",
            "crust": "#11111b",
        }
    # }}}

    # completion {{{
    ## Background color of the completion widget category headers.
    c.colors.completion.category.bg = hex_to_rgba(palette["base"], 1.0)
    ## Bottom border color of the completion widget category headers.
    c.colors.completion.category.border.bottom = hex_to_rgba(palette["mantle"], 1.0)
    ## Top border color of the completion widget category headers.
    c.colors.completion.category.border.top = hex_to_rgba(palette["overlay2"], 1.0)
    ## Foreground color of completion widget category headers.
    c.colors.completion.category.fg = hex_to_rgba(palette["green"], 1.0)
    ## Background color of the completion widget for even and odd rows.
    if samecolorrows:
        c.colors.completion.even.bg = hex_to_rgba(palette["mantle"], 1.0)
        c.colors.completion.odd.bg = c.colors.completion.even.bg
    else:
        c.colors.completion.even.bg = hex_to_rgba(palette["mantle"], 1.0)
        c.colors.completion.odd.bg = hex_to_rgba(palette["crust"], 1.0)
    ## Text color of the completion widget.
    c.colors.completion.fg = hex_to_rgba(palette["subtext0"], 1.0)

    ## Background color of the selected completion item.
    c.colors.completion.item.selected.bg = hex_to_rgba(palette["surface2"], 1.0)
    ## Bottom border color of the selected completion item.
    c.colors.completion.item.selected.border.bottom = hex_to_rgba(
        palette["surface2"], 1.0
    )
    ## Top border color of the completion widget category headers.
    c.colors.completion.item.selected.border.top = hex_to_rgba(palette["surface2"], 1.0)
    ## Foreground color of the selected completion item.
    c.colors.completion.item.selected.fg = hex_to_rgba(palette["text"], 1.0)
    ## Foreground color of the selected completion item.
    c.colors.completion.item.selected.match.fg = hex_to_rgba(palette["rosewater"], 1.0)
    ## Foreground color of the matched text in the completion.
    c.colors.completion.match.fg = hex_to_rgba(palette["text"], 1.0)

    ## Color of the scrollbar in completion view
    c.colors.completion.scrollbar.bg = hex_to_rgba(palette["crust"], 1.0)
    ## Color of the scrollbar handle in completion view.
    c.colors.completion.scrollbar.fg = hex_to_rgba(palette["surface2"], 1.0)
    # }}}

    # downloads {{{
    c.colors.downloads.bar.bg = hex_to_rgba(palette["base"], 1.0)
    c.colors.downloads.error.bg = hex_to_rgba(palette["base"], 1.0)
    c.colors.downloads.start.bg = hex_to_rgba(palette["base"], 1.0)
    c.colors.downloads.stop.bg = hex_to_rgba(palette["base"], 1.0)

    c.colors.downloads.error.fg = hex_to_rgba(palette["red"], 1.0)
    c.colors.downloads.start.fg = hex_to_rgba(palette["blue"], 1.0)
    c.colors.downloads.stop.fg = hex_to_rgba(palette["green"], 1.0)
    c.colors.downloads.system.fg = "none"
    c.colors.downloads.system.bg = "none"
    # }}}

    # hints {{{
    ## Background color for hints. Note that you can use a `rgba(...)` value
    ## for transparency.
    c.colors.hints.bg = hex_to_rgba(palette["peach"], 1.0)

    ## Font color for hints.
    c.colors.hints.fg = hex_to_rgba(palette["mantle"], 1.0)

    ## Hints
    c.hints.border = "1px solid " + hex_to_rgba(palette["mantle"], 1.0)

    ## Font color for the matched part of hints.
    c.colors.hints.match.fg = hex_to_rgba(palette["subtext1"], 1.0)
    # }}}

    # keyhints {{{
    ## Background color of the keyhint widget.
    c.colors.keyhint.bg = hex_to_rgba(palette["mantle"], 1.0)

    ## Text color for the keyhint widget.
    c.colors.keyhint.fg = hex_to_rgba(palette["text"], 1.0)

    ## Highlight color for keys to complete the current keychain.
    c.colors.keyhint.suffix.fg = hex_to_rgba(palette["subtext1"], 1.0)
    # }}}

    # messages {{{
    ## Background color of an error message.
    c.colors.messages.error.bg = hex_to_rgba(palette["overlay0"], 1.0)
    ## Background color of an info message.
    c.colors.messages.info.bg = hex_to_rgba(palette["overlay0"], 1.0)
    ## Background color of a warning message.
    c.colors.messages.warning.bg = hex_to_rgba(palette["overlay0"], 1.0)

    ## Border color of an error message.
    c.colors.messages.error.border = hex_to_rgba(palette["mantle"], 1.0)
    ## Border color of an info message.
    c.colors.messages.info.border = hex_to_rgba(palette["mantle"], 1.0)
    ## Border color of a warning message.
    c.colors.messages.warning.border = hex_to_rgba(palette["mantle"], 1.0)

    ## Foreground color of an error message.
    c.colors.messages.error.fg = hex_to_rgba(palette["red"], 1.0)
    ## Foreground color an info message.
    c.colors.messages.info.fg = hex_to_rgba(palette["text"], 1.0)
    ## Foreground color a warning message.
    c.colors.messages.warning.fg = hex_to_rgba(palette["peach"], 1.0)
    # }}}

    # prompts {{{
    ## Background color for prompts.
    c.colors.prompts.bg = hex_to_rgba(palette["mantle"], 1.0)

    # ## Border used around UI elements in prompts.
    c.colors.prompts.border = "1px solid " + hex_to_rgba(palette["overlay0"], 1.0)

    ## Foreground color for prompts.
    c.colors.prompts.fg = hex_to_rgba(palette["text"], 1.0)

    ## Background color for the selected item in filename prompts.
    c.colors.prompts.selected.bg = hex_to_rgba(palette["surface2"], 1.0)

    ## Foreground color for the selected item in filename prompts.
    c.colors.prompts.selected.fg = hex_to_rgba(palette["rosewater"], 1.0)
    # }}}

    # statusbar {{{
    ## Background color of the statusbar.
    c.colors.statusbar.normal.bg = hex_to_rgba(palette["base"], 0.9)
    ## Background color of the statusbar in insert mode.
    c.colors.statusbar.insert.bg = hex_to_rgba(palette["crust"], 1.0)
    ## Background color of the statusbar in command mode.
    c.colors.statusbar.command.bg = hex_to_rgba(palette["base"], 1.0)
    ## Background color of the statusbar in caret mode.
    c.colors.statusbar.caret.bg = hex_to_rgba(palette["base"], 1.0)
    ## Background color of the statusbar in caret mode with a selection.
    c.colors.statusbar.caret.selection.bg = hex_to_rgba(palette["base"], 1.0)

    ## Background color of the progress bar.
    c.colors.statusbar.progress.bg = hex_to_rgba(palette["base"], 1.0)
    ## Background color of the statusbar in passthrough mode.
    c.colors.statusbar.passthrough.bg = hex_to_rgba(palette["base"], 1.0)

    ## Foreground color of the statusbar.
    c.colors.statusbar.normal.fg = hex_to_rgba(palette["text"], 1.0)
    ## Foreground color of the statusbar in insert mode.
    c.colors.statusbar.insert.fg = hex_to_rgba(palette["rosewater"], 1.0)
    ## Foreground color of the statusbar in command mode.
    c.colors.statusbar.command.fg = hex_to_rgba(palette["text"], 1.0)
    ## Foreground color of the statusbar in passthrough mode.
    c.colors.statusbar.passthrough.fg = hex_to_rgba(palette["peach"], 1.0)
    ## Foreground color of the statusbar in caret mode.
    c.colors.statusbar.caret.fg = hex_to_rgba(palette["peach"], 1.0)
    ## Foreground color of the statusbar in caret mode with a selection.
    c.colors.statusbar.caret.selection.fg = hex_to_rgba(palette["peach"], 1.0)

    ## Foreground color of the URL in the statusbar on error.
    c.colors.statusbar.url.error.fg = hex_to_rgba(palette["red"], 1.0)

    ## Default foreground color of the URL in the statusbar.
    c.colors.statusbar.url.fg = hex_to_rgba(palette["text"], 1.0)

    ## Foreground color of the URL in the statusbar for hovered links.
    c.colors.statusbar.url.hover.fg = hex_to_rgba(palette["sky"], 1.0)

    ## Foreground color of the URL in the statusbar on successful load
    c.colors.statusbar.url.success.http.fg = hex_to_rgba(palette["teal"], 1.0)

    ## Foreground color of the URL in the statusbar on successful load
    c.colors.statusbar.url.success.https.fg = hex_to_rgba(palette["green"], 1.0)

    ## Foreground color of the URL in the statusbar when there's a warning.
    c.colors.statusbar.url.warn.fg = hex_to_rgba(palette["yellow"], 1.0)

    ## PRIVATE MODE COLORS
    ## Background color of the statusbar in private browsing mode.
    c.colors.statusbar.private.bg = hex_to_rgba(palette["mantle"], 1.0)
    ## Foreground color of the statusbar in private browsing mode.
    c.colors.statusbar.private.fg = hex_to_rgba(palette["subtext1"], 1.0)
    ## Background color of the statusbar in private browsing + command mode.
    c.colors.statusbar.command.private.bg = hex_to_rgba(palette["base"], 1.0)
    ## Foreground color of the statusbar in private browsing + command mode.
    c.colors.statusbar.command.private.fg = hex_to_rgba(palette["subtext1"], 1.0)

    # }}}

    # tabs {{{
    ## Background color of the tab bar.
    c.colors.tabs.bar.bg = hex_to_rgba(palette["crust"], 0.1)
    ## Background color of unselected even tabs.
    c.colors.tabs.even.bg = hex_to_rgba(palette["surface2"], 0.1)
    ## Background color of unselected odd tabs.
    c.colors.tabs.odd.bg = hex_to_rgba(palette["surface1"], 0.1)

    ## Foreground color of unselected even tabs.
    c.colors.tabs.even.fg = hex_to_rgba(palette["overlay2"], 1.0)
    ## Foreground color of unselected odd tabs.
    c.colors.tabs.odd.fg = hex_to_rgba(palette["overlay2"], 1.0)

    ## Color for the tab indicator on errors.
    c.colors.tabs.indicator.error = hex_to_rgba(palette["red"], 1.0)
    ## Color gradient interpolation system for the tab indicator.
    ## Valid values:
    ##	 - rgb: Interpolate in the RGB color system.
    ##	 - hsv: Interpolate in the HSV color system.
    ##	 - hsl: Interpolate in the HSL color system.
    ##	 - none: Don't show a gradient.
    c.colors.tabs.indicator.system = "none"

    # ## Background color of selected even tabs.
    c.colors.tabs.selected.even.bg = hex_to_rgba(palette["base"], 0.9)
    # ## Background color of selected odd tabs.
    c.colors.tabs.selected.odd.bg = hex_to_rgba(palette["base"], 0.9)

    # ## Foreground color of selected even tabs.
    c.colors.tabs.selected.even.fg = hex_to_rgba(palette["text"], 1.0)
    # ## Foreground color of selected odd tabs.
    c.colors.tabs.selected.odd.fg = hex_to_rgba(palette["text"], 1.0)
    # }}}

    # context menus {{{
    c.colors.contextmenu.menu.bg = hex_to_rgba(palette["base"], 1.0)
    c.colors.contextmenu.menu.fg = hex_to_rgba(palette["text"], 1.0)

    c.colors.contextmenu.disabled.bg = hex_to_rgba(palette["mantle"], 1.0)
    c.colors.contextmenu.disabled.fg = hex_to_rgba(palette["overlay0"], 1.0)

    c.colors.contextmenu.selected.bg = hex_to_rgba(palette["overlay0"], 1.0)
    c.colors.contextmenu.selected.fg = hex_to_rgba(palette["rosewater"], 1.0)
    # }}}
