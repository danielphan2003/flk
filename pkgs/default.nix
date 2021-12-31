{ inputs }:

channels: final: prev:
let
  inherit (final)
    callPackage
    lib
    naersk
    sources
    ;

  inherit (final)
    minecraft-mods
    minecraft-mods-builder
    minecraft-utils

    papermc-pkgs
    papermc-pkgs-builder
    papermc-utils

    python3Packages
    python3Packages-builder
    python3Packages-utils

    vimPlugins
    vimPlugins-builder
    vimUtils

    vscode-extensions
    vscode-extensions-builder
    vscode-utils
    ;

  inherit (inputs)
    beautysh
    firefox-nightly
    manix
    npmlock2nix
    peerix
    rnix-lsp
    ;
in
{
  # inherit (beautysh.packages.${prev.system}) beautysh;

  inherit (manix.packages."${prev.system}") manix;

  inherit (rnix-lsp.packages."${prev.system}") rnix-lsp;

  adl = callPackage ./applications/video/adl { };

  anime-downloader = callPackage ./applications/video/anime-downloader { };

  arkenfox-userjs = callPackage ./data/misc/arkenfox-userjs { };

  avizo = callPackage ./applications/misc/avizo { };

  caddy = callPackage ./servers/caddy { };

  caprine = callPackage ./applications/networking/instant-messengers/caprine { };

  doggo = callPackage ./tools/networking/doggo { };

  dribbblish-dynamic-theme = callPackage ./data/misc/dribbblish-dynamic-theme { };

  eww = callPackage ./applications/misc/eww {
    naersk = naersk.override { inherit (final.fenix.latest) cargo rustc; };
  };

  eww-mpris = callPackage ./applications/misc/eww/mpris.nix { };

  # fake-background-webcam = callPackage ./applications/video/fake-background-webcam { };

  firefox-nightly-bin =
    # firefox-nightly.packages."${prev.system}".firefox-nightly-bin or
    final.firefox-wayland;

  flyingfox = callPackage ./data/misc/flyingfox { };

  formats = prev.formats // (import ../lib/pkgs-lib { inherit (prev) lib pkgs; });

  frece = callPackage ./applications/misc/frece { };

  fs-diff = callPackage ./tools/file-systems/fs-diff { };

  # guiscrcpy = callPackage ./misc/guiscrcpy { };

  interak = callPackage ./data/misc/interak { };

  leonflix = callPackage ./applications/video/leonflix { };

  libinih = callPackage ./development/libraries/libinih { };

  # lightcord = callPackage ./applications/networking/instant-messengers/lightcord {
  #   # inherit (prev) glibc;
  # };

  luaPackages = prev.luaPackages // {
    awestore = callPackage ./development/lua-modules/awestore { };

    bling = callPackage ./development/lua-modules/bling { };

    layout-machi = callPackage ./development/lua-modules/layout-machi { };

    lua-pam = callPackage ./development/lua-modules/lua-pam { };
  };

  microsoft-edge-beta = callPackage ./applications/networking/browsers/microsoft-edge { gconf = final.gnome2.GConf; };

  microsoft-edge-dev = final.microsoft-edge-beta.override { channel = "dev"; };

  minecraft-mods = minecraft-mods-builder sources.minecraft-mods { };

  npmlock2nix = callPackage npmlock2nix { };

  ntfs2btrfs = callPackage ./tools/file-systems/ntfs2btrfs { };

  otf-apple = callPackage ./data/fonts/otf-apple { };

  paper = callPackage ./tools/wayland/paper { };

  papermc-pkgs = papermc-pkgs-builder sources.papermc { prefix = "papermc-"; };

  inherit (papermc-pkgs)
    # 1.8.x - 1.11.x
    papermc-1_8_8 papermc-1_9_4 papermc-1_10_2 papermc-1_11_2

    # 1.12.x
    papermc-1_12 papermc-1_12_1 papermc-1_12_2

    # 1.13.x
    papermc-1_13-pre7 papermc-1_13 papermc-1_13_1 papermc-1_13_2

    # 1.14.x
    papermc-1_14 papermc-1_14_1 papermc-1_14_2 papermc-1_14_3 papermc-1_14_4

    # 1.15.x
    papermc-1_15 papermc-1_15_1 papermc-1_15_2

    # 1.16.x
    papermc-1_16_1 papermc-1_16_2 papermc-1_16_3 papermc-1_16_4 papermc-1_16_5

    # 1.17.x
    papermc-1_17 papermc-1_17_1

    # 1.18.x
    papermc-1_18 papermc-1_18_1
    ;

  # papermc = final.papermc-1_18_1;

  plymouth-themes = callPackage ./data/misc/plymouth-themes { };

  pure = callPackage ./shells/zsh/pure { };

  python3Packages = python3Packages-builder sources { prefix = "pythonPackages-"; };

  pywalfox = callPackage ./tools/misc/pywalfox { };

  # quibble = callPackage ./applications/virtualization/quibble {
  #   mingwGccs = with prev.pkgsCross; [ mingw32.buildPackages.gcc mingwW64.buildPackages.gcc ];
  # };

  rainfox = callPackage ./data/misc/rainfox { };

  # rustdesk = callPackage ./applications/networking/remote/rustdesk { };

  # sciter = callPackage ./development/libraries/sciter { };

  sddm-chili = callPackage ./applications/display-managers/sddm/themes/chili { };

  spicetify-themes = callPackage ./data/misc/spicetify-themes { };

  spotify-spicetified = callPackage ./applications/audio/spotify-spicetified { };

  steamcompmgr = callPackage ./applications/window-managers/steamcompmgr { };

  swayprop = callPackage ./tools/wayland/swayprop { };

  # tailscale-systray = callPackage ./tools/misc/tailscale-systray { };

  trackma = callPackage ./applications/video/trackma { };

  ttf-segue-ui = callPackage ./data/fonts/ttf-segue-ui { };

  user-icon = callPackage ./data/misc/user-icon { };

  vimPlugins = vimPlugins-builder sources { prefix = "vimPlugins-"; };

  vscode-extensions = vscode-extensions-builder sources.vscode-extensions {
    pkgBuilder = vscode-utils.pkgBuilder';
    filterSources = lib.vscode-extensions.filterSources';
  };

  wgcf = callPackage ./applications/networking/wgcf { };

  whitesur-icon-theme = callPackage ./data/icons/whitesur-icon-theme { };

  widevine-cdm = callPackage ./applications/networking/browsers/widevine-cdm { };

  wii-u-gc-adapter = callPackage ./misc/drivers/wii-u-gc-adapter { };
}
