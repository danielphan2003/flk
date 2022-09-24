{
  lib,
  writeShellScript,
  symlinkJoin,
  makeWrapper,
  electron,
  electron_18,
  flagsOverride ? {},
}: let
  l = builtins // lib;

  flags = let
    extras = [
      "--enable-accelerated-mjpeg-decode"
      "--enable-accelerated-video"
      "--enable-gpu-rasterization"
      "--enable-native-gpu-memory-buffers"
      "--enable-vulkan"
      "--enable-zero-copy"
      "--ignore-gpu-blocklist"
    ];

    wayland = [
      "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
      "--enable-webrtc-pipewire-capturer"
      "--ozone-platform=wayland"
    ];
  in
    {
      inherit extras wayland;
      default = [];
    }
    // flagsOverride;

  wrapper = let
    script = {
      extraFlags ? flags.default,
      waylandFlags ? flags.wayland,
    }:
      writeShellScript "electron-flags-wrapper-script.sh" ''
        echo -n " ${l.concatStringsSep " " extraFlags} "

        if [[ $NIXOS_OZONE_WL ]] && [[ -n $WAYLAND_DISPLAY ]]; then
          echo -n "${l.concatStringsSep " " waylandFlags}"
        fi
      '';

    makeEvalStr = flags: "$(${script flags})";

    wrapPathWithFlags = flags: path: let
      baseName = l.baseNameOf path;
      evalStr = makeEvalStr flags;
    in ''
      mkdir -p $out/.bin-wrapped
      cp --copy-contents ${path} $out/.bin-wrapped/${baseName}
      rm ${path}

      makeWrapper $out/.bin-wrapped/${baseName} ${path} \
        --add-flags ${l.escapeShellArg evalStr}
    '';

    wrapPhase = drv: {
      extraFlags ? flags.default,
      waylandFlags ? flags.wayland,
      paths ? [],
    }: let
      optionalMainProgram =
        if paths == []
        then
          if drv ? meta && drv.meta ? mainProgram
          then ["$out/bin/${drv.meta.mainProgram}"]
          else ["$out/bin/${drv.pname}"]
        else [];

      pathToWrapper = wrapPathWithFlags {inherit extraFlags waylandFlags;};
    in
      l.concatMapStringsSep "\n" pathToWrapper
      (paths ++ optionalMainProgram);
  in {
    inherit script makeEvalStr wrapPathWithFlags wrapPhase;
  };

  wrapElectron = drv: {
    extraFlags ? flags.default,
    waylandFlags ? flags.wayland,
    paths ? [],
  } @ args: let
    patchedDrv = symlinkJoin {
      inherit (drv) name;
      paths = [drv];
      buildInputs = [makeWrapper];
      postBuild = wrapper.wrapPhase drv args;
    };
  in
    patchedDrv.overrideAttrs (_: {
      inherit
        (drv)
        name
        version
        passthru
        meta
        ;
      pname = drv.pname or drv.name;
    });

  wrapBrowser = drv: {
    extraFlags ? flags.default,
    waylandFlags ? flags.wayland,
  } @ args:
    drv.override {commandLineArgs = wrapper.makeEvalStr args;};

  packages = let
    electron = wrapElectron electron_18 {
      paths = ["$out/lib/electron/electron"];
    };
  in {
    inherit electron;

    electron_12 = throw "[overlays/electron.nix]: Why the fuck would you use electron 12?";

    electron_18 = electron;
  };
in {
  inherit
    flags
    wrapper
    wrapElectron
    wrapBrowser
    packages
    ;
}
