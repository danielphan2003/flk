final: prev: {
  # pmbootstrap = prev.pmbootstrap.overrideAttrs (_: {
  #   inherit (final.dan-nixpkgs.pmbootstrap) src version;
  #   patches = prev.lib.our.getPatches ../pkgs/tools/misc/pmbootstrap;
  #   repo = final.dan-nixpkgs.pmbootstrap-test.src;
  #   pmb_test = "$repo/test";
  # });
}
