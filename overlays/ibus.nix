final: prev: {
  ibus = prev.ibus.override {
    withWayland = true;
    dconf = prev.dconf;
    libnotify = prev.libnotify;
  };
  ibus-engines = prev.ibus-engines // {
    bamboo = prev.ibus-engines.bamboo.overrideAttrs (o: rec{
      inherit (prev.sources.ibus-bamboo) pname version src;
      nativeBuildInputs = o.nativeBuildInputs ++ (with prev; [ glib gtk3 ]);
      # buildInputs = o.buildInputs ++ (with prev; [ glib ]);
    });
  };
}
