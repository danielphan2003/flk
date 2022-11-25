let
  inherit (inputs) digga nixlib nixpkgs;

  overlays =
    nixlib.lib.mapAttrs (_: import)
    (digga.lib.rakeLeaves ./overlays);
in
  overlays
  // {
    bootspec-secureboot = final: prev: {
      bootspec-secureboot = inputs.bootspec-secureboot.packages.${prev.system}.package;
    };

    __lib = final: prev: {
      __dontExport = true;
      lib = prev.lib.extend (lfinal: lprev: {
        flk = cell.library;
      });
    };

    inherit
      (inputs.devos-ext-lib.overlays)
      minecraft-mods
      papermc
      python3Packages
      vimPlugins
      vscode-extensions
      ;

    devos-ext-lib = inputs.devos-ext-lib.overlays.default;

    nixpkgs-wayland = inputs.nixpkgs-wayland.overlays.default;

    gomod2nix = inputs.gomod2nix.overlays.default;

    default = final: prev: let
      inherit
        (final)
        callPackage
        fog
        ;

      l = builtins // final.lib;
    in {
      inherit (inputs.agenix.packages."${prev.system}") ragenix;

      inherit (inputs.hyprwm-contrib.packages."${prev.system}") grimblast;

      inherit (inputs.peerix.packages."${prev.system}") peerix;

      inherit (inputs.poetry2nix.packages."${prev.system}") poetry poetry2nix;

      rnix-lsp = inputs.rnix-lsp.packages."${prev.system}".rnix-lsp.overrideAttrs (_: {doCheck = false;});

      adl = callPackage ./packages/applications/video/adl {};

      agenix = final.ragenix;

      anime-downloader = callPackage ./packages/applications/video/anime-downloader {};

      arkenfox-userjs = callPackage ./packages/data/misc/arkenfox-userjs {};

      asusctl = callPackage ./packages/os-specific/linux/asusctl {};

      caddy = callPackage ./packages/servers/caddy {};

      caprine = callPackage ./packages/applications/networking/instant-messengers/caprine {};

      cinny-desktop = callPackage ./packages/applications/networking/instant-messengers/cinny/cinny-desktop.nix {
        rustPlatform = final.makeRustPlatform {
          inherit (final.fenix.stable) cargo rustc;
        };
      };

      conduit-toolbox = callPackage ./packages/tools/servers/conduit-toolbox {};

      doggo = callPackage ./packages/tools/networking/doggo {};

      dribbblish-dynamic-theme = callPackage ./packages/data/misc/dribbblish-dynamic-theme {};

      electron-utils = callPackage ./packages/development/tools/electron/utils.nix {};

      eww-mpris = callPackage ./packages/applications/misc/eww/mpris.nix {};

      # fake-background-webcam = callPackage ./packages/applications/video/fake-background-webcam { };

      fenix = inputs.fenix.packages."${prev.system}";

      firefox-nightly-bin = let
        firefox-nightly-bin = inputs.firefox-nightly.packages.x86_64-linux.firefox-nightly-bin or null;
      in
        if firefox-nightly-bin != null
        then let
          firefox-nightly-bin-unwrapped = firefox-nightly-bin.overrideAttrs (_: {
            inherit (final) gtk3;
            binaryName = "firefox";
          });
        in
          final.wrapFirefox firefox-nightly-bin-unwrapped {}
        else final.firefox;

      firefox-sidebar = callPackage ./packages/data/misc/firefox-sidebar {};

      flyingfox = callPackage ./packages/data/misc/flyingfox {};

      fog = let
        finalFog = l.mapAttrs (k: v: v.default) inputs.fog."${nixpkgs.system}".fog;
      in
        l.flk.mergeOn finalFog finalFog.all-packages;

      formats = l.flk.mergeOn prev.formats (import ./library/pkgs-lib {inherit (final) lib pkgs;});

      frece = callPackage ./packages/applications/misc/frece {};

      fs-diff = callPackage ./packages/tools/file-systems/fs-diff {};

      gomod2nix = inputs.gomod2nix.packages."${prev.system}".default;

      # guiscrcpy = callPackage ./packages/misc/guiscrcpy { };

      hyprland = callPackage ./packages/applications/window-managers/hyprland/wrapper.nix {};

      hyprland-tools = import ./packages/tools/wayland/hyprland-tools {inherit callPackage;};

      hyprland-unwrapped = inputs.hyprland.packages."${prev.system}".hyprland;

      import-gsettings = callPackage ./packages/tools/misc/import-gsettings {};

      interak = callPackage ./packages/data/misc/interak {};

      leonflix = callPackage ./packages/applications/video/leonflix {};

      luaPackages =
        l.flk.mergeOn
        prev.luaPackages
        {
          awestore = callPackage ./packages/development/lua-modules/awestore {};

          bling = callPackage ./packages/development/lua-modules/bling {};

          layout-machi = callPackage ./packages/development/lua-modules/layout-machi {};

          lua-pam = callPackage ./packages/development/lua-modules/lua-pam {};
        };

      minecraft-mods = callPackage (l.minecraft-mods.builders.default {}) {srcs = inputs.fog.minecraft-mods;};

      microsoft-edge = callPackage (import ./packages/applications/networking/browsers/microsoft-edge).stable {};

      microsoft-edge-beta = callPackage (import ./packages/applications/networking/browsers/microsoft-edge).beta {};

      microsoft-edge-dev = callPackage (import ./packages/applications/networking/browsers/microsoft-edge).dev {};

      npmlock2nix = callPackage inputs.npmlock2nix {};

      ntfs2btrfs = callPackage ./packages/tools/file-systems/ntfs2btrfs {};

      openasar = callPackage ./packages/applications/networking/instant-messengers/discord/openasar.nix {};

      otf-apple = callPackage ./packages/data/fonts/otf-apple {};

      paper = callPackage ./packages/tools/wayland/paper {};

      papermc-pkgs = l.papermc.builders.default {
        srcs = l.devos-ext.filterSrc "papermc-" fog.papermc;
      };

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

      piv-agent = callPackage ./packages/tools/security/piv-agent {};

      playit-agent = callPackage ./packages/tools/networking/playit-agent {};

      plymouth-themes = callPackage ./packages/data/misc/plymouth-themes {};

      pure = callPackage ./packages/shells/zsh/pure {};

      python3Packages =
        l.flk.mergeOn
        prev.python3Packages
        (l.python3Packages.builders.default {
          srcs = l.devos-ext.filterSrc "pythonPackages-" fog.all-packages;
        });

      pywalfox = callPackage ./packages/tools/misc/pywalfox {};

      # quibble = callPackage ./packages/applications/virtualization/quibble {
      #   mingwGccs = with prev.pkgsCross; [ mingw32.buildPackages.gcc mingwW64.buildPackages.gcc ];
      # };

      rainfox = callPackage ./packages/data/misc/rainfox {};

      revanced-cli = callPackage ./packages/tools/misc/revanced-cli {};

      rust-analyzer-nightly = final.fenix.rust-analyzer-vscode-extension;

      # sciter = callPackage ./packages/development/libraries/sciter { };

      sddm-chili = callPackage ./packages/applications/display-managers/sddm/themes/chili {};

      spicetify-marketplace = callPackage ./packages/data/misc/spicetify-marketplace {};

      spicetify-themes = callPackage ./packages/data/misc/spicetify-themes {};

      spotify-spiced = callPackage ./packages/applications/audio/spotify-spiced {};

      steamcompmgr = callPackage ./packages/applications/window-managers/steamcompmgr {};

      supergfxctl = callPackage ./packages/os-specific/linux/supergfxctl {};

      sway-physlock = callPackage ./packages/tools/wayland/sway-physlock {
        swaylock = final.swaylock-effects;
        sudo = final.doas;
      };

      swayprop = callPackage ./packages/tools/wayland/swayprop {};

      swhkd = callPackage ./packages/applications/window-managers/swhkd {};

      # tailscale-systray = callPackage ./packages/tools/misc/tailscale-systray { };

      trackma = callPackage ./packages/applications/video/trackma {};

      ttf-segue-ui = callPackage ./packages/data/fonts/ttf-segue-ui {};

      user-icon = callPackage ./packages/data/misc/user-icon {};

      vimPlugins =
        l.flk.mergeOn
        prev.vimPlugins
        (l.vimUtils.builders.default {
          srcs = l.devos-ext.filterSrc "vimPlugins-" fog.all-packages;
        });

      vscode-extensions =
        l.flk.mergeOn
        prev.vscode-extensions
        (l.vscode-utils.builders.default {
          srcs = fog.vscode-extensions;
        })
        {
          matklad.rust-analyzer-nightly = final.fenix.rust-analyzer-vscode-extension;
        };

      wgcf = callPackage ./packages/applications/networking/wgcf {};

      whitesur-icon-theme = callPackage ./packages/data/icons/whitesur-icon-theme {};

      widevine-cdm = callPackage ./packages/applications/networking/browsers/widevine-cdm {};

      wii-u-gc-adapter = callPackage ./packages/misc/drivers/wii-u-gc-adapter {};

      yubikey-guide = callPackage ./packages/misc/yubikey-guide {};
    };
  }
