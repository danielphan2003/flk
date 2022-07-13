{
  pkgs,
  lib,
  ...
}: {
  networking.firewall.allowedTCPPorts = [57621];

  environment.systemPackages = [
    (
      if builtins.elem pkgs.system pkgs.spotify-spiced.meta.platforms
      then
        pkgs.spotify-spiced.override
        {
          spotify-unwrapped = pkgs.spotify-unwrapped-1_1_83_954_gd226dfe8; # pin spotify to known version that works with dribbblish-dynamic
          theme = "ddt";
          injectCss = true;
          replaceColors = true;
          overwriteAssets = true;
          customThemes = {
            "ddt" = "${pkgs.dribbblish-dynamic-theme}/theme";
          };
          customExtensions = {
            "ddt.js" = "${pkgs.dribbblish-dynamic-theme}/extensions/dribbblish-dynamic.js";
          };
          customApps = {
            "marketplace" = "${pkgs.spicetify-marketplace}/custom_apps";
          };
          enabledCustomApps = [
            "marketplace"
            "lyrics-plus"
            "new-releases"
            "reddit"
          ];
          enabledExtensions = [
            "ddt.js"
            "fullAppDisplay.js"
            "loopyLoop.js"
            "popupLyrics.js"
            "shuffle+.js"
            "trashbin.js"
          ];
          extraConfig = ''
            [Patch]
            xpui.js_find_8008 = ,(\w+=)32,
            xpui.js_repl_8008 = ,''${1}58,
          '';
        }
      else pkgs.spotify-tui
    )
  ];
}
