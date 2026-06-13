{
  osConfig,
  config,
  lib,
  pkgs,
  launcher,
  clip-manager,
  file-manager,
  autoclicker,
  ...
}:
let
  termInfo = import ../shared/misc/terminal.nix { inherit config; };
  terminal = termInfo.exe;
  fileManager = "${file-manager} ${config.defaultPrograms.fileManager}";
  editor = "${terminal} ${termInfo.classFlag} editor -e ${config.defaultPrograms.editor}";
  browser = config.defaultPrograms.browser;
in
{
  bind = [
    "SUPER,q,killclient"
    "SUPER,w,togglefloating"
    "SUPER,g,toggleglobal"
    "SUPER,Tab,toggleoverview"
    "ALT,Return,togglefullscreen"
    "ALT+SHIFT,f,togglefakefullscreen"
    "SUPER+SHIFT,I,restore_minimized"
    "SUPER,o,toggleoverlay"
    "SUPER,s,toggle_scratchpad"
    "SUPER+CTRL,s,minimized"

    "SUPER,Return,spawn,${terminal}"
    "SUPER,f,spawn,${fileManager}"
    "SUPER,e,spawn,${editor}"
    "SUPER,b,spawn,${browser}"
    "SUPER,Space,spawn,${launcher} drun"
    "SUPER,v,spawn,${clip-manager}"
    "SUPER+CTRL,T,spawn,${launcher} theme"
    "SUPER+SHIFT,a,spawn,noctalia msg panel-toggle control-center"
    "SUPER+SHIFT,q,spawn,noctalia msg panel-toggle control-center notifications"
    "SUPER+CTRL,q,spawn,noctalia msg notification-clear-history"
    "SUPER+ALT,q,spawn,noctalia msg notification-dnd-toggle"
    "SUPER+SHIFT,w,spawn,noctalia msg wallpaper-random"
    "SUPER+CTRL,w,spawn,noctalia msg panel-toggle wallpaper"
    "CTRL,Escape,spawn,noctalia msg bar-toggle"
    "SUPER+ALT,l,spawn,noctalia msg session lock"
    "SUPER,BackSpace,spawn,noctalia msg panel-toggle session"
    "SUPER,F10,spawn,${terminal} -e ${lib.getExe pkgs.btop}"
    "SUPER,F12,spawn_shell,kill $(cat /tmp/auto-clicker.pid) 2>/dev/null || ${autoclicker} --cps 40"

    "SUPER,p,spawn,noctalia msg screenshot-region"
    "SUPER+SHIFT,p,spawn,noctalia msg screenshot-fullscreen"
    "SUPER+CTRL,p,spawn_shell,touch /tmp/noctalia-screenshot-ocr && noctalia msg screenshot-region"

    "SUPER,Left,focusdir,left"
    "SUPER,Right,focusdir,right"
    "SUPER,Up,focusdir,up"
    "SUPER,Down,focusdir,down"
    "SUPER,h,focusdir,left"
    "SUPER,l,focusdir,right"
    "SUPER,k,focusdir,up"
    "SUPER,j,focusdir,down"
    "SUPER,Tab,focusstack,next"

    "SUPER+SHIFT,Left,exchange_client,left"
    "SUPER+SHIFT,Right,exchange_client,right"
    "SUPER+SHIFT,Up,exchange_client,up"
    "SUPER+SHIFT,Down,exchange_client,down"
    "SUPER+SHIFT,h,exchange_client,left"
    "SUPER+SHIFT,l,exchange_client,right"
    "SUPER+SHIFT,k,exchange_client,up"
    "SUPER+SHIFT,j,exchange_client,down"

    "SUPER+SHIFT+CTRL,h,resizewin,-30,0"
    "SUPER+SHIFT+CTRL,l,resizewin,30,0"
    "SUPER+SHIFT+CTRL,k,resizewin,0,-30"
    "SUPER+SHIFT+CTRL,j,resizewin,0,30"
    "SUPER+SHIFT,Left,resizewin,-30,0"
    "SUPER+SHIFT,Right,resizewin,30,0"
    "SUPER+SHIFT,Up,resizewin,0,-30"
    "SUPER+SHIFT,Down,resizewin,0,30"

    "SUPER,1,view,1,0"
    "SUPER,2,view,2,0"
    "SUPER,3,view,3,0"
    "SUPER,4,view,4,0"
    "SUPER,5,view,5,0"
    "SUPER,6,view,6,0"
    "SUPER,7,view,7,0"
    "SUPER,8,view,8,0"
    "SUPER,9,view,9,0"

    "SUPER+SHIFT,1,tag,1,0"
    "SUPER+SHIFT,2,tag,2,0"
    "SUPER+SHIFT,3,tag,3,0"
    "SUPER+SHIFT,4,tag,4,0"
    "SUPER+SHIFT,5,tag,5,0"
    "SUPER+SHIFT,6,tag,6,0"
    "SUPER+SHIFT,7,tag,7,0"
    "SUPER+SHIFT,8,tag,8,0"
    "SUPER+SHIFT,9,tag,9,0"

    "SUPER+CTRL,1,toggletag,1"
    "SUPER+CTRL,2,toggletag,2"
    "SUPER+CTRL,3,toggletag,3"
    "SUPER+CTRL,4,toggletag,4"
    "SUPER+CTRL,5,toggletag,5"
    "SUPER+CTRL,6,toggletag,6"
    "SUPER+CTRL,7,toggletag,7"
    "SUPER+CTRL,8,toggletag,8"
    "SUPER+CTRL,9,toggletag,9"

    "SUPER,Left,viewtoleft,0"
    "SUPER,Right,viewtoright,0"
    "SUPER+CTRL,Left,viewtoleft_have_client,0"
    "SUPER+CTRL,Right,viewtoright_have_client,0"

    "SUPER+CTRL+ALT,Left,tagtoleft,0"
    "SUPER+CTRL+ALT,Right,tagtoright,0"

    "ALT+SHIFT,Left,focusmon,left"
    "ALT+SHIFT,Right,focusmon,right"
    "SUPER+ALT,Left,tagmon,left"
    "SUPER+ALT,Right,tagmon,right"

    "ALT,e,set_proportion,1.0"
    "ALT,x,switch_proportion_preset"
    "ALT+SUPER+CTRL,Left,scroller_stack,left"
    "ALT+SUPER+CTRL,Right,scroller_stack,right"
    "ALT+SUPER+CTRL,Up,scroller_stack,up"
    "ALT+SUPER+CTRL,Down,scroller_stack,down"
    "ALT+SHIFT,Return,dwindle_toggle_split_direction"
    "SUPER,n,switch_layout"

    "ALT+SHIFT,X,incgaps,1"
    "ALT+SHIFT,Z,incgaps,-1"
    "ALT+SHIFT,R,togglegaps"

    "none,XF86AudioMute,spawn,noctalia msg volume-mute"
    "none,XF86AudioMicMute,spawn,noctalia msg mic-mute"
    "none,XF86AudioPlay,spawn,noctalia msg media toggle"
    "none,XF86AudioPause,spawn,noctalia msg media stop"
    "none,XF86AudioNext,spawn,noctalia msg media next"
    "none,XF86AudioPrev,spawn,noctalia msg media previous"
    "none,XF86AudioLowerVolume,spawn,noctalia msg volume-down"
    "none,XF86AudioRaiseVolume,spawn,noctalia msg volume-up"
    "none,XF86MonBrightnessDown,spawn,noctalia msg brightness-down"
    "none,XF86MonBrightnessUp,spawn,noctalia msg brightness-up"

    "SUPER,M,setkeymode,mouse"
  ]
  ++ lib.optional config.programs.rbw.enable ("SUPER+ALT,U,spawn,${launcher} rbw")
  ++ lib.optional config.programs.translate-shell.enable ("SUPER+ALT,T,spawn,${launcher} translate")
  ++ lib.optionals config.programs.tmux.enable [
    "SUPER,T,spawn,${terminal} -e tmux"
    "SUPER+SHIFT,T,spawn,${launcher} tmux"
  ]
  ++ lib.optional osConfig.programs.steam.enable ("SUPER+CTRL,G,spawn,${launcher} game");

  mousebind = [
    "SUPER,btn_left,moveresize,curmove"
    "SUPER,btn_right,moveresize,curresize"
  ];

  axisbind = [
    "SUPER,UP,viewtoleft_have_client"
    "SUPER,DOWN,viewtoright_have_client"
  ];

  keymode = {
    mouse = {
      bind = [
        "NONE,H,spawn,wlrctl pointer move -10 0"
        "NONE,L,spawn,wlrctl pointer move 10 0"
        "NONE,K,spawn,wlrctl pointer move 0 -10"
        "NONE,J,spawn,wlrctl pointer move 0 10"

        "SHIFT,H,spawn,wlrctl pointer move -100 0"
        "SHIFT,L,spawn,wlrctl pointer move 100 0"
        "SHIFT,K,spawn,wlrctl pointer move 0 -100"
        "SHIFT,J,spawn,wlrctl pointer move 0 100"

        "NONE,N,spawn,wlrctl pointer scroll 30"
        "NONE,P,spawn,wlrctl pointer scroll -30"

        "NONE,comma,spawn,wlrctl pointer click left"
        "NONE,period,spawn,wlrctl pointer click right"

        "NONE,Escape,setkeymode,default"
        "NONE,Q,setkeymode,default"
      ];
    };
  };
}
