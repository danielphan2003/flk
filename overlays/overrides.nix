channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  inherit (channels) latest;

  inherit (channels.latest)
    agenix
    android-tools
    anup
    cachix
    czkawka
    dcompass
    deploy-rs
    dmenu
    fabric-installer
    gomod2nix
    gst
    hakuneko
    linuxKernel
    lxc
    nixpkgs-fmt
    nwg-menu
    nwg-wrapper
    peerix
    qutebrowser
    rage
    scream
    scrcpy
    starship
    stylua
    sudo
    wlrctl
    ;

  inherit (final.waylandPkgs)
    aml
    cage
    clipman
    drm_info
    dunst
    gebaar-libinput
    glpaper
    grim
    gtk-layer-shell
    i3status-rust
    imv
    kanshi
    lavalauncher
    libvncserver_master
    mako
    neatvnc
    nwg-launchers
    nwg-panel
    obs-studio
    obs-wlrobs
    oguri
    rootbar
    sirula
    slurp
    swaybg
    swayidle
    swaylock
    waybar
    wayfire
    wayland-protocols-master
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
    wlr-randr
    wlroots
    wlroots-eglstreams
    wlsunset
    wlvncc
    wofi
    wshowkeys
    wtype
    xdg-desktop-portal-wlr
    ;

  obs-studio-plugins = channels.latest.obs-studio-plugins // {
    wlrobs = final.obs-wlrobs;
  };

  lib = channels.latest.lib.extend (lfinal: lprev: with lfinal; {
    options = lprev.options // {
      literalExample = text:
        if isString text
        then literalExpression text
        else { _type = "literalExample"; inherit text; };
    };
  });

  androidenv.androidPkgs_9_0.platform-tools = final.android-tools;

  haskellPackages = prev.haskellPackages.override
    (old: {
      overrides = prev.lib.composeExtensions (old.overrides or (_: _: { })) (hfinal: hprev:
        let version = prev.lib.replaceChars [ "." ] [ "" ] prev.ghc.version;
        in
        {
          # same for haskell packages, matching ghc versions
          inherit (channels.latest.haskell.packages."ghc${version}")
            haskell-language-server;
        });
    });

}
