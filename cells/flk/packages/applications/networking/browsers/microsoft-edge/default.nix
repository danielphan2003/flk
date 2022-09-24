{
  beta = import ./browser.nix {channel = "beta";};
  dev = import ./browser.nix {channel = "dev";};
  stable = import ./browser.nix {channel = "stable";};
}
