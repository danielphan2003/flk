final: prev: {
  inherit (final.waylandPkgs) xdg-desktop-portal-wlr;

  freerdp = final.waylandPkgs.wlfreerdp;

  eww = prev.eww.override { enableWayland = true; };

  waylandPkgs = prev.waylandPkgs // {

    sway-unwrapped = prev.waylandPkgs.sway-unwrapped.overrideAttrs (_: rec {
      inherit (final.sources.sway-borders) pname version src;
    });

  };

  swaylock-effects = prev.swaylock-effects.overrideAttrs (_: rec {
    inherit (final.sources.swaylock-effects) pname version src;
  });

  ydotool = prev.ydotool.overrideAttrs (_: rec {
    inherit (final.sources.ydotool) pname version src;
  });

  sway = prev.sway.override { inherit (final.waylandPkgs) sway-unwrapped; };

  glfw = with prev; glfw.overrideAttrs (o: {
    patches = lib.our.getPatches ../pkgs/development/libraries/glfw;
    nativeBuildInputs = o.nativeBuildInputs ++ [ extra-cmake-modules ];
    buildInputs = o.buildInputs ++ [ wayland wayland-protocols libxkbcommon ];
    cmakeFlags = o.cmakeFlags ++ [ "-DGLFW_USE_WAYLAND=ON" ];
  });
}
