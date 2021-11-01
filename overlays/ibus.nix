channels: final: prev: {
  ibus = with prev; (ibus.overrideAttrs (_:
    let python3Runtime = python3.withPackages (ps: with ps; [ pygobject3 ]); in
    {
      inherit (final.sources.ibus) pname version src;
      patches =
        [
          (substituteAll {
            src = ../pkgs/tools/inputmethods/ibus/fix-paths.patch;
            pythonInterpreter = python3Runtime.interpreter;
            pythonSitePackages = python3.sitePackages;
          })
          (fetchpatch {
            name = "ibus-wayland-input-method-v2.patch";
            url = "https://patch-diff.githubusercontent.com/raw/ibus/ibus/pull/2256.patch";
            sha256 = "sha256-Ve8Su5R/6atan8mr2TJGmhQEJXF09/z3zK4F/cQ3luo=";
          })
        ];
    })).override { withWayland = true; };

  ibus-engines = prev.ibus-engines // (with channels.latest; {

    bamboo = ibus-engines.bamboo.overrideAttrs (o: {
      inherit (final.sources.ibus-bamboo) pname version src;
      nativeBuildInputs = o.nativeBuildInputs ++ (with prev; [ glib gtk3 ]);
    });

    uniemoji = ibus-engines.uniemoji.overrideAttrs (_: {
      inherit (final.sources.uniemoji) pname version src;
      patches = prev.lib.our.getPatches ../pkgs/tools/inputmethods/ibus-engines/ibus-uniemoji;
    });

  });
}
