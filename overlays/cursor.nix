final: prev: {
  buildCursorTheme = cursor:
    final.writeTextDir "share/icons/default/index.theme" ''
      [icon theme]
      Inherits=${cursor}
    '';
}
