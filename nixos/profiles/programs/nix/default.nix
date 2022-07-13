{
  lib,
  pkgs,
  ...
}: {
  imports = [./cachix];

  # package and option is from fup
  nix.generateRegistryFromInputs = lib.mkDefault true;

  # Enable quick-nix-registry
  nix.localRegistry = {
    enable = true;
    # Cache the default nix registry locally, to avoid extraneous registry updates from nix cli.
    cacheGlobalRegistry = true;
    # Set an empty global registry.
    noGlobalRegistry = false;
  };

  nix = {
    gc.automatic = true;
    optimise.automatic = true;
  };

  nix.settings = {
    auto-optimise-store = true;
    sandbox = true;
    allowed-users = ["@wheel"];
    trusted-users = ["root" "@wheel"];
    fallback = true;
    builders-use-substitutes = true;
    keep-outputs = true;
    keep-derivations = true;
    system-features = ["nixos-test" "benchmark" "big-parallel" "kvm" "recursive-nix"];
  };

  services.cron.enable = true;

  services.earlyoom.enable = true;

  services.timesyncd.enable = true;
}
