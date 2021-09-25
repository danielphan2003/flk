channels: final: prev: {
  wayland-protocols-master = channels.latest.wayland-protocols.overrideAttrs (_: {
    inherit (prev.wayland-protocols-master) src version;
  });

  wlroots = with prev; (wlroots.override { wayland-protocols = final.wayland-protocols-master; }).overrideAttrs (_: {
    patches = [
      (fetchpatch {
        name = "wlroots-eglstreams.patch";
        url = "https://github.com/danvd/wlroots-eglstreams/commit/4dda5742f216657b4397860e4c457c7e9767ce5c.patch";
        sha256 = "sha256-YhYPeYfPkT9j9y5GKuxVL5nwXQmuvnCFZ9qz0rS1X40=";
      })
    ];
  });

  freerdp = prev.wlfreerdp;

  eww = prev.eww.override { enableWayland = true; };

  sway-unwrapped =
    (prev.sway-unwrapped.override {
      inherit (final) wlroots;
      wayland-protocols = final.wayland-protocols-master;
    }).overrideAttrs (_: {
      inherit (final.sources.sway-borders) version src;
    });

  swaylock-effects = prev.swaylock-effects.overrideAttrs (_: {
    inherit (final.sources.swaylock-effects) pname version src;
  });

  ydotool = prev.ydotool.overrideAttrs (_: {
    inherit (final.sources.ydotool) pname version src;
  });

  rofi-unwrapped = with prev; rofi-unwrapped.overrideAttrs (o: {
    inherit (final.sources.rofi-wayland) src version;

    nativeBuildInputs = o.nativeBuildInputs ++ [ wayland-scanner makeWrapper meson ninja ];

    postInstall = ''
      wrapProgram $out/bin/rofi \
        --run 'export XDG_DATA_DIRS="$(sed "s| |/share:|g" < <(echo $NIX_PROFILES))/share:$XDG_DATA_DIRS"'
    '';

    buildInputs = [
      wayland
      wayland-protocols
      libxkbcommon
      pango
      cairo
      git
      bison
      flex
      librsvg
      check
      libstartup_notification
      xorg.libxcb
      xorg.xcbutil
      xorg.xcbutilwm
      xcb-util-cursor
      which
    ];
    pname = "${final.sources.rofi-wayland.pname}-unwrapped";
  });

  # xwayland = with prev; xwayland.overrideAttrs (o:
  #   let
  #     xorgproto = xorg.xorgproto.overrideAttrs (_: {
  #       inherit (final.sources.xorgproto) src version;
  #       mesonFlags = [ "-Dversion=2.3.99.2" ];
  #     });
  #   in
  #   {
  #     inherit (final.sources.xwayland) pname src version;
  #     buildInputs = o.buildInputs ++ [ xorgproto ];
  #   });

  glfw = with prev; glfw.overrideAttrs (o: {
    patches = lib.our.getPatches final.sources.minecraft-wayland.src;
    nativeBuildInputs = o.nativeBuildInputs ++ [ extra-cmake-modules ];
    buildInputs = o.buildInputs ++ [ wayland wayland-protocols libxkbcommon ];
    cmakeFlags = o.cmakeFlags ++ [ "-DGLFW_USE_WAYLAND=ON" ];
  });
}
