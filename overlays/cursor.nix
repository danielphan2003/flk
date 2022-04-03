final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  buildCursorTheme = cursor:
    prev.writeTextDir "share/icons/default/index.theme" ''
      [icon theme]
      Inherits=${cursor}
    '';
}
