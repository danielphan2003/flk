final: prev: {
  sddm-chili =
    prev.callPackage ./applications/display-managers/sddm/themes/chili { };

  pure = prev.callPackage ./shells/zsh/pure { };

  wii-u-gc-adapter = prev.callPackage ./misc/drivers/wii-u-gc-adapter { };

  libinih = prev.callPackage ./development/libraries/libinih { };

  steamcompmgr =
    prev.callPackage ./applications/window-managers/steamcompmgr { };

  fs-diff = prev.callPackage ./tools/file-systems/fs-diff { };

  whitesur-icon-theme = prev.callPackage ./data/icons/whitesur-icon-theme { };

  otf-apple = prev.callPackage ./data/fonts/otf-apple { };

  ventoy = prev.callPackage ./tools/file-systems/ventoy { };

  leonflix = prev.callPackage ./applications/video/leonflix { };

  widevine-cdm = prev.callPackage ./applications/networking/browsers/widevine { };

  flyingfox = prev.callPackage ./data/misc/flyingfox { };

  interak = prev.callPackage ./data/misc/interak { };

  rainfox = prev.callPackage ./data/misc/rainfox { };

  spicetify-themes = prev.callPackage ./data/misc/spicetify-themes { };

  dribbblish-dynamic-theme = prev.callPackage ./data/misc/dribbblish-dynamic-theme { };

  microsoft-edge-beta = prev.callPackage ./applications/networking/browsers/microsoft-edge {
    channel = "beta";
    version = "91.0.864.37";
    hash = "sha256-G/nNPmy21u15F6JANcV08q7PwbQ1RKzrmlbCxRtNuSI=";
  };

  microsoft-edge-dev = prev.callPackage ./applications/networking/browsers/microsoft-edge {
    channel = "dev";
    version = "92.0.891.1";
    hash = "sha256-wHdkqH68VDSqI9oa3v9VzDHbyz262cYBs+CU7DymRZQ=";
  };

  dwall-improved = prev.callPackage ./tools/misc/dwall-improved { };

  user-js = prev.callPackage ./tools/misc/user-js { };

  spotify-spicetified = prev.callPackage ./applications/audio/spotify-spicetified { };

  pywalfox = prev.callPackage ./tools/misc/pywalfox { };

  caprine = prev.callPackage ./applications/networking/instant-messengers/caprine { };

  # waycorner = prev.callPackage ./tools/wayland/waycorner { };
}
