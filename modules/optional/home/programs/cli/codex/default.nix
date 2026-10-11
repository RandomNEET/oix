{
  programs.codex = {
    enable = true;
    enableMcpIntegration = true;
    mutableSettings = true;
    settings = {
      approval_policy = "on-request";
      tui = {
        keymap = {
          chat = {
            edit_queued_message = [ "ctrl-shift-left" ];
            prompt_stack_back = [ "ctrl-shift-right" ];
          };
          list = {
            move_left = [ "ctrl-shift-left" ];
            move_right = [ "ctrl-shift-right" ];
          };
        };
      };
    };
  };
}
