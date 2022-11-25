{
  lib,
  pkgs,
  ...
}: let
  firefox-sidebar = pkgs.firefox-sidebar.override {
    extensions = [
      # "$src/extensions/window_controls.css"
      "$src/extensions/bookmark_arrow.css"
      "$src/extensions/superbox_removal.css"
      "$src/extensions/avatar_size.css"
    ];

    theme = "$src/themes/gtk_adwaita.css";
  };
in {
  programs.firefox.profiles.default.userChrome = lib.mkAfter (lib.fileContents "${firefox-sidebar}/share/firefox/userChrome.css");
}
