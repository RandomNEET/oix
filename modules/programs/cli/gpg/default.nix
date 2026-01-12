{ pkgs, opts, ... }:
let
  desktop = opts.desktop or "";
  hasDesktop = desktop != "";
in
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        programs.gpg = {
          enable = true;
          settings = {
            no-comments = true;
            no-emit-version = true;
            keyid-format = "0xlong";
            with-fingerprint = true;

            personal-cipher-preferences = "AES256 AES192 AES";
            personal-digest-preferences = "SHA512 SHA384 SHA256";
            personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";

            s2k-cipher-algo = "AES256";
            s2k-digest-algo = "SHA512";
            s2k-mode = "3";

            require-cross-certification = true;
            cert-digest-algo = "SHA512";
          };
        };
        services.gpg-agent = {
          enable = true;
          enableSshSupport = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
          pinentry.package = if hasDesktop then pkgs.pinentry-qt else pkgs.pinentry-curses;
          pinentry.program = if hasDesktop then "pinentry-qt" else "pinentry-curses";
        };
        home.packages = [ pkgs.pinentry-all ];
      }
    )
  ];
}
