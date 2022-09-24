final: prev: {
  yubikey-agent = prev.yubikey-agent.override {
    buildGoModule = attrs: let
      overrideAttrs = {
        inherit (final.fog.yubikey-agent) src version;
        vendorSha256 = "sha256-dqUV0+exeLbL20geWX1gqoir+nGDuYKDASC6DcJJwI8=";
      };
    in
      final.buildGoModule (attrs // overrideAttrs);
  };
}
