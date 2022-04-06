channels: final: prev: let
  inherit
    (final)
    lib
    sources
    wlfreerdp
    ;

  inherit
    (prev)
    glfw-wayland
    rofi-unwrapped
    swaylock-effects
    eww
    ;

  inherit (prev.lib.our) getPatches;
in {
  inherit
    (channels.latest)
    waylandPkgs
    aml
    avizo
    cage
    clipman
    drm_info
    dunst
    gebaar-libinput
    glpaper
    greetd
    grim
    gtk-layer-shell
    i3status-rust
    imv
    kanshi
    lavalauncher
    libvncserver_master
    mako
    neatvnc
    nwg-drawer
    nwg-launchers
    nwg-menu
    nwg-panel
    obs-studio
    obs-wlrobs
    oguri
    rootbar
    sirula
    slurp
    # sway-unwrapped
    
    swaybg
    swayidle
    swaylock
    waybar
    wayfire
    waypipe
    wayvnc
    wdisplays
    wev
    wf-recorder
    wl-clipboard
    wl-gammactl
    wlay
    wldash
    wlfreerdp
    wlogout
    # wlroots
    
    wlr-randr
    wlsunset
    wlvncc
    wofi
    wshowkeys
    wtype
    xdg-desktop-portal-wlr
    ;

  freerdp = wlfreerdp;

  # eww = eww.override { enableWayland = true; };

  swaylock-effects = swaylock-effects.overrideAttrs (_: {
    inherit (sources.swaylock-effects) pname version src;
  });

  rofi-unwrapped = let
    inherit (sources.rofi-wayland) pname src version;
  in
    rofi-unwrapped.overrideAttrs (o: {
      inherit src version;

      pname = "${pname}-unwrapped";

      nativeBuildInputs = o.nativeBuildInputs ++ [prev.wayland-scanner prev.makeWrapper prev.meson prev.ninja];

      postInstall = ''
        wrapProgram $out/bin/rofi \
          --run 'export XDG_DATA_DIRS="$(sed "s| |/share:|g" < <(echo $NIX_PROFILES))/share:$XDG_DATA_DIRS"'
      '';

      buildInputs = o.buildInputs ++ [prev.wayland prev.wayland-protocols prev.xcb-util-cursor];
    });

  glfw-wayland = glfw-wayland.overrideAttrs (o: {
    patches = lib.init (getPatches sources.minecraft-wayland.src);
  });
}
