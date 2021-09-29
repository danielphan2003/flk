channels: final: prev: {
  ulauncher = with channels.latest; (ulauncher.override {
    python3Packages = python3Packages // {
      buildPythonApplication = args:
        python3Packages.buildPythonApplication (args // {
          inherit (final.sources.ulauncher) src version;
        });
    };
  }).overrideAttrs (o: {
    patches = prev.lib.our.getPatches ../pkgs/applications/misc/ulauncher;

    propagatedBuildInputs = with python3Packages;
      o.propagatedBuildInputs ++ [ pycairo ];

    preFixup = ''
      makeWrapperArgs+=(
        "''${gappsWrapperArgs[@]}"
        --prefix PATH : "${lib.makeBinPath [ wmctrl ]}"
        --set GDK_PIXBUF_MODULE_FILE ${librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache
      )
    '';
  });
}
