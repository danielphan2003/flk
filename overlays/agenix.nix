channels: final: prev: {
  ragenix = channels.latest.ragenix.override {
    plugins = [final.age-plugin-yubikey];
  };
}
