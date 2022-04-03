final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  # wrapper to specify config file
  qute = prev.writeShellScriptBin "qute" ''
    QUTE_DARKMODE_VARIANT=qt_515_2 QT_QPA_PLATFORMTHEME= exec ${final.qutebrowser}/bin/qutebrowser -C /etc/xdg/qutebrowser/config.py "$@"
  '';
}
