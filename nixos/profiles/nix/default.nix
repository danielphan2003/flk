{
  lib,
  pkgs,
  ...
}: {
  imports = [./cachix];

  nix.systemFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm" "recursive-nix"];

  nix.localRegistry = {
    # Enable quick-nix-registry
    enable = true;
    # Cache the default nix registry locally, to avoid extraneous registry updates from nix cli.
    cacheGlobalRegistry = true;
    # Set an empty global registry.
    noGlobalRegistry = false;
  };

  nix = {
    autoOptimiseStore = true;
    gc.automatic = true;
    optimise.automatic = true;
    useSandbox = true;
    allowedUsers = ["@wheel"];
    trustedUsers = ["root" "@wheel"];
    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
      builders-use-substitutes = true
      experimental-features = nix-command flakes recursive-nix
    '';
  };

  services.cron.enable = true;

  services.earlyoom.enable = true;

  services.timesyncd.enable = true;
}
