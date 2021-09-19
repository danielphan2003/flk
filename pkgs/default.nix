{ inputs }:

channels: final: prev:
let
  inherit (final) sources;

  mkVimPlugin = prefix: plugin:
    final.vimUtils.buildVimPluginFrom2Nix {
      inherit (plugin) version src;
      pname = final.lib.removePrefix prefix plugin.pname;
    };

  mkVscodeExtension = extension:
    final.vscode-utils.mkVscodeExtension extension { };

  mkMinecraftMod = prefix: mod:
    final.callPackage ./games/minecraft/mod.nix { inherit mod prefix; };

  mkPythonPackage = prefix: package:
    final.callPackage ./top-level/python-packages.nix { inherit package prefix; };

  newPkgsSet = pkgSet:
    let
      prefix = "${pkgSet}-";

      pkgSetBuilder = {
        "vimPlugins" = mkVimPlugin prefix;
        "vscode-extensions" = mkVscodeExtension;
        "minecraft" = mkMinecraftMod prefix;
        "pythonPackages" = mkPythonPackage prefix;
      }.${pkgSet};


      pkgsInSources = final.lib.mapAttrs' (name: value: final.lib.nameValuePair (final.lib.removePrefix prefix name) (value)) (final.lib.filterAttrs (n: v: final.lib.hasPrefix prefix n) sources);
    in
    final.lib.mapAttrs (n: v: pkgSetBuilder v) pkgsInSources;

in
{

  vimPlugins = prev.vimPlugins // (newPkgsSet "vimPlugins");

  vscode-extensions = prev.vscode-extensions // (newPkgsSet "vscode-extensions");

  python3Packages = prev.python3Packages // (newPkgsSet "pythonPackages");

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

  quibble = final.callPackage ./applications/virtualization/quibble {
    mingwGccs = with prev.pkgsCross; [ mingw32.buildPackages.gcc mingwW64.buildPackages.gcc ];
  };

  wgcf = final.callPackage ./applications/networking/wgcf { };

  tuinitymc = final.callPackage ./games/tuinity { };

  lightcord = final.callPackage ./applications/networking/instant-messengers/lightcord {
    # inherit (channels.latest) glibc;
  };

  doggo = final.callPackage ./tools/networking/doggo { };

  anime-downloader = final.callPackage ./applications/video/anime-downloader { };

  trackma = final.callPackage ./applications/video/trackma { };

  frece = final.callPackage ./applications/misc/frece { inherit (channels.latest) rustPlatform; };

  adl = final.callPackage ./applications/video/adl { };

} // (with inputs; (dcompass.overlay final prev).dcompass // {

  firefox-nightly-bin =
    if prev.system == "x86_64-linux"
    then firefox-nightly.packages.${prev.system}.firefox-nightly-bin
    else prev.firefox;

  inherit (rnix-lsp.packages.${prev.system}) rnix-lsp;

  npmlock2nix =
    let
      patchedNpmlock2nix = with prev; applyPatches {
        name = "npmlock2nix";
        src = npmlock2nix;
        patches = [
          (fetchpatch {
            url = "https://patch-diff.githubusercontent.com/raw/nix-community/npmlock2nix/pull/94.patch";
            sha256 = "sha256-FbKccDfxYLJD39Xg21xX32p1afrgFZpnYS92HLBEctc=";
          })
        ];
      };
    in
    import patchedNpmlock2nix { pkgs = prev; };

})
