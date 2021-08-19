channels: final: prev: {
  ibus = (prev.ibus.overrideAttrs (_:
    let python3Runtime = prev.python3.withPackages (ps: with ps; [ pygobject3 ]); in
    {
      inherit (final.sources.ibus) pname version src;
      patches = [
        (prev.substituteAll {
          src = ../pkgs/tools/inputmethods/ibus/fix-paths.patch;
          pythonInterpreter = python3Runtime.interpreter;
          pythonSitePackages = prev.python3.sitePackages;
        })
      ];
    })).override { withWayland = true; };

  ibus-engines = prev.ibus-engines // {

    bamboo = channels.latest.ibus-engines.bamboo.overrideAttrs (o: rec {
      inherit (final.sources.ibus-bamboo) pname version src;
      nativeBuildInputs = o.nativeBuildInputs ++ (with prev; [ glib gtk3 ]);
    });

    uniemoji = channels.latest.ibus-engines.uniemoji.overrideAttrs (_: rec {
      inherit (final.sources.uniemoji) pname version src;
      patches = [
        ../pkgs/tools/inputmethods/ibus-engines/ibus-uniemoji/allow-wrapping.patch
      ];
    });

  };
}
