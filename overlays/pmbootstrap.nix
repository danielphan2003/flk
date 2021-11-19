channels: final: prev: {
  pmbootstrap = channels.latest.pmbootstrap.overrideAttrs (_: {
    inherit (final.sources.pmbootstrap) src version;
    patches = prev.lib.our.getPatches ../pkgs/tools/misc/pmbootstrap;
    repo = final.sources.pmbootstrap-test.src;
    pmb_test = "$repo/test";
  });
}
