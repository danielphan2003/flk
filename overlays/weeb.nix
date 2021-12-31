final: prev: {
  trackma = prev.trackma.override { pillow = prev.python3Packages.pillow-simd; };
}
