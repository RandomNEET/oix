{
  config,
  lib,
  pkgs,
  opts,
  ...
}:
let
  colors = config.lib.stylix.colors;
in
{
  home-manager.sharedModules = [
    (_: {
      programs.rmpc = {
        enable = true;
        config = ''
          #![enable(implicit_some)]
          #![enable(unwrap_newtypes)]
          #![enable(unwrap_variant_newtypes)]
          (
              address: "${opts.rmpc.config.address or "127.0.0.1:6600"}",
              password: ${opts.rmpc.config.password or "None"},
              cache_dir: None,
              ${lib.optionalString (opts.rmpc.config.notify or false
              ) "on_song_change: [\"${./scripts/notify.sh}\"],"}
              volume_step: 5,
              max_fps: 30,
              scrolloff: 0,
              wrap_navigation: false,
              enable_mouse: true,
              enable_config_hot_reload: true,
              status_update_interval_ms: 1000,
              rewind_to_start_sec: None,
              reflect_changes_to_playlist: false,
              select_current_song_on_change: false,
              browser_song_sort: [Disc, Track, Artist, Title],
              directories_sort: SortFormat(group_by_type: true, reverse: false),
              album_art: (
                  method: Auto,
                  max_size_px: (width: 1200, height: 1200),
                  disabled_protocols: ["http://", "https://"],
                  vertical_align: Center,
                  horizontal_align: Center,
              ),
              keybinds: (
                  global: {
                      ":":       CommandMode,
                      ",":       VolumeDown,
                      "s":       Stop,
                      ".":       VolumeUp,
                      "<Tab>":   NextTab,
                      "<S-Tab>": PreviousTab,
                      "1":       SwitchToTab("Queue"),
                      "2":       SwitchToTab("Directories"),
                      "3":       SwitchToTab("Artists"),
                      "4":       SwitchToTab("Album Artists"),
                      "5":       SwitchToTab("Albums"),
                      "6":       SwitchToTab("Playlists"),
                      "7":       SwitchToTab("Search"),
                      "q":       Quit,
                      ">":       NextTrack,
                      "p":       TogglePause,
                      "<":       PreviousTrack,
                      "f":       SeekForward,
                      "z":       ToggleRepeat,
                      "x":       ToggleRandom,
                      "c":       ToggleConsume,
                      "v":       ToggleSingle,
                      "b":       SeekBack,
                      "~":       ShowHelp,
                      "u":       Update,
                      "U":       Rescan,
                      "I":       ShowCurrentSongInfo,
                      "O":       ShowOutputs,
                      "P":       ShowDecoders,
                      "R":       AddRandom,
                  },
                  navigation: {
                      "k":         Up,
                      "j":         Down,
                      "h":         Left,
                      "l":         Right,
                      "<Up>":      Up,
                      "<Down>":    Down,
                      "<Left>":    Left,
                      "<Right>":   Right,
                      "<C-k>":     PaneUp,
                      "<C-j>":     PaneDown,
                      "<C-h>":     PaneLeft,
                      "<C-l>":     PaneRight,
                      "<C-u>":     UpHalf,
                      "N":         PreviousResult,
                      "a":         Add,
                      "A":         AddAll,
                      "r":         Rename,
                      "n":         NextResult,
                      "g":         Top,
                      "<Space>":   Select,
                      "<C-Space>": InvertSelection,
                      "G":         Bottom,
                      "<CR>":      Confirm,
                      "i":         FocusInput,
                      "J":         MoveDown,
                      "<C-d>":     DownHalf,
                      "/":         EnterSearch,
                      "<C-c>":     Close,
                      "<Esc>":     Close,
                      "K":         MoveUp,
                      "D":         Delete,
                      "B":         ShowInfo,
                  },
                  queue: {
                      "D":       DeleteAll,
                      "<CR>":    Play,
                      "<C-s>":   Save,
                      "a":       AddToPlaylist,
                      "d":       Delete,
                      "C":       JumpToCurrent,
                      "X":       Shuffle,
                  },
              ),
              search: (
                  case_sensitive: false,
                  mode: Contains,
                  tags: [
                      (value: "any",         label: "Any Tag"),
                      (value: "artist",      label: "Artist"),
                      (value: "album",       label: "Album"),
                      (value: "albumartist", label: "Album Artist"),
                      (value: "title",       label: "Title"),
                      (value: "filename",    label: "Filename"),
                      (value: "genre",       label: "Genre"),
                  ],
              ),
              artists: (
                  album_display_mode: SplitByDate,
                  album_sort_by: Date,
              ),
              tabs: [
                  (
                      name: "Queue",
                      pane: Split(
                          direction: Horizontal,
                          panes: [
                              (
                                  size: "70%",
                                  pane: Pane(Queue),
                              ),
                              (
                                  size: "30%",
                                  pane: Split(
                                      direction: Vertical,
                                      panes: [
                                          (size: "70%", pane: Pane(AlbumArt)),
                                          (size: "30%", pane: Pane(Cava)),
                                      ],
                                  ),
                              ),
                          ],
                      ),
                  ),
                  (
                      name: "Directories",
                      pane: Pane(Directories),
                  ),
                  (
                      name: "Artists",
                      pane: Pane(Artists),
                  ),
                  (
                      name: "Album Artists",
                      pane: Pane(AlbumArtists),
                  ),
                  (
                      name: "Albums",
                      pane: Pane(Albums),
                  ),
                  (
                      name: "Playlists",
                      pane: Pane(Playlists),
                  ),
                  (
                      name: "Search",
                      pane: Pane(Search),
                  ),
              ],
              cava: (
                  framerate: 60,
                  autosens: true,
                  sensitivity: 100,
                  lower_cutoff_freq: 50,
                  higher_cutoff_freq: 10000,
                  input: (
                      method: Fifo,
                      source: "/tmp/mpd.fifo",
                      sample_rate: 44100,
                      channels: 2,
                      sample_bits: 16,
                  ),
                  smoothing: (
                      noise_reduction: 77,
                      monstercat: false,
                      waves: false,
                  ),
                  eq: [],
              ),
              ${lib.optionalString config.stylix.enable "theme: \"stylix\","}
          )
        '';
      };
      home = {
        file.".config/rmpc/themes/stylix.ron".text = ''
          #![enable(implicit_some)]
          #![enable(unwrap_newtypes)]
          #![enable(unwrap_variant_newtypes)]

          (
              default_album_art_path: None,
              show_song_table_header: true,
              draw_borders: true,
              format_tag_separator: " | ",
              browser_column_widths: [20, 38, 42],

              background_color: "#${colors.base00}",
              text_color: "#${colors.base05}",
              header_background_color: "#${colors.base01}",
              modal_background_color: "#${colors.base01}",

              preview_label_style: (fg: "#${colors.base0A}"),
              preview_metadata_group_style: (fg: "#${colors.base0A}", modifiers: "Bold"),

              tab_bar: (
                  active_style: (fg: "black", bg: "#${colors.base0E}", modifiers: "Bold"),
                  inactive_style: (fg: "#${colors.base03}"),
              ),

              highlighted_item_style: (fg: "#${colors.base0A}", modifiers: "Bold"),
              current_item_style: (fg: "black", bg: "#${colors.base0D}", modifiers: "Bold"),
              borders_style: (fg: "#${colors.base03}"),
              highlight_border_style: (fg: "#${colors.base0A}"),

              symbols: (
                  song: "󰝚",
                  dir: "",
                  playlist: "󰲸",
                  marker: "\u{e0b0}",
                  ellipsis: "...",
              ),

              progress_bar: (
                  symbols: ["", "", "⭘", " ", " "],
                  track_style: (bg: "#${colors.base01}"),
                  elapsed_style: (fg: "#${colors.base0E}", bg: "#${colors.base01}"),
                  thumb_style: (fg: "#${colors.base0E}", bg: "#${colors.base01}"),
              ),

              scrollbar: (
                  symbols: ["│", "█", "▲", "▼"],
                  track_style: (),
                  ends_style: (),
                  thumb_style: (fg: "#${colors.base0D}"),
              ),

              song_table_format: [
                  (
                      prop: (
                          kind: Property(Artist),
                          style: (fg: "#${colors.base0D}"),
                          default: (kind: Text("Unknown"), style: (fg: "#${colors.base03}")),
                      ),
                      width: "20%",
                  ),
                  (
                      prop: (
                          kind: Property(Title),
                          style: (fg: "#${colors.base0E}"),
                          default: (kind: Text("Unknown"), style: (fg: "#${colors.base03}")),
                      ),
                      width: "35%",
                  ),
                  (
                      prop: (
                          kind: Property(Album),
                          style: (fg: "#${colors.base0D}"),
                          default: (kind: Text("Unknown Album"), style: (fg: "#${colors.base03}")),
                      ),
                      width: "30%",
                  ),
                  (
                      prop: (
                          kind: Property(Duration),
                          style: (fg: "#${colors.base04}"),
                          default: (kind: Text("-")),
                      ),
                      width: "15%",
                      alignment: Right,
                  ),
              ],

              layout: Split(
                  direction: Vertical,
                  panes: [
                      (
                          size: "4",
                          pane: Split(
                              direction: Horizontal,
                              panes: [
                                  (
                                      size: "100%",
                                      pane: Split(
                                          direction: Vertical,
                                          panes: [
                                              (
                                                  size: "4",
                                                  borders: "ALL",
                                                  pane: Pane(Header),
                                              ),
                                          ],
                                      ),
                                  ),
                              ],
                          ),
                      ),
                      (
                          size: "3",
                          pane: Pane(Tabs),
                      ),
                      (
                          size: "100%",
                          pane: Split(
                              direction: Horizontal,
                              panes: [
                                  (
                                      size: "100%",
                                      borders: "NONE",
                                      pane: Pane(TabContent),
                                  ),
                              ],
                          ),
                      ),
                      (
                          size: "3",
                          borders: "TOP | BOTTOM",
                          pane: Pane(ProgressBar),
                      ),
                  ],
              ),

              header: (
                  rows: [
                      (
                          left: [
                              (kind: Text("["), style: (fg: "#${colors.base0D}", modifiers: "Bold")),
                              (kind: Property(Status(State)), style: (fg: "#${colors.base0D}", modifiers: "Bold")),
                              (kind: Text("]"), style: (fg: "#${colors.base0D}", modifiers: "Bold")),
                          ],
                          center: [
                              (
                                  kind: Property(Song(Title)),
                                  style: (fg: "#${colors.base0D}", modifiers: "Bold"),
                                  default: (kind: Text("No Song"), style: (fg: "#${colors.base0D}", modifiers: "Bold")),
                              ),
                          ],
                          right: [
                              (kind: Property(Widget(ScanStatus)), style: (fg: "#${colors.base0D}")),
                              (kind: Property(Widget(Volume)), style: (fg: "#${colors.base0D}")),
                          ],
                      ),
                      (
                          left: [
                              (kind: Property(Status(Elapsed)), style: (fg: "#${colors.base05}")),
                              (kind: Text(" / "), style: (fg: "#${colors.base03}")),
                              (kind: Property(Status(Duration)), style: (fg: "#${colors.base05}")),
                              (kind: Text(" ("), style: (fg: "#${colors.base03}")),
                              (kind: Property(Status(Bitrate)), style: (fg: "#${colors.base05}")),
                              (kind: Text(" kbps)"), style: (fg: "#${colors.base03}")),
                          ],
                          center: [
                              (
                                  kind: Property(Song(Artist)),
                                  style: (fg: "#${colors.base0A}", modifiers: "Bold"),
                                  default: (kind: Text("Unknown"), style: (fg: "#${colors.base0A}", modifiers: "Bold")),
                              ),
                              (kind: Text(" - "), style: (fg: "#${colors.base03}")),
                              (
                                  kind: Property(Song(Album)),
                                  style: (fg: "#${colors.base0D}"),
                                  default: (kind: Text("Unknown Album"), style: (fg: "#${colors.base0D}")),
                              ),
                          ],
                          right: [
                              (
                                  kind: Property(
                                      Widget(
                                          States(
                                              active_style: (fg: "#${colors.base05}", modifiers: "Bold"),
                                              separator_style: (fg: "#${colors.base03}"),
                                          ),
                                      ),
                                  ),
                                  style: (fg: "#${colors.base03}"),
                              ),
                          ],
                      ),
                  ],
              ),

              browser_song_format: [
                  (
                      kind: Group([
                          (kind: Property(Track)),
                          (kind: Text(" ")),
                      ]),
                  ),
                  (
                      kind: Group([
                          (kind: Property(Artist)),
                          (kind: Text(" - ")),
                          (kind: Property(Title)),
                      ]),
                      default: (kind: Property(Filename)),
                  ),
              ],

              cava: (
                  bar_symbols: ['▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'],
                  inverted_bar_symbols: ['▔', '🮂', '🮃', '▀', '🮄', '🮅', '🮆', '█'],
                  bg_color: "#${colors.base00}",
                  bar_width: 1,
                  bar_spacing: 1,
                  orientation: Bottom,
                  bar_color: Gradient({
                        0:   "#${colors.base0C}",
                       15:   "#${colors.base0C}",
                       30:   "#${colors.base0D}",
                       45:   "#${colors.base0D}",
                       60:   "#${colors.base0E}",
                       75:   "#${colors.base0E}",
                       90:   "#${colors.base08}",
                      100:   "#${colors.base08}",
                  }),
              ),
          )
        '';
        packages = with pkgs; [ cava ];
      };
    })
  ];
}
