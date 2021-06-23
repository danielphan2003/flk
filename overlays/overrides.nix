channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  inherit (channels.latest)
    cachix
    czkawka
    dmenu
    manix
    nixpkgs-fmt
    qutebrowser
    rage
    starship
    sudo
    teamviewer
    vscodium
  ;

}
