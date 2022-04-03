final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  vscode-extensions = prev.vscode-extensions // {};
}
