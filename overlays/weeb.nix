final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  trackma = prev.trackma.override {pillow = prev.python3Packages.pillow-simd;};
}
