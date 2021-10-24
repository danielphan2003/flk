{ inputs }:

channels: final: prev:
let
  inherit (builtins)
    attrNames
    elem
    hasAttr
    ;

  inherit (prev)
    __splicedPackages
    lib
    recurseIntoAttrs
    sources
    vimUtils
    vscode-utils
    ;

  inherit (final) callPackage;

  inherit (lib)
    filterAttrs
    hasPrefix
    mapAttrs
    mapAttrs'
    nameValuePair
    removePrefix
    ;

  inherit (inputs)
    beautysh
    firefox-nightly
    npmlock2nix
    rnix-lsp
    ;

  system = prev.system or "x86_64-linux";

  matchSystem = input: input.packages ? ${system};

  mkVimPlugin = prefix: plugin:
    vimUtils.buildVimPluginFrom2Nix {
      inherit (plugin) version src;
      pname = removePrefix prefix plugin.pname;
    };

  mkVscodeExtension = extension:
    vscode-utils.mkVscodeExtension extension { };

  mkMinecraftMod = prefix: mod:
    callPackage ./games/minecraft/mod.nix { inherit mod prefix; };

  mkPythonPackage = prefix: package:
    callPackage ./top-level/python-packages.nix { inherit package prefix; };

  newPkgsSet = pkgSet:
    let
      prefix = "${pkgSet}-";

      pkgSetBuilder = {
        "vimPlugins" = mkVimPlugin prefix;
        "vscode-extensions" = mkVscodeExtension;
        "minecraft" = mkMinecraftMod prefix;
        "pythonPackages" = mkPythonPackage prefix;
      }.${pkgSet};


      pkgsInSources = mapAttrs'
        (name: value:
          nameValuePair
            (removePrefix prefix name)
            (value))
        (filterAttrs
          (n: v: hasPrefix prefix n)
          sources);
    in
    mapAttrs (n: v: pkgSetBuilder v) pkgsInSources;

in
{
  formats = prev.formats // (import ../lib/pkgs-lib { inherit (prev) lib pkgs; });

  vimPlugins = prev.vimPlugins // (newPkgsSet "vimPlugins");

  vscode-extensions = prev.vscode-extensions // (newPkgsSet "vscode-extensions");

  python3Packages = prev.python3Packages // (newPkgsSet "pythonPackages");

  minecraft-mods = newPkgsSet "minecraft";

  alsa-lib = prev.alsaLib;

  sddm-chili = callPackage ./applications/display-managers/sddm/themes/chili { };

  pure = callPackage ./shells/zsh/pure { };

  wii-u-gc-adapter = callPackage ./misc/drivers/wii-u-gc-adapter { };

  libinih = callPackage ./development/libraries/libinih { };

  steamcompmgr = callPackage ./applications/window-managers/steamcompmgr { };

  fs-diff = callPackage ./tools/file-systems/fs-diff { };

  whitesur-icon-theme = callPackage ./data/icons/whitesur-icon-theme { };

  otf-apple = callPackage ./data/fonts/otf-apple { };

  ttf-segue-ui = callPackage ./data/fonts/ttf-segue-ui { };

  # ventoy = callPackage ./tools/file-systems/ventoy { };

  leonflix = callPackage ./applications/video/leonflix { };

  widevine-cdm = callPackage ./applications/networking/browsers/widevine-cdm { };

  flyingfox = callPackage ./data/misc/flyingfox { };

  interak = callPackage ./data/misc/interak { };

  rainfox = callPackage ./data/misc/rainfox { };

  spicetify-themes = callPackage ./data/misc/spicetify-themes { };

  dribbblish-dynamic-theme = callPackage ./data/misc/dribbblish-dynamic-theme { };

  microsoft-edge-beta = callPackage ./applications/networking/browsers/microsoft-edge { gconf = final.gnome2.GConf; };

  microsoft-edge-dev = final.microsoft-edge-beta.override { channel = "dev"; };

  arkenfox-userjs = callPackage ./data/misc/arkenfox-userjs { };

  spotify-spicetified = callPackage ./applications/audio/spotify-spicetified { };

  pywalfox = callPackage ./tools/misc/pywalfox { };

  caprine = callPackage ./applications/networking/instant-messengers/caprine { };

  luaPackages = prev.luaPackages // {
    bling = callPackage ./development/lua-modules/bling { };

    layout-machi = callPackage ./development/lua-modules/layout-machi { };

    lua-pam = callPackage ./development/lua-modules/lua-pam { };

    awestore = callPackage ./development/lua-modules/awestore { };
  };

  avizo = callPackage ./applications/misc/avizo { };

  plymouth-themes = callPackage ./data/misc/plymouth-themes { };

  paper = callPackage ./tools/wayland/paper { inherit (channels.latest) rustPlatform; };

  eww = with channels.latest; callPackage ./applications/misc/eww {
    inherit (final) sources;
    makeRustPlatform = makeRustPlatform {
      inherit (final.fenix.latest) cargo rustc;
    };
  };

  eww-mpris = callPackage ./applications/misc/eww/mpris.nix { };

  caddy = callPackage ./servers/caddy { };

  ntfs2btrfs = callPackage ./tools/file-systems/ntfs2btrfs { };

  quibble = callPackage ./applications/virtualization/quibble {
    mingwGccs = with prev.pkgsCross; [ mingw32.buildPackages.gcc mingwW64.buildPackages.gcc ];
  };

  wgcf = callPackage ./applications/networking/wgcf { };

  tuinitymc = callPackage ./games/tuinity { };

  lightcord = callPackage ./applications/networking/instant-messengers/lightcord {
    # inherit (channels.latest) glibc;
  };

  doggo = callPackage ./tools/networking/doggo { };

  anime-downloader = callPackage ./applications/video/anime-downloader { };

  trackma = callPackage ./applications/video/trackma { };

  frece = callPackage ./applications/misc/frece { inherit (channels.latest) rustPlatform; };

  adl = callPackage ./applications/video/adl { };

  xorg = prev.xorg // (recurseIntoAttrs (lib.callPackageWith __splicedPackages ./servers/x11/xorg { }));

  fake-background-webcam = callPackage ./applications/video/fake-background-webcam { };

  user-icon = callPackage ./data/misc/user-icon { };
}

//

(if matchSystem beautysh
then beautysh.packages.${system}
else { })

//

{

  firefox-nightly-bin =
    if matchSystem firefox-nightly
    then firefox-nightly.packages.${system}.firefox-nightly-bin
    else final.firefox;

}

//

(if matchSystem rnix-lsp
then rnix-lsp.packages.${system}
else { })

//

{

  npmlock2nix =
    let
      patchedNpmlock2nix = with final; applyPatches {
        name = "npmlock2nix";
        src = npmlock2nix;
        patches = [
          (fetchpatch {
            name = "npmlock2nix-Git+https.patch";
            url = "https://patch-diff.githubusercontent.com/raw/nix-community/npmlock2nix/pull/94.patch";
            sha256 = "sha256-OCYKf9OJiuV9z39j2JWN1pvw9hVQZZsT85f1iuevTzE=";
          })
        ];
      };
    in
    import patchedNpmlock2nix { pkgs = final; };

}
