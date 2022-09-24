final: prev: {
  awesome =
    (prev.awesome.override {
      stdenv = final.clangStdenv;
      gtk3Support = true;
    })
    .overrideAttrs (o: {
      inherit (final.fog.awesome) pname src version;

      prePatch = ''
        sed -i "s#/bin/sh#/usr/bin/sh#g" tests/run.sh
      '';

      GI_TYPELIB_PATH =
        "${prev.playerctl}/lib/girepository-1.0:"
        + "${prev.upower}/lib/girepository-1.0:"
        + o.GI_TYPELIB_PATH;
    });
}
