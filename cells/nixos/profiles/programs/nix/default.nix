{
  self,
  lib,
  pkgs,
  ...
}: {
  imports = lib.flk.getNixFiles ./.;

  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      cachix
      manix
      nix-du
      nix-tree
      ;
  };

  nix = {
    # package and option is from fup
    generateRegistryFromInputs = lib.mkDefault true;

    # Enable quick-nix-registry
    localRegistry = {
      enable = lib.mkDefault true;
      # Cache the default nix registry locally, to avoid extraneous registry updates from nix cli.
      cacheGlobalRegistry = true;
      # Set an empty global registry.
      noGlobalRegistry = false;
    };

    gc.automatic = true;
    optimise.automatic = true;

    settings = {
      auto-optimise-store = true;
      sandbox = true;
      allowed-users = ["@wheel"];
      trusted-users = ["root" "@wheel"];
      fallback = true;
      builders-use-substitutes = true;
      keep-outputs = true;
      keep-derivations = true;
      system-features = lib.mkOptionDefault ["recursive-nix"];
    };
  };

  environment.shellAliases = {
    n = "nix";
    np = "n profile";
    ni = "np install";
    nr = "np remove";
    ns = "n search --no-update-lock-file";
    nf = "n flake";
    nepl = "n repl '<nixpkgs>'";
    srch = "ns nixos";
    orch = "ns override";
    mn = ''
      manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="manix '{}'" | xargs manix
    '';

    # fix nixos-option
    nixos-option = "nixos-option -I nixpkgs=${self}/lib/compat";
  };
}
