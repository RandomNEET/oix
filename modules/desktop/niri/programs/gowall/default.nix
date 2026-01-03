{ pkgs, ... }:
{
  home-manager.sharedModules = [
    (_: {
      home = {
        packages = with pkgs; [
          gowall
          tesseract
        ];
        file = {
          ".config/gowall/schema.yml".text = ''
            schemas:
              - name: "tes"
                config:
                  ocr:
                    provider: "tesseract"
                    model: "tesseract"
          '';
          ".config/gowall/config.yml".text = ''
            EnableImagePreviewing: true
          '';
        };
      };
    })
  ];
}
