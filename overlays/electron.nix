final: prev: let
  inherit
    (prev)
    # element-desktop
    
    # signal-desktop
    
    ;

  inherit
    (final)
    dan-nixpkgs
    # wlroots
    
    ;

  l = final.lib // builtins;

  # see https://github.com/NixOS/nixpkgs/issues/137688
  # chromium >= 96.0.4664.55 and electron >= 16.0.2 should fix this
  # note that proprietary packages like Spotify does not have this patch yet
  # at least Xwayland works without patching
  # see also ./waylandPkgs.nix
  enableWayland = true;
  # enableWayland = (l.compareVersions ungoogled-chromium.version "96.0.4664.45" >= 0
  #   && l.compareVersions electron_18.version "16.0.2" >= 0)
  #   || (wlroots.patchedChromium or false);

  extraOptions = [
    "--enable-accelerated-mjpeg-decode"
    "--enable-accelerated-video"
    "--enable-gpu-rasterization"
    "--enable-native-gpu-memory-buffers"
    "--enable-vulkan"
    "--enable-zero-copy"
    "--ignore-gpu-blocklist"
  ];

  waylandFlags = l.optionals enableWayland [
    "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
    "--enable-webrtc-pipewire-capturer"
    "--ozone-platform=wayland"
  ];

  defaultFlags = waylandFlags ++ extraOptions;

  flagsCommand = l.concatStringsSep " ";

  compatScript = flags:
    prev.writeShellScript "electron-compat-flags.sh" ''
      if [[ -n $WAYLAND_DISPLAY ]]
      then
        echo ${flagsCommand flags}
      else
        echo ""
      fi
    '';

  electronCompatFlags = flags: "$(${compatScript flags})";

  patchElectron = bin: {flags ? defaultFlags}: let
    wrapper = bin': let
      binName = l.last (l.splitString "/" bin');
    in ''
      mkdir -p $out/.bin-wrapped
      cp --copy-contents ${bin'} $out/.bin-wrapped/${binName}
      rm ${bin'}
      makeWrapper $out/.bin-wrapped/${binName} ${bin'} \
        --add-flags ${l.escapeShellArg (electronCompatFlags flags)}
    '';
  in
    l.concatMapStringsSep "\n" (x: wrapper x) (l.toList bin);

  patchElectronApplication = drv: bin: {flags ? defaultFlags}:
    (prev.symlinkJoin {
      inherit (drv) name;
      paths = [drv];
      buildInputs = [prev.makeWrapper];
      postBuild = patchElectron bin {inherit flags;};
    })
    .overrideAttrs (_: {
      inherit
        (drv)
        meta
        name
        version
        ;
      pname = drv.pname or drv.name;
    });

  patchBrowser = drv: {flags ? defaultFlags}:
    drv.override {commandLineArgs = electronCompatFlags flags;};
in {
  electron_12 = null;

  discord-canary = prev.discord-canary.overrideAttrs (o: {
    inherit (dan-nixpkgs.discord-canary) pname src version;
    installPhase = ''
      ${o.installPhase}
      sed -i 's/exec/unset NIXOS_OZONE_WL\nexec/g' $out/opt/DiscordCanary/DiscordCanary
    '';
  });

  electron = final.electron_18;

  electron_18 = patchElectronApplication prev.electron_18 "$out/lib/electron/electron" {};

  vscodium = patchElectronApplication prev.vscodium "$out/bin/codium" {};

  ungoogled-chromium = patchBrowser prev.ungoogled-chromium {};

  microsoft-edge-beta = patchBrowser prev.microsoft-edge-beta {};

  spotify-spiced = patchBrowser prev.spotify-spiced {
    flags = waylandFlags ++ ["--enable-devtool" "--enable-developer-mode"];
  };

  teams =
    # patchElectronApplication
    prev.teams.overrideAttrs (_: {inherit (dan-nixpkgs.teams) src version;})
    # "$out/bin/teams"
    # {}
    ;
}
