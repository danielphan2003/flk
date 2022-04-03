final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  yubikey-agent = prev.yubikey-agent.override {
    buildGoModule = args:
      final.buildGoModule (args
        // {
          inherit (final.sources.yubikey-agent) src version;
          vendorSha256 = "sha256-dqUV0+exeLbL20geWX1gqoir+nGDuYKDASC6DcJJwI8=";
        });
  };
}
