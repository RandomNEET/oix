{ opts, ... }:
{
  services.calibre-web = {
    enable = true;
    openFirewall = true;

    user = opts.calibre-web.user or "calibre-web";
    group = opts.calibre-web.group or "calibre-web";

    dataDir = opts.calibre-web.dataDir or "calibre-web";

    listen = {
      ip = opts.calibre-web.listen.ip or "::1";
      port = opts.calibre-web.listen.port or 8083;
    };

    options = {
      calibreLibrary = opts.calibre-web.options.calibreLibrary or null;
      enableBookUploading = opts.calibre-web.options.enableBookUploading or false;
      enableBookConversion = opts.calibre-web.options.enableBookConversion or false;
      enableKepubify = opts.calibre-web.options.enableKepubify or false;
      reverseProxyAuth = {
        enable = opts.calibre-web.options.reverseProxyAuth.enable or false;
        header = opts.calibre-web.options.reverseProxyAuth.header or "";
      };
    };
  };
}
