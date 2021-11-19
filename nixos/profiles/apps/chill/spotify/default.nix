{ pkgs, lib, ... }: {
  networking.firewall.allowedTCPPorts = [ 57621 ];

  environment.systemPackages = with pkgs; [
    (if builtins.elem system spotify-spicetified.meta.platforms
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
            # "enable-devtools.js" = pkgs.writeText "enable-devtools.js" ''
            #   // @ts-check

            #   /// <reference path="../globals.d.ts" />

            #   (function ChristianSpotify() {
            #       /**
            #       *
            #       * @param {Spicetify.Keyboard.ValidKey} keyName
            #       * @param {boolean} ctrl
            #       * @param {boolean} shift
            #       * @param {boolean} alt
            #       * @param {(event: KeyboardEvent) => void} callback
            #       */
            #       function registerBind(keyName, ctrl, shift, alt, callback) {
            #           const key = Spicetify.Keyboard.KEYS[keyName];

            #           Spicetify.Keyboard.registerShortcut(
            #               {
            #                   key,
            #                   ctrl,
            #                   shift,
            #                   alt,
            #               },
            #               callback
            #           );
            #       }
            #       registerBind("F12", false, false, false, rotateSidebarDown);
            #       document.addEventListener("keydown", function (e) {
            #           if (e.which === 123) {
            #               //F12
            #               require("electron").remote.BrowserWindow.getFocusedWindow().webContents.toggleDevTools();
            #           } else if (e.which === 116) {
            #               //F5
            #               location.reload();
            #           }
            #       });
            #   })();
            # '';
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
    else spotify-tui)
  ];
}
