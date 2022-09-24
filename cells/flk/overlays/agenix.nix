final: prev: {
  ragenix = prev.ragenix.override {
    plugins = [final.age-plugin-yubikey];
  };
}
