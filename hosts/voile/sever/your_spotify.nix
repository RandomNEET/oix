let
  apiPort = 10500;
  clientPort = 10520;
in
{
  services.your_spotify = {
    enable = true;
    settings = {
      PORT = apiPort;
      API_ENDPOINT = "https://spotifyapi.defnothowl.com";
      CLIENT_ENDPOINT = "https://myspotify.defnothowl.com";
      SPOTIFY_PUBLIC = "8077b8f17e5a45c6a7e121718c0f25c7";
    };
    spotifySecretFile = "/run/secrets/your_spotify";
    enableLocalDB = true;
    nginxVirtualHost = "myspotify.defnothowl.com";
  };
  services.nginx.virtualHosts."myspotify.defnothowl.com" = {
    forceSSL = false;
    enableACME = false;
    listen = [
      {
        addr = "0.0.0.0";
        port = clientPort;
      }
    ];
  };
  networking.firewall.allowedTCPPorts = [
    apiPort
    clientPort
  ];
  systemd.services.your_spotify = {
    after = [
      "sops-nix.service"
    ];
  };
  sops.secrets.your_spotify.sopsFile = ../secrets.yaml;
}
