final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  qbittorrent = prev.qbittorrent.override {guiSupport = false;};
}
