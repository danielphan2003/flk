final: prev: {
  duf = prev.duf.override {
    buildGoModule = attrs: let
      overrideAttrs = {
        inherit (final.fog.duf) pname src version;
        vendorSha256 = "sha256-rgZtkY2+eGljPLWuYwgtOawMaKpnOONtDSOzzdiYIBU=";
      };
    in
      final.buildGoModule (attrs // overrideAttrs);
  };
}
