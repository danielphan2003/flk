final: prev: let
  inherit
    (final)
    lib
    fog
    ;
in {
  # inherit
  #   (channels.nixpkgs)
  #   waylandPkgs
  #   aml
  #   avizo
  #   cage
  #   clipman
  #   drm_info
  #   dunst
  #   gebaar-libinput
  #   glpaper
  #   greetd
  #   grim
  #   gtk-layer-shell
  #   i3status-rust
  #   imv
  #   kanshi
  #   lavalauncher
  #   libvncserver_master
  #   mako
  #   neatvnc
  #   nwg-drawer
  #   nwg-launchers
  #   nwg-menu
  #   nwg-panel
  #   obs-studio
  #   # obs-wlrobs

  #   oguri
  #   rootbar
  #   sirula
  #   slurp
  #   # sway-unwrapped

  #   swaybg
  #   swayidle
  #   swaylock
  #   wayfire
  #   waypipe
  #   wayvnc
  #   wdisplays
  #   wev
  #   wf-recorder
  #   wl-clipboard
  #   wl-gammactl
  #   wlay
  #   wldash
  #   wlfreerdp
  #   wlogout
  #   # wlroots

  #   wlr-randr
  #   wlsunset
  #   wlvncc
  #   wofi
  #   wshowkeys
  #   wtype
  #   xdg-desktop-portal-wlr
  #   ;

  freerdp = final.wlfreerdp;

  # eww = prev.eww.override { enableWayland = true; };

  swaylock-effects = prev.swaylock-effects.overrideAttrs (_: {
    inherit (fog.swaylock-effects) pname version src;
  });

  rofi-unwrapped = let
    inherit (fog.rofi-wayland) pname src version;
  in
    prev.rofi-unwrapped.overrideAttrs (o: {
      inherit src version;

      pname = "${pname}-unwrapped";

      nativeBuildInputs = o.nativeBuildInputs ++ [prev.wayland-scanner prev.makeWrapper prev.meson prev.ninja];

      postInstall = ''
        wrapProgram $out/bin/rofi \
          --run 'export XDG_DATA_DIRS="$(sed "s| |/share:|g" < <(echo $NIX_PROFILES))/share:$XDG_DATA_DIRS"'
      '';

      buildInputs = o.buildInputs ++ [prev.wayland prev.wayland-protocols prev.xcb-util-cursor];
    });

  glfw-wayland = prev.glfw-wayland.overrideAttrs (o: {
    patches = lib.init (lib.flk.getPatchFiles fog.minecraft-wayland.src);
  });

  waybar = final.waylandPkgs.waybar.overrideAttrs (o: {
    mesonFlags = o.mesonFlags ++ ["-Dexperimental=true"];
  });
}
