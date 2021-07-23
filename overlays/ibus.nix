final: prev: {
  ibus = prev.ibus.override { withWayland = true; };
  ibus-engines = prev.ibus-engines // {
    bamboo = prev.ibus-engines.bamboo.overrideAttrs (o: rec {
      inherit (final.sources.ibus-bamboo) pname version src;
      nativeBuildInputs = o.nativeBuildInputs ++ (with prev; [ glib gtk3 ]);
    });
  };
}
