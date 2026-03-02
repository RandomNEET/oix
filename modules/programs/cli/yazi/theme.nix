{
  icon = {
    conds = [
      # Special files
      {
        "if" = "orphan";
        text = "";
      }
      {
        "if" = "link";
        text = "";
      }
      {
        "if" = "block";
        text = "";
      }
      {
        "if" = "char";
        text = "";
      }
      {
        "if" = "fifo";
        text = "";
      }
      {
        "if" = "sock";
        text = "";
      }
      {
        "if" = "sticky";
        text = "";
      }
      {
        "if" = "dummy";
        text = "";
      }
      # Fallback
      {
        "if" = "dir";
        text = "󰉋";
      }
      {
        "if" = "exec";
        text = "";
      }
      {
        "if" = "!dir";
        text = "";
      }
    ];

    dirs = [
      {
        name = "dsk";
        text = "";
      }
      {
        name = "doc";
        text = "󱔗";
      }
      {
        name = "dls";
        text = "";
      }
      {
        name = "mus";
        text = "";
      }
      {
        name = "pic";
        text = "";
      }
      {
        name = "pub";
        text = "";
      }
      {
        name = "tpl";
        text = "";
      }
      {
        name = "vid";
        text = "";
      }
      {
        name = ".git";
        text = "";
      }
      {
        name = "tmp";
        text = "󰪺";
      }
      {
        name = "pkg";
        text = "";
      }
      {
        name = "repo";
        text = "";
      }
      {
        name = "oix";
        text = "";
      }
    ];
  };
}
