{
  lib,
  pkgs,
  opts,
  ...
}:
{
  services.sing-box = {
    enable = true;
    settings = {
      route = {
        rule_set = [
          {
            tag = "geosite-private";
            type = "local";
            format = "binary";
            path = "${pkgs.sing-geosite}/share/sing-box/rule-set/geosite-private.srs";
          }
          {
            tag = "geosite-cn";
            type = "local";
            format = "binary";
            path = "${pkgs.sing-geosite}/share/sing-box/rule-set/geosite-cn.srs";
          }
          {
            tag = "geoip-cn";
            type = "local";
            format = "binary";
            path = "${pkgs.sing-geoip}/share/sing-box/rule-set/geoip-cn.srs";
          }
          {
            tag = "geosite-category-ads-all";
            type = "local";
            format = "binary";
            path = "${pkgs.sing-geosite}/share/sing-box/rule-set/geosite-category-ads-all.srs";
          }
        ];
      }
      // (opts.proxy.sing-box.settings.route or { });
    }
    // (builtins.removeAttrs (opts.proxy.sing-box.settings or { }) [ "route" ]);
  };
  systemd.services.sing-box.environment =
    lib.mkIf (opts.proxy.sing-box.ENABLE_DEPRECATED_SPECIAL_OUTBOUNDS or false)
      {
        ENABLE_DEPRECATED_SPECIAL_OUTBOUNDS = "true";
      };
  imports = [ ./scripts ];
}
