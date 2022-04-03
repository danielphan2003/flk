{
  pkgs,
  lib,
  ...
}: {
  networking.firewall.allowedTCPPorts = [57621];

  environment.systemPackages = with pkgs; [
    (
      if builtins.elem system spotify-spicetified.meta.platforms
      then
        spotify-spicetified.override
        {
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
          enabledCustomApps = [
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
      else spotify-tui
    )
  ];
}
