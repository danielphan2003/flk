channels: final: prev: {
  waydroid = channels.latest.waydroid.overrideAttrs (_: {
    patches = prev.lib.our.getPatches ../pkgs/os-specific/linux/waydroid;
  });
}
