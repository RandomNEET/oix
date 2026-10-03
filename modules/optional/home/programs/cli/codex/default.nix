{
  programs.codex = {
    enable = true;
    enableMcpIntegration = true;
    mutableSettings = true;
    settings = {
      approval_policy = "on-request";
    };
  };
}
