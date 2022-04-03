channels: final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  ragenix = channels.latest.ragenix.override {
    plugins = [final.age-plugin-yubikey];
  };
}
