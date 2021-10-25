channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

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
    nwg-panel
    nwg-wrapper
    obs-studio
    qutebrowser
    rage
    scream
    scrcpy
    starship
    stylua
    sudo
    wayland-protocols-master
    wlfreerdp
    wlrctl
    wlvncc
    ;

  inherit (channels) latest;

  lib = channels.latest.lib.extend (lfinal: lprev: with lfinal; {
    options = lprev.options // {
      literalExample = text:
        if isString text
        then literalExpression text
        else { _type = "literalExample"; inherit text; };
    };
  });

  obs-studio-plugins = channels.latest.obs-studio-plugins // {
    wlrobs = final.obs-wlrobs;
  };

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
