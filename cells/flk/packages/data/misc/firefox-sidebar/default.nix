{
  lib,
  fog,
  concatTextFile,
  substituteAll,
  prefs ? "$src/prefs.css",
  sidebar ? "$src/extensions/sidebar.css",
  theme ? "$src/custom.css",
  extensions ? [
    "$src/extensions/window_controls.css"
    "$src/extensions/bookmark_arrow.css"
    "$src/extensions/superbox_removal.css"
    "$src/extensions/avatar_size.css"
    # "${src}/extensions/fix_hidden_bookmarks.css"
    # "${src}/extensions/hide_sidebar_switcher.css"
  ],
  extraConfig ? "$src/custom.css",
}: let
  inherit (fog.firefox-sidebar) pname src version;

  replaceSrc = lib.replaceStrings ["$src"] [src.outPath];

  userChrome = substituteAll {
    src = ./userChrome.css;

    prefs = replaceSrc prefs;

    sidebar = replaceSrc sidebar;

    theme = replaceSrc theme;

    extensions =
      lib.concatMapStringsSep
      "\n\n"
      (x: ''@import url("${replaceSrc x}");'')
      extensions;

    extraConfig = replaceSrc extraConfig;
  };
in
  concatTextFile {
    name = "${pname}-${version}";
    files = [userChrome];
    destination = "/share/firefox/userChrome.css";
  }
