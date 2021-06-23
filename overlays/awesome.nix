final: prev: {
  awesome =
    (prev.awesome.overrideAttrs
      (o:
        let src = final.srcs.awesome;
        in
        {
          # inherit src;
          # inherit (src) version;
          # prePatch = ''
          #   sed -i "s#/bin/sh#/usr/bin/sh#g" tests/run.sh
          # '';
          # GI_TYPELIB_PATH = "${prev.playerctl}/lib/girepository-1.0:"
          #   + "${prev.upower}/lib/girepository-1.0:" + o.GI_TYPELIB_PATH;
        })
    ).override {
      # stdenv = prev.clangStdenv;
      # gtk3Support = true;
    };
}
