{
  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 10300;
    };
    environmentFile = "/run/secrets/vaultwarden";
  };
  systemd.services.vaultwarden = {
    after = [
      "sops-nix.service"
    ];
  };
  sops.secrets.vaultwarden = {
    sopsFile = ../secrets.yaml;
    owner = "vaultwarden";
  };
}
