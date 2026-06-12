{
  layerrule = [ "animation_type_open:zoom,noanim:0,layer_name:rofi" ];
  windowrule = [
    "focused_opacity:1,unfocused_opacity:1,appid:^(org\.qutebrowser\.qutebrowser)$"
    "focused_opacity:1,unfocused_opacity:1,appid:^(firefox)$"

    "focused_opacity:0.8,unfocused_opacity:0.8,appid:^(kitty|foot|footclient)$"
    "focused_opacity:0.8,unfocused_opacity:0.8,appid:^(editor)$"
    "focused_opacity:0.8,unfocused_opacity:0.8,appid:^(fileManager)$"
    "focused_opacity:0.8,unfocused_opacity:0.8,appid:^(code)$"
    "focused_opacity:0.8,unfocused_opacity:0.8,appid:^(spotify)$"
    "focused_opacity:0.8,unfocused_opacity:0.8,appid:^(steam)$"
    "focused_opacity:0.8,unfocused_opacity:0.8,appid:^(org\.gnupg\.pinentry-qt)$"

    "focused_opacity:0.8,unfocused_opacity:0.8,isfloating:1,appid:^(terminal filechooser)$"
    "focused_opacity:0.8,unfocused_opacity:0.8,isfloating:1,title:^(Authentication Required)$"

    "isfloating:1,appid:^(firefox)$,title:^Picture-in-Picture$"
  ];
}
