channels: final: prev: {
  # i feel ashamed of myself
  ultimmc = with channels.latest; let
    libpath = with xorg; lib.makeLibraryPath [ libX11 libXext libXcursor libXrandr libXxf86vm libpulseaudio libGL ];
  in
  multimc.overrideAttrs (o: {
    inherit (final.sources.ultimmc) pname src version;

    patches = o.patches ++ prev.lib.our.getPatches ../pkgs/games/ultimmc;

    cmakeFlags = [ "-DLauncher_LAYOUT=lin-nodeps" ];

    postPatch = ''
      ${o.postPatch or ""}
      substituteInPlace launcher/Launcher.cpp \
        --replace @multimc_jars_location@ $out/share/$pname/jars
    '';

    postInstall = ''
      mkdir -p $out/share/applications

      install -Dm644 ../notsecrets/logo.svg $out/share/pixmaps/ultimmc.svg

      substitute ../launcher/package/ubuntu/multimc/usr/share/applications/multimc.desktop $out/share/applications/ultimmc.desktop \
        --replace /opt/multimc/run.sh ultimmc \
        --replace /opt/multimc/icon.svg ultimmc.svg \
        --replace 'MultiMC 5' UltimMC

      # xorg.xrandr needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
      wrapProgram $out/bin/ultimmc \
        --set GAME_LIBRARY_PATH /run/opengl-driver/lib:${libpath} \
        --prefix PATH : ${lib.makeBinPath [ xorg.xrandr ]} \
        --add-flags ${lib.escapeShellArgs [ "--dir=$HOME/.local/share/ultimmc" ]}
    '';
  });
}
