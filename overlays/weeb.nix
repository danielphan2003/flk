final: prev: {
  trackma = with prev; trackma.override { pillow = python3Packages.pillow-simd; };
}
