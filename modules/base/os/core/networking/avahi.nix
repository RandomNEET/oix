{ meta, ... }:
{
  services.avahi =
    if (meta.channel == "unstable") then
      {
        # 26.11
        enable = true;
        openFirewall = true;
        nssmdns4 = true;
        settings = {
          publish = {
            disable-publishing = false;
            publish-addresses = true;
            publish-domain = true;
            disable-user-service-publishing = false;
          };
        };
      }
    else
      {
        # 26.05
        enable = true;
        openFirewall = true;
        nssmdns4 = true;
        publish = {
          enable = true;
          addresses = true;
          domain = true;
          userServices = true;
        };
      };
}
