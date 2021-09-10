{ pkgs, lib, ... }:
{
  networking.firewall.allowedTCPPorts = [ 57621 ];

  environment.systemPackages = with pkgs; [
    (if builtins.elem system spotify-spicetified.meta.platforms
    then
      spotify-spicetified.override
        {
          # theme = "Dribbblish";
          # theme = "ddt";
          # theme = "Fluent";
          # colorScheme = "base";
          # colorScheme = "dark";
          theme = "Ziro";
          colorScheme = "red-dark";
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
            # "ddt.js"
            # "dribbblish.js"
            # "ddt-dynamic.js"
            # "Vibrant.min.js"
            # "fluent.js"
            "fullAppDisplay.js"
            "loopyLoop.js"
            "popupLyrics.js"
            "shuffle+.js"
            "trashbin.js"
          ];
          # extraConfig = ''
          #   [Patch]
          #   xpui.js_find_8008 = ,(\w+=)32,
          #   xpui.js_repl_8008 = ,''${1}56,
          # '';
        }
    else spotify-tui)
  ];
}
