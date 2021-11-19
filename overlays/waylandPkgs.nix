channels: final: prev: {
  freerdp = final.wlfreerdp;

  eww = prev.eww.override { enableWayland = true; };

  sway-unwrapped = final.waylandPkgs.sway-unwrapped.overrideAttrs (_: {
    inherit (final.sources.sway-borders) version src;
  });

  waylandPkgs = with channels.latest; waylandPkgs // {
    wlroots = waylandPkgs.wlroots.override { inherit (final) xwayland; };
  };

  xwayland = channels.latest.xwayland.override { wayland-protocols = final.wayland-protocols-master; };

  swaylock-effects = prev.swaylock-effects.overrideAttrs (_: {
    inherit (final.sources.swaylock-effects) pname version src;
  });

  rofi-unwrapped =
    let
      inherit (final.sources.rofi-wayland) pname src version;
    in
    prev.rofi-unwrapped.overrideAttrs (o: with prev; {
      inherit src version;

      pname = "${pname}-unwrapped";

      nativeBuildInputs = o.nativeBuildInputs ++ [ wayland-scanner makeWrapper meson ninja ];

      postInstall = ''
        wrapProgram $out/bin/rofi \
          --run 'export XDG_DATA_DIRS="$(sed "s| |/share:|g" < <(echo $NIX_PROFILES))/share:$XDG_DATA_DIRS"'
      '';

      buildInputs = o.buildInputs ++ [ wayland wayland-protocols xcb-util-cursor ];
    });

  glfw = with prev; glfw.overrideAttrs (o: {
    patches = lib.our.getPatches final.sources.minecraft-wayland.src;
    nativeBuildInputs = o.nativeBuildInputs ++ [ extra-cmake-modules ];
    buildInputs = o.buildInputs ++ [ wayland wayland-protocols libxkbcommon ];
    cmakeFlags = o.cmakeFlags ++ [ "-DGLFW_USE_WAYLAND=ON" ];
  });
}
