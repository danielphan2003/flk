final: prev: {
  # pmbootstrap = prev.pmbootstrap.overrideAttrs (_: {
  #   inherit (final.fog.pmbootstrap) src version;
  #   patches = prev.lib.flk.getPatchFiles ../packages/tools/misc/pmbootstrap;
  #   repo = final.fog.pmbootstrap-test.src;
  #   pmb_test = "$repo/test";
  # });
}
