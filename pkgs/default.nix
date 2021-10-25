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
    peerix
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
  adl = callPackage ./applications/video/adl { };

  alsa-lib = prev.alsaLib;

  anime-downloader = callPackage ./applications/video/anime-downloader { };

  arkenfox-userjs = callPackage ./data/misc/arkenfox-userjs { };

  avizo = callPackage ./applications/misc/avizo { };

  caddy = callPackage ./servers/caddy { };

  caprine = callPackage ./applications/networking/instant-messengers/caprine { };

  doggo = callPackage ./tools/networking/doggo { };

  dribbblish-dynamic-theme = callPackage ./data/misc/dribbblish-dynamic-theme { };

  eww = with channels.latest; callPackage ./applications/misc/eww {
    inherit (final) sources;
    makeRustPlatform = makeRustPlatform {
      inherit (fenix.latest) cargo rustc;
    };
  };

  eww-mpris = callPackage ./applications/misc/eww/mpris.nix { };

  fake-background-webcam = callPackage ./applications/video/fake-background-webcam { };

  flyingfox = callPackage ./data/misc/flyingfox { };

  formats = prev.formats // (import ../lib/pkgs-lib { inherit (prev) lib pkgs; });

  frece = callPackage ./applications/misc/frece { inherit (channels.latest) rustPlatform; };

  fs-diff = callPackage ./tools/file-systems/fs-diff { };

  interak = callPackage ./data/misc/interak { };

  leonflix = callPackage ./applications/video/leonflix { };

  libinih = callPackage ./development/libraries/libinih { };

  lightcord = callPackage ./applications/networking/instant-messengers/lightcord {
    # inherit (channels.latest) glibc;
  };

  luaPackages = prev.luaPackages // {
    awestore = callPackage ./development/lua-modules/awestore { };

    bling = callPackage ./development/lua-modules/bling { };

    layout-machi = callPackage ./development/lua-modules/layout-machi { };

    lua-pam = callPackage ./development/lua-modules/lua-pam { };
  };

  microsoft-edge-beta = callPackage ./applications/networking/browsers/microsoft-edge { gconf = final.gnome2.GConf; };

  microsoft-edge-dev = final.microsoft-edge-beta.override { channel = "dev"; };

  minecraft-mods = newPkgsSet "minecraft";

  ntfs2btrfs = callPackage ./tools/file-systems/ntfs2btrfs { };

  otf-apple = callPackage ./data/fonts/otf-apple { };

  paper = callPackage ./tools/wayland/paper { inherit (channels.latest) rustPlatform; };

  peerix = channels.latest.callPackage peerix { };

  plymouth-themes = callPackage ./data/misc/plymouth-themes { };

  pure = callPackage ./shells/zsh/pure { };

  python3Packages = prev.python3Packages // (newPkgsSet "pythonPackages");

  pywalfox = callPackage ./tools/misc/pywalfox { };

  quibble = callPackage ./applications/virtualization/quibble {
    mingwGccs = with prev.pkgsCross; [ mingw32.buildPackages.gcc mingwW64.buildPackages.gcc ];
  };

  rainfox = callPackage ./data/misc/rainfox { };

  sddm-chili = callPackage ./applications/display-managers/sddm/themes/chili { };

  spicetify-themes = callPackage ./data/misc/spicetify-themes { };

  spotify-spicetified = callPackage ./applications/audio/spotify-spicetified { };

  steamcompmgr = callPackage ./applications/window-managers/steamcompmgr { };

  swayprop = callPackage ./tools/wayland/swayprop { };

  trackma = callPackage ./applications/video/trackma { };

  ttf-segue-ui = callPackage ./data/fonts/ttf-segue-ui { };

  tuinitymc = callPackage ./games/tuinity { };

  user-icon = callPackage ./data/misc/user-icon { };

  ventoy = callPackage ./tools/file-systems/ventoy { };

  vimPlugins = prev.vimPlugins // (newPkgsSet "vimPlugins");

  vscode-extensions = channels.latest.vscode-extensions // (newPkgsSet "vscode-extensions");

  wgcf = callPackage ./applications/networking/wgcf { };

  whitesur-icon-theme = callPackage ./data/icons/whitesur-icon-theme { };

  widevine-cdm = callPackage ./applications/networking/browsers/widevine-cdm { };

  wii-u-gc-adapter = callPackage ./misc/drivers/wii-u-gc-adapter { };

  xorg = prev.xorg // (recurseIntoAttrs (lib.callPackageWith __splicedPackages ./servers/x11/xorg { }));
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
