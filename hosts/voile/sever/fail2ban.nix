{
  services.fail2ban = {
    enable = true;
    jails = {
      sshd = {
        settings = {
          # 在 NixOS 放行 Nginx 透明代理的回环流量之前检查封禁规则
          chain = "INPUT";
          # Socket 激活使用 sshd@ 实例 新版 OpenSSH 通过 sshd-session 记录认证日志
          # 仅匹配 sshd.service 会漏掉这些日志
          journalmatch = "_SYSTEMD_UNIT=sshd.service + _COMM=sshd + _COMM=sshd-session";
        };
      };
    };
  };
}
