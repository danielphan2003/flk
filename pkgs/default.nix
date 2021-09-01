{ inputs }:

channels: final: prev:
let
  sources = (import ./_sources/generated.nix) { inherit (final) fetchurl fetchgit; };

  mkVimPlugin = prefix: plugin:
    final.vimUtils.buildVimPluginFrom2Nix {
      inherit (plugin) version src;
      pname = final.lib.removePrefix prefix plugin.pname;
    };

  mkVscodeExtension = extension:
    final.vscode-utils.mkVscodeExtension extension { };

  mkMinecraftMod = prefix: mod:
    final.callPackage ./games/minecraft/mod.nix { inherit mod prefix; };

  newPkgsSet = pkgSet:
    let
      prefix = "${pkgSet}-";

      pkgSetchannel = {
        "vimPlugins" = mkVimPlugin prefix;
        "vscode-extensions" = mkVscodeExtension;
        "minecraft" = mkMinecraftMod prefix;
      }.${pkgSet};


      pkgsInSources = final.lib.mapAttrs' (name: value: final.lib.nameValuePair (final.lib.removePrefix prefix name) (value)) (final.lib.filterAttrs (n: v: final.lib.hasPrefix prefix n) sources);
    in
    final.lib.mapAttrs (n: v: pkgSetchannel v) pkgsInSources;

in
{

  inherit sources;

  vimPlugins = prev.vimPlugins // (newPkgsSet "vimPlugins");

  vscode-extensions = prev.vscode-extensions // (newPkgsSet "vscode-extensions");

  minecraft-mods = newPkgsSet "minecraft";

  alsa-lib = prev.alsaLib;

  sddm-chili = final.callPackage ./applications/display-managers/sddm/themes/chili { };

  pure = final.callPackage ./shells/zsh/pure { };

  wii-u-gc-adapter = final.callPackage ./misc/drivers/wii-u-gc-adapter { };

  libinih = final.callPackage ./development/libraries/libinih { };

  steamcompmgr = final.callPackage ./applications/window-managers/steamcompmgr { };

  fs-diff = final.callPackage ./tools/file-systems/fs-diff { };

  whitesur-icon-theme = final.callPackage ./data/icons/whitesur-icon-theme { };

  otf-apple = final.callPackage ./data/fonts/otf-apple { };

  ttf-segue-ui = final.callPackage ./data/fonts/ttf-segue-ui { };

  # ventoy = final.callPackage ./tools/file-systems/ventoy { };

  leonflix = final.callPackage ./applications/video/leonflix { };

  widevine-cdm = final.callPackage ./applications/networking/browsers/widevine-cdm { };

  flyingfox = final.callPackage ./data/misc/flyingfox { };

  interak = final.callPackage ./data/misc/interak { };

  rainfox = final.callPackage ./data/misc/rainfox { };

  spicetify-themes = final.callPackage ./data/misc/spicetify-themes { };

  dribbblish-dynamic-theme = final.callPackage ./data/misc/dribbblish-dynamic-theme { };

  microsoft-edge-beta = final.callPackage ./applications/networking/browsers/microsoft-edge { gconf = prev.gnome2.GConf; };

  microsoft-edge-dev = final.microsoft-edge-beta.override { channel = "dev"; };

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

  paper = final.callPackage ./tools/wayland/paper { inherit (channels.latest) rustPlatform; };

  eww = channels.latest.callPackage ./applications/misc/eww {
    inherit (final) sources;
    makeRustPlatform = (channels.latest.makeRustPlatform {
      inherit (final.fenix.latest) cargo rustc;
    });
  };

  eww-mpris = final.callPackage ./applications/misc/eww/mpris.nix { };

  caddy = final.callPackage ./servers/caddy { };

  ntfs2btrfs = final.callPackage ./tools/file-systems/ntfs2btrfs { };

  quibble = final.callPackage ./applications/virtualization/quibble { };

  wgcf = final.callPackage ./applications/networking/wgcf { };

} // (with inputs; {

  firefox-nightly-bin =
    if prev.system == "x86_64-linux"
    then firefox-nightly.packages.${prev.system}.firefox-nightly-bin
    else prev.firefox;

  inherit (rnix-lsp.packages.${prev.system}) rnix-lsp;

})
