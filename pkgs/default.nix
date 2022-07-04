{inputs}: channels: final: prev: let
  inherit
    (final)
    callPackage
    naersk
    dan-nixpkgs
    ;

  lib = final.lib // builtins;

  l = lib;

  inherit
    (inputs)
    beautysh
    firefox-nightly
    manix
    npmlock2nix
    peerix
    rnix-lsp
    ;
in {
  # inherit (beautysh.packages.${prev.system}) beautysh;

  inherit (manix.packages."${prev.system}") manix;

  inherit (rnix-lsp.packages."${prev.system}") rnix-lsp;

  adl = callPackage ./applications/video/adl {};

  anime-downloader = callPackage ./applications/video/anime-downloader {};

  argonone-fancontrold = callPackage ./tools/misc/argonone-fancontrold {};

  arkenfox-userjs = callPackage ./data/misc/arkenfox-userjs {};

  asusctl = callPackage ./os-specific/linux/asusctl {};

  caprine = callPackage ./applications/networking/instant-messengers/caprine {};

  cinny-desktop = callPackage ./applications/networking/instant-messengers/cinny/cinny-desktop.nix {
    rustPlatform = final.makeRustPlatform {
      inherit (final.fenix.stable) cargo rustc;
    };
  };

  conduit-toolbox = callPackage ./tools/servers/conduit-toolbox {};

  dan-nixpkgs = let
    dan-nixpkgs' = l.mapAttrs (k: v: v.default) inputs.dan-nixpkgs.x86_64-linux.nixpkgs;
  in
    dan-nixpkgs' // dan-nixpkgs'.all-packages;

  doggo = callPackage ./tools/networking/doggo {};

  dribbblish-dynamic-theme = callPackage ./data/misc/dribbblish-dynamic-theme {};

  eww-mpris = callPackage ./applications/misc/eww/mpris.nix {};

  # fake-background-webcam = callPackage ./applications/video/fake-background-webcam { };

  firefox-nightly-bin =
    firefox-nightly.packages.x86_64-linux.firefox-nightly-bin
    or final.firefox-wayland;

  flyingfox = callPackage ./data/misc/flyingfox {};

  formats = prev.formats // (import ../lib/pkgs-lib {inherit (final) lib pkgs;});

  frece = callPackage ./applications/misc/frece {};

  fs-diff = callPackage ./tools/file-systems/fs-diff {};

  # guiscrcpy = callPackage ./misc/guiscrcpy { };

  hyprland = channels.nixpkgs.callPackage ./applications/window-managers/hyprland {
    inherit dan-nixpkgs;
    inherit (final.waylandPkgs) wlroots;
  };

  interak = callPackage ./data/misc/interak {};

  leonflix = callPackage ./applications/video/leonflix {};

  libinih = callPackage ./development/libraries/libinih {};

  luaPackages =
    prev.luaPackages
    // {
      awestore = callPackage ./development/lua-modules/awestore {};

      bling = callPackage ./development/lua-modules/bling {};

      layout-machi = callPackage ./development/lua-modules/layout-machi {};

      lua-pam = callPackage ./development/lua-modules/lua-pam {};
    };

  microsoft-edge-beta = callPackage ./applications/networking/browsers/microsoft-edge {gconf = final.gnome2.GConf;};

  microsoft-edge-dev = final.microsoft-edge-beta.override {channel = "dev";};

  minecraft-mods = final.minecraft-mods-builder dan-nixpkgs.minecraft-mods {};

  npmlock2nix = callPackage npmlock2nix {};

  ntfs2btrfs = callPackage ./tools/file-systems/ntfs2btrfs {};

  otf-apple = callPackage ./data/fonts/otf-apple {};

  paper = callPackage ./tools/wayland/paper {};

  papermc-pkgs = final.papermc-pkgs-builder dan-nixpkgs.papermc {prefix = "papermc-";};

  papermc-utils = prev.papermc-utils.override {inherit (channels.nixpkgs) javaPackages;};

  inherit
    (final.papermc-pkgs)
    # 1.8.x - 1.11.x
    
    papermc-1_8_8
    papermc-1_9_4
    papermc-1_10_2
    papermc-1_11_2
    # 1.12.x
    
    papermc-1_12
    papermc-1_12_1
    papermc-1_12_2
    # 1.13.x
    
    papermc-1_13-pre7
    papermc-1_13
    papermc-1_13_1
    papermc-1_13_2
    # 1.14.x
    
    papermc-1_14
    papermc-1_14_1
    papermc-1_14_2
    papermc-1_14_3
    papermc-1_14_4
    # 1.15.x
    
    papermc-1_15
    papermc-1_15_1
    papermc-1_15_2
    # 1.16.x
    
    papermc-1_16_1
    papermc-1_16_2
    papermc-1_16_3
    papermc-1_16_4
    papermc-1_16_5
    # 1.17.x
    
    papermc-1_17
    papermc-1_17_1
    # 1.18.x
    
    papermc-1_18
    papermc-1_18_1
    papermc-1_18_2
    ;

  # papermc = final.papermc-1_18_2;

  playit-agent = callPackage ./tools/networking/playit-agent {};

  plymouth-themes = callPackage ./data/misc/plymouth-themes {};

  pure = callPackage ./shells/zsh/pure {};

  python3Packages = final.python3Packages-builder dan-nixpkgs.all-packages {prefix = "pythonPackages-";};

  pywalfox = callPackage ./tools/misc/pywalfox {};

  # quibble = callPackage ./applications/virtualization/quibble {
  #   mingwGccs = with prev.pkgsCross; [ mingw32.buildPackages.gcc mingwW64.buildPackages.gcc ];
  # };

  rainfox = callPackage ./data/misc/rainfox {};

  revanced-cli = callPackage ./tools/misc/revanced-cli {};

  # sciter = callPackage ./development/libraries/sciter { };

  sddm-chili = callPackage ./applications/display-managers/sddm/themes/chili {};

  spicetify-marketplace = callPackage ./data/misc/spicetify-marketplace {};

  spicetify-themes = callPackage ./data/misc/spicetify-themes {};

  spotify-spiced = callPackage ./applications/audio/spotify-spiced {};

  steamcompmgr = callPackage ./applications/window-managers/steamcompmgr {};

  supergfxctl = callPackage ./os-specific/linux/supergfxctl {};

  swayprop = callPackage ./tools/wayland/swayprop {};

  # tailscale-systray = callPackage ./tools/misc/tailscale-systray { };

  trackma = callPackage ./applications/video/trackma {};

  ttf-segue-ui = callPackage ./data/fonts/ttf-segue-ui {};

  user-icon = callPackage ./data/misc/user-icon {};

  vimPlugins = final.vimPlugins-builder dan-nixpkgs.all-packages {prefix = "vimPlugins-";};

  vscode-extensions = final.vscode-extensions-builder dan-nixpkgs.vscode-extensions {
    pkgBuilder = final.vscode-utils.pkgBuilder';
    filterSources = l.vscode-extensions.filterSources';
  };

  wgcf = callPackage ./applications/networking/wgcf {};

  whitesur-icon-theme = callPackage ./data/icons/whitesur-icon-theme {};

  widevine-cdm = callPackage ./applications/networking/browsers/widevine-cdm {};

  wii-u-gc-adapter = callPackage ./misc/drivers/wii-u-gc-adapter {};

  yubikey-guide = callPackage ./misc/yubikey-guide {};
}
