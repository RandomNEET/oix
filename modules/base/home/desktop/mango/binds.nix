{
  osConfig,
  config,
  lib,
  pkgs,
  launcher,
  clip-manager,
  file-manager,
  screenshot,
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
    "SUPER,i,minimized"
    "SUPER+SHIFT,I,restore_minimized"
    "SUPER,o,toggleoverlay"
    "SUPER,s,toggle_scratchpad"

    "SUPER,Return,spawn,${terminal}"
    "SUPER,f,spawn,${fileManager}"
    "SUPER,e,spawn,${editor}"
    "SUPER,b,spawn,${browser}"
    "SUPER,Space,spawn,${launcher} drun"
    "SUPER,v,spawn,${clip-manager}"
    "SUPER+CTRL,T,spawn,${launcher} theme"
    "SUPER+SHIFT,a,spawn,noctalia-shell ipc call controlCenter toggle"
    "SUPER+SHIFT,q,spawn,noctalia-shell ipc call notifications toggleHistory"
    "SUPER+CTRL,q,spawn,noctalia-shell ipc call notifications clear"
    "SUPER+ALT,q,spawn,noctalia-shell ipc call notifications toggleDND"
    "SUPER+SHIFT,w,spawn,noctalia-shell ipc call wallpaper random all"
    "SUPER+CTRL,w,spawn,noctalia-shell ipc call wallpaper toggle"
    "SUPER+ALT,w,spawn,noctalia-shell ipc call wallpaper toggleAutomation"
    "CTRL,Escape,spawn,noctalia-shell ipc call bar toggle"
    "SUPER+ALT,l,spawn,noctalia-shell ipc call lockScreen lock"
    "SUPER,BackSpace,spawn,noctalia-shell ipc call sessionMenu toggle"
    "SUPER,F10,spawn,${terminal} -e ${lib.getExe pkgs.btop}"
    "SUPER,F12,spawn,kill $(cat /tmp/auto-clicker.pid) 2>/dev/null || ${autoclicker} --cps 40"

    "SUPER,p,spawn,${screenshot} s"
    "SUPER+SHIFT,p,spawn,${screenshot} a"
    "SUPER+CTRL,p,spawn,${screenshot} o"

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

    "SUPER+SHIFT,Left,resizewin,-30,0"
    "SUPER+SHIFT,Right,resizewin,30,0"
    "SUPER+SHIFT,Up,resizewin,0,-30"
    "SUPER+SHIFT,Down,resizewin,0,30"
    "SUPER+SHIFT,h,resizewin,-30,0"
    "SUPER+SHIFT,l,resizewin,30,0"
    "SUPER+SHIFT,k,resizewin,0,-30"
    "SUPER+SHIFT,j,resizewin,0,30"

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

    "SUPER+CTRL,1,tagsilent,1"
    "SUPER+CTRL,2,tagsilent,2"
    "SUPER+CTRL,3,tagsilent,3"
    "SUPER+CTRL,4,tagsilent,4"
    "SUPER+CTRL,5,tagsilent,5"
    "SUPER+CTRL,6,tagsilent,6"
    "SUPER+CTRL,7,tagsilent,7"
    "SUPER+CTRL,8,tagsilent,8"
    "SUPER+CTRL,9,tagsilent,9"

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

    "none,XF86AudioMute,spawn,noctalia-shell ipc call volume muteOutput"
    "none,XF86AudioMicMute,spawn,noctalia-shell ipc call volume muteInput"
    "none,XF86AudioPlay,spawn,noctalia-shell ipc call media play"
    "none,XF86AudioPause,spawn,noctalia-shell ipc call media pause"
    "none,XF86AudioNext,spawn,noctalia-shell ipc call media next"
    "none,XF86AudioPrev,spawn,noctalia-shell ipc call media previous"
    "none,XF86AudioLowerVolume,spawn,noctalia-shell ipc call volume decrease"
    "none,XF86AudioRaiseVolume,spawn,noctalia-shell ipc call volume increase"
    "none,XF86MonBrightnessDown,spawn,noctalia-shell ipc call brightness decrease"
    "none,XF86MonBrightnessUp,spawn,noctalia-shell ipc call brightness increase"
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
}
