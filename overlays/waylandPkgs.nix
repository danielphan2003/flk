channels: final: prev: {
  wayland-protocols-master = channels.latest.wayland-protocols.overrideAttrs (_: {
    inherit (prev.wayland-protocols-master) src version;
  });

  wlroots-eglstreams = prev.wlroots-eglstreams.override { wayland-protocols = final.wayland-protocols-master; };

  wlroots = final.wlroots-eglstreams;

  freerdp = prev.wlfreerdp;

  eww = prev.eww.override { enableWayland = true; };

  sway-unwrapped = prev.sway-unwrapped.overrideAttrs (_: {
    inherit (final.sources.sway-borders) version src;
  });

  xwayland = with channels.latest; let
    xorgproto = xorg.xorgproto.overrideAttrs (_: {
      inherit (final.sources.xorgproto) src version;
    });
  in
  (xwayland.override { wayland-protocols = final.wayland-protocols-master; }).overrideAttrs (o: {
    inherit (final.sources.xwayland) src version;

    buildInputs = [
      xorgproto
      dbus
      makeWrapper
      prev.systemd
    ]
    ++ (with final.xorg; [ libxcvt libpciaccess ])
    ++ o.buildInputs;

    # Is this the right way to fix Xwayland not launching?
    # it says it can't use eglstream device, even though I'm not using nVidia...
    postFixup = ''
      wrapProgram $out/bin/Xwayland \
        --add-flags ${prev.lib.escapeShellArg "-shm"}
    '';
  });

  swaylock-effects = prev.swaylock-effects.overrideAttrs (_: {
    inherit (final.sources.swaylock-effects) pname version src;
  });

  rofi-unwrapped =
    let
      inherit (final.sources.rofi-wayland) pname src version;
    in
    channels.latest.rofi-unwrapped.overrideAttrs (o: with prev; {
      inherit src version;

      pname = "${pname}-unwrapped";

      nativeBuildInputs = o.nativeBuildInputs ++ [ wayland-scanner makeWrapper meson ninja ];

      postInstall = ''
        wrapProgram $out/bin/rofi \
          --run 'export XDG_DATA_DIRS="$(sed "s| |/share:|g" < <(echo $NIX_PROFILES))/share:$XDG_DATA_DIRS"'
      '';

      buildInputs = o.buildInputs ++ [ wayland wayland-protocols ];
    });

  glfw = with prev; glfw.overrideAttrs (o: {
    patches = lib.our.getPatches final.sources.minecraft-wayland.src;
    nativeBuildInputs = o.nativeBuildInputs ++ [ extra-cmake-modules ];
    buildInputs = o.buildInputs ++ [ wayland wayland-protocols libxkbcommon ];
    cmakeFlags = o.cmakeFlags ++ [ "-DGLFW_USE_WAYLAND=ON" ];
  });
}
