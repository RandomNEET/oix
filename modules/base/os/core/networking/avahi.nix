{
  services.avahi = {
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
  };
}
