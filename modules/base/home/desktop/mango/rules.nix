{
  layer_rule = [ "animation_type_open:none,layer_name:^(noctalia-screenshot-region)$" ];

  window_rule = [
    "focused_opacity:1,unfocused_opacity:1,app_id:^(org.qutebrowser.qutebrowser)$"
    "focused_opacity:1,unfocused_opacity:1,app_id:^([Ff]irefox)$"

    "focused_opacity:0.8,unfocused_opacity:0.8,app_id:^(kitty|foot|footclient)$"
    "focused_opacity:0.8,unfocused_opacity:0.8,app_id:^(editor)$"
    "focused_opacity:0.8,unfocused_opacity:0.8,app_id:^(fileManager)$"
    "focused_opacity:0.8,unfocused_opacity:0.8,app_id:^(code)$"
    "focused_opacity:0.8,unfocused_opacity:0.8,app_id:^([Ss]potify)$"
    "focused_opacity:0.8,unfocused_opacity:0.8,app_id:^([Ss]team)$"
    "focused_opacity:0.8,unfocused_opacity:0.8,app_id:^(org.gnupg.pinentry-qt)$"

    "focused_opacity:0.8,unfocused_opacity:0.8,is_floating:1,app_id:^(terminal filechooser)$"

    "is_floating:1,app_id:^(dev.noctalia.Noctalia)$"
  ];
}
