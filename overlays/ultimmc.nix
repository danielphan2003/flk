channels: final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  # i feel ashamed of myself
  ultimmc = let
    inherit (final.sources.ultimmc) pname src version;
    libpath = {
      lib,
      xorg,
      libpulseaudio,
      libGL,
      ...
    }:
      lib.makeLibraryPath [
        xorg.libX11
        xorg.libXext
        xorg.libXcursor
        xorg.libXrandr
        xorg.libXxf86vm
        libpulseaudio
        libGL
      ];
  in
    prev.multimc.overrideAttrs (o: {
      inherit pname src version;

      patches = o.patches ++ prev.lib.our.getPatches ../pkgs/games/ultimmc;

      cmakeFlags = ["-DLauncher_LAYOUT=lin-nodeps"];

      postPatch = ''
        ${o.postPatch or ""}
        substituteInPlace launcher/Launcher.cpp \
          --replace @multimc_jars_location@ $out/share/$pname/jars
      '';

      postInstall = ''
        mkdir -p $out/share/applications

        install -Dm644 ../notsecrets/logo.svg $out/share/pixmaps/$pname.svg

        substitute ../launcher/package/ubuntu/multimc/usr/share/applications/multimc.desktop $out/share/applications/$pname.desktop \
          --replace /opt/multimc/run.sh $pname \
          --replace /opt/multimc/icon.svg $pname.svg \
          --replace 'MultiMC 5' UltimMC

        # xorg.xrandr needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
        wrapProgram $out/bin/$pname \
          --set GAME_LIBRARY_PATH /run/opengl-driver/lib:${libpath prev} \
          --prefix PATH : ${prev.lib.makeBinPath [prev.xorg.xrandr]} \
          --add-flags ${prev.lib.escapeShellArgs ["--dir=$HOME/.local/share/${pname}"]}
      '';
    });
}
