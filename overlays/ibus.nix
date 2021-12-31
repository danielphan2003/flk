channels: final: prev: {
  ibus =
    let
      ibus' =
        { ibus
        , python3
        , sources
        , fetchpatch
        , substituteAll
        }:
        let
          python3Runtime = python3.withPackages (ps: with ps; [ pygobject3 ]);
        in
        ibus.overrideAttrs (_: {
          inherit (sources.ibus) pname version src;
          patches =
            [
              (substituteAll {
                src = ../pkgs/tools/inputmethods/ibus/fix-paths.patch;
                pythonInterpreter = python3Runtime.interpreter;
                pythonSitePackages = python3.sitePackages;
              })
            ];
        });
    in
    final.callPackage ibus' { ibus = prev.ibus.override { withWayland = true; }; };

  ibus-with-plugins = prev.ibus-with-plugins.override { inherit (final) ibus; };

  ibus-engines = prev.ibus-engines // {

    bamboo = prev.ibus-engines.bamboo.overrideAttrs (o: {
      inherit (final.sources.ibus-bamboo) pname version src;
      nativeBuildInputs = o.nativeBuildInputs ++ [ prev.glib prev.gtk3 ];
    });

    uniemoji = prev.ibus-engines.uniemoji.overrideAttrs (_: {
      inherit (final.sources.uniemoji) pname version src;
      patches = prev.lib.our.getPatches ../pkgs/tools/inputmethods/ibus-engines/ibus-uniemoji;
    });

  };
}
