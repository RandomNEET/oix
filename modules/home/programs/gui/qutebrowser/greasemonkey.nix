{ pkgs, ... }:
[
  # youtube-adb
  (pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/iamfugui/youtube-adb/main/index.user.js";
    sha256 = "sha256-2/nwJY+3vC1fs5bKTnPWpoG3QKFOpf9WIq0cSetrBOg=";
  })
]
