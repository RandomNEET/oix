{
  curve = [
    {
      _args = [
        "md3_decel"
        {
          type = "bezier";
          points = [
            [
              0.05
              0.7
            ]
            [
              0.1
              1
            ]
          ];
        }
      ];
    }
    {
      _args = [
        "easeOutExpo"
        {
          type = "bezier";
          points = [
            [
              0.16
              1
            ]
            [
              0.3
              1
            ]
          ];
        }
      ];
    }
    {
      _args = [
        "fluent_decel"
        {
          type = "bezier";
          points = [
            [
              0.1
              1
            ]
            [
              0
              1
            ]
          ];
        }
      ];
    }
  ];

  animation = [
    {
      leaf = "windows";
      enabled = true;
      speed = 3;
      bezier = "md3_decel";
      style = "popin 60%";
    }
    {
      leaf = "border";
      enabled = true;
      speed = 10;
      bezier = "default";
    }
    {
      leaf = "fade";
      enabled = true;
      speed = 2.5;
      bezier = "md3_decel";
    }
    {
      leaf = "workspaces";
      enabled = true;
      speed = 3.5;
      bezier = "easeOutExpo";
      style = "slide";
    }
    {
      leaf = "specialWorkspace";
      enabled = true;
      speed = 3;
      bezier = "md3_decel";
      style = "slidefade";
    }
  ];
}
