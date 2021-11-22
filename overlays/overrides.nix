channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  inherit (channels) latest;

  inherit (channels.latest)
    agenix
    android-tools
    anup
    buildGo117Module
    buildGoApplication
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
    nixUnstable
    nixpkgs-fmt
    nwg-menu
    nwg-wrapper
    poetry
    poetry2nix
    peerix
    qutebrowser
    rage
    realvnc-vnc-viewer
    scream
    scrcpy
    sources
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
    wlroots
    wlr-randr
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

  nixos-rebuild = channels.latest.nixos-rebuild.override {
    nix = final.nixUnstable;
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
