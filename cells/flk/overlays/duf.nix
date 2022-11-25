final: prev: {
  duf = prev.duf.override {
    buildGoModule = attrs: let
      overrideAttrs = {
        inherit (final.fog.duf) pname src version;
        vendorSha256 = "sha256-0DfMzS+1mlFCeI3qmj3GxTRiH+UrzTotdjYtGXJrs5Q=";
      };
    in
      final.buildGoModule (attrs // overrideAttrs);
  };
}
