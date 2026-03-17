{
  config,
  lib,
  pkgs,
  ...
}:
if (config.services.snapper.configs != { }) then
  let
    configNames = builtins.attrNames config.services.snapper.configs;
  in
  pkgs.writeShellScriptBin "snapper-list" ''
    C_RES=$'\e[0m'
    C_BOLD=$'\e[1m'
    C_RED=$'\e[31m'
    C_GREEN=$'\e[32m'
    C_YELLOW=$'\e[33m'
    C_BLUE=$'\e[34m'
    C_MAGENTA=$'\e[35m'
    C_CYAN=$'\e[36m'
    C_WHITE=$'\e[37m'
    C_GREY=$'\e[90m'
    {
      ${lib.concatMapStringsSep "\n" (name: ''
        echo -e "\n''${C_BOLD}''${C_RED}Config: [${name}]''${C_RES}"
        ${pkgs.snapper}/bin/snapper -c ${name} list | ${pkgs.gawk}/bin/awk -F '│' \
          -v CR="''${C_RES}" \
          -v CB="''${C_BOLD}" \
          -v CRED="''${C_RED}" \
          -v CG="''${C_GREEN}" \
          -v CY="''${C_YELLOW}" \
          -v CBL="''${C_BLUE}" \
          -v CM="''${C_MAGENTA}" \
          -v CC="''${C_CYAN}" \
          -v CW="''${C_WHITE}" \
          -v CGR="''${C_GREY}" \
          '
          {
            if ($0 ~ /^──/) { 
              print CW $0 CR 
            } else if ($0 ~ /^\s*#/) { 
              print CB CW $0 CR 
            } else {
              # $1=#, $2=Type, $3=Pre#, $4=Date, $5=User, $6=Cleanup, $7=Description, $8=Userdata
              printf "%s%s%s│%s%s%s│%s%s%s│%s%s%s│%s%s%s│%s%s%s│%s%s%s│%s%s%s\n",
                CY, $1, CR,
                CC, $2, CR,
                CGR, $3, CR,
                CG, $4, CR,
                CBL, $5, CR,
                CM, $6, CR,
                CW, $7, CR,
                CGR, $8, CR
            }
          }
          '
      '') configNames}
    } | ${pkgs.less}/bin/less -RS
  ''
else
  null
