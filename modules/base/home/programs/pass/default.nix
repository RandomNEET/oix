{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (
      exts: with exts; [
        pass-otp
        pass-import
        pass-genphrase
        pass-update
        pass-audit
        pass-checkup
      ]
    );
    settings = {
      PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
    };
  };

  services = {
    # Only one secrets service per user can be enabled at a time.
    pass-secret-service.enable = true;
    gnome-keyring.enable = lib.mkForce false;
  };

  home.packages = with pkgs; [ passepartui ];
}
