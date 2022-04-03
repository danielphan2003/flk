channels: final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  ibus = let
    ibus' = {
      ibus,
      python3,
      systemd,
      gtk4,
      sources,
      fetchpatch,
      substituteAll,
    }: let
      python3Runtime = python3.withPackages (ps: with ps; [pygobject3]);
    in
      ibus.overrideAttrs (o: {
        inherit (sources.ibus) pname version src;
        buildInputs = o.buildInputs ++ [systemd gtk4];
        configureFlags = o.configureFlags ++ ["--enable-gtk4"];
        patches = [
          # Fixes systemd unit installation path https://github.com/ibus/ibus/pull/2388
          (fetchpatch {
            url = "https://github.com/ibus/ibus/commit/33b4b3932bfea476a841f8df99e20049b83f4b0e.patch";
            sha256 = "kh8SBR+cqsov/B0A2YXLJVq1F171qoSRUKbBPHjPRHI=";
          })
          (substituteAll {
            src = ../pkgs/tools/inputmethods/ibus/fix-paths.patch;
            pythonInterpreter = python3Runtime.interpreter;
            pythonSitePackages = python3.sitePackages;
          })
        ];
      });
  in
    final.callPackage ibus' {ibus = prev.ibus.override {withWayland = true;};};

  ibus-with-plugins = prev.ibus-with-plugins.override {inherit (final) ibus;};

  ibus-engines =
    prev.ibus-engines
    // {
      bamboo = prev.ibus-engines.bamboo.overrideAttrs (o: {
        inherit (final.sources.ibus-bamboo) pname version src;
        nativeBuildInputs = o.nativeBuildInputs ++ [prev.glib prev.gtk3];
      });

      uniemoji = prev.ibus-engines.uniemoji.overrideAttrs (_: {
        inherit (final.sources.uniemoji) pname version src;
        patches = prev.lib.our.getPatches ../pkgs/tools/inputmethods/ibus-engines/ibus-uniemoji;
      });
    };
}
