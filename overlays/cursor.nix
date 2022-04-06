final: prev: {
  buildCursorTheme = cursor:
    prev.writeTextDir "share/icons/default/index.theme" ''
      [icon theme]
      Inherits=${cursor}
    '';
}
