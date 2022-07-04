channels: final: prev: {
  ragenix = channels.nixpkgs.ragenix.override {
    plugins = [final.age-plugin-yubikey];
  };
}
