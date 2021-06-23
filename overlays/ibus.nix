final: prev: {
  ibus = prev.ibus.override {
    withWayland = true;
    dconf = prev.dconf;
    libnotify = prev.libnotify;
  };
  ibus-engines = prev.ibus-engines // {
    bamboo = prev.ibus-engines.bamboo.overrideAttrs
      (o:
        let src = final.srcs.ibus-bamboo;
        in
        {
          inherit src;
          inherit (src) version;
          nativeBuildInputs = o.nativeBuildInputs ++ [ prev.glib prev.gtk3 ];
          buildInputs = o.buildInputs ++ [ prev.glib ];
        });
  };
}
