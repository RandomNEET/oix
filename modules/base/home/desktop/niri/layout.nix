{
  gaps = 10;
  background-color = "transparent";
  center-focused-column = "never";

  preset-column-widths._children = [
    { proportion = 1.0 / 3.0; }
    { proportion = 0.5; }
    { proportion = 2.0 / 3.0; }
  ];

  default-column-width = {
    proportion = 0.5;
  };

  focus-ring = {
    off = { };
  };

  border = {
    on = { };
    width = 2;
  };

  shadow = {
    on = { };
    softness = 30;
    spread = 5;
    offset._props = {
      x = 0;
      y = 5;
    };
  };
}
