channels: final: prev: {
  waydroid = channels.latest.waydroid.overrideAttrs (_: {
    inherit (final.sources.waydroid) src version;
    patches = prev.lib.our.getPatches ../pkgs/os-specific/linux/waydroid;
  });
}
