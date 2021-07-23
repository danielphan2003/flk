{ pkgs, lib, ... }:
{
  networking.firewall.allowedTCPPorts = [ 57621 ];

  environment.systemPackages = with pkgs; [
    (if system == "x86_64-linux"
    then
      spotify-spicetified.override
        {
          theme = "ddt";
          colorScheme = "base";
          injectCss = true;
          replaceColors = true;
          overwriteAssets = true;
          customThemes = {
            "ddt" = "${pkgs.dribbblish-dynamic-theme}/theme";
          };
          customExtensions = {
            "ddt.js" = "${pkgs.dribbblish-dynamic-theme}/extensions/dribbblish.js";
            "ddt-dynamic.js" = "${pkgs.dribbblish-dynamic-theme}/extensions/dribbblish-dynamic.js";
            "Vibrant.min.js" = "${pkgs.dribbblish-dynamic-theme}/extensions/Vibrant.min.js";
          };
          enabledCustomApps = [
            "lyrics-plus"
            "new-releases"
            "reddit"
          ];
          enabledExtensions = [
            "ddt.js"
            "ddt-dynamic.js"
            "Vibrant.min.js"
            "fullAppDisplay.js"
            "loopyLoop.js"
            "popupLyrics.js"
            "shuffle+.js"
            "trashbin.js"
          ];
          spotifyLaunchFlags = [ "--enable-developer-mode" ];
        }
    else spotify-tui)
  ];
}
