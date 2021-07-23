channels: final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };

  sddm-chili =
    final.callPackage ./applications/display-managers/sddm/themes/chili { };

  pure = final.callPackage ./shells/zsh/pure { };

  wii-u-gc-adapter = final.callPackage ./misc/drivers/wii-u-gc-adapter { };

  libinih = final.callPackage ./development/libraries/libinih { };

  steamcompmgr =
    final.callPackage ./applications/window-managers/steamcompmgr { };

  fs-diff = final.callPackage ./tools/file-systems/fs-diff { };

  whitesur-icon-theme = final.callPackage ./data/icons/whitesur-icon-theme { };

  otf-apple = final.callPackage ./data/fonts/otf-apple { };

  # ventoy = final.callPackage ./tools/file-systems/ventoy { };

  leonflix = final.callPackage ./applications/video/leonflix { };

  widevine-cdm = final.callPackage ./applications/networking/browsers/widevine-cdm { };

  flyingfox = final.callPackage ./data/misc/flyingfox { };

  interak = final.callPackage ./data/misc/interak { };

  rainfox = final.callPackage ./data/misc/rainfox { };

  spicetify-themes = final.callPackage ./data/misc/spicetify-themes { };

  dribbblish-dynamic-theme = final.callPackage ./data/misc/dribbblish-dynamic-theme { };

  microsoft-edge-beta =
    final.callPackage ./applications/networking/browsers/microsoft-edge { };

  microsoft-edge-dev =
    final.callPackage ./applications/networking/browsers/microsoft-edge { channel = "dev"; };

  arkenfox-userjs = final.callPackage ./data/misc/arkenfox-userjs { };

  spotify-spicetified = final.callPackage ./applications/audio/spotify-spicetified { };

  pywalfox = final.callPackage ./tools/misc/pywalfox { };

  caprine = final.callPackage ./applications/networking/instant-messengers/caprine { };

  luaPackages = prev.luaPackages // {
    bling = final.callPackage ./development/lua-modules/bling { };

    layout-machi = final.callPackage ./development/lua-modules/layout-machi { };

    lua-pam = final.callPackage ./development/lua-modules/lua-pam { };

    awestore = final.callPackage ./development/lua-modules/awestore { };
  };

  avizo = final.callPackage ./applications/misc/avizo { };

  plymouth-themes = final.callPackage ./data/misc/plymouth-themes { };

  # paper = final.callPackage ./tools/wayland/paper { inherit (channels.latest) rustPlatform; };
}
