channels: final: prev:
let
  inherit (channels.latest)
    discord-canary
    element-desktop
    signal-desktop
    electron
    vscodium
  ;

  enableWayland = true;

  extraOptions = [
    "--enable-vulkan"
    "--ignore-gpu-blocklist"
    "--enable-gpu-rasterization"
    "--enable-zero-copy"
  ];

  flags = (prev.lib.optionals enableWayland [
    "--enable-features=UseOzonePlatform"
    "--ozone-platform=wayland"
    "--enable-webrtc-pipewire-capturer"
  ]) ++ extraOptions;

  flagsCommand = prev.lib.concatStringsSep " " flags;
in
{
  element-desktop = element-desktop.override { electron = final.electron; };

  discord-canary = discord-canary.overrideAttrs (_: {
    postFixup = ''
      # Create electron wrapper
      substituteInPlace $out/bin/discordcanary \
        --replace "DiscordCanary-wrapped\"" "DiscordCanary-wrapped\" ${flagsCommand}"
    '';
  });

  signal-desktop = signal-desktop.overrideAttrs (o: {
    postFixup = ''
      ${o.postFixup}
      # Create electron wrapper
      substituteInPlace $out/bin/signal-desktop-unwrapped \
        --replace "unwrapped-wrapped\"" "unwrapped-wrapped\" ${flagsCommand}"
    '';
  });

  electron = electron.overrideAttrs (o: {
    postFixup = ''
      ${o.postFixup}
      # Create electron wrapper
      substituteInPlace $out/lib/electron/electron \
        --replace "electron-wrapped\"" "electron-wrapped\" ${flagsCommand}"
    '';
  });

  vscodium = vscodium.overrideAttrs (_: {
    postInstall = ''
      sed -i "s/CLI\"/CLI\" ${flagsCommand}/" $out/bin/codium
    '';
  });
}