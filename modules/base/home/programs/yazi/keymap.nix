{ meta, ... }:
{
  mgr = {
    prepend_keymap = [
      # Toggle
      {
        on = "<A-a>";
        run = "toggle_all --state=on";
        desc = "Select all files";
      }
      {
        on = "<A-r>";
        run = "toggle_all";
        desc = "Invert selection of all files";
      }
      # Goto
      {
        on = [
          "g"
          "n"
        ];
        run = "cd ${meta.flake}";
        desc = "Go to flake";
      }
    ];
  };
}
