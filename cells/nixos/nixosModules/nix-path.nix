{
  inputs,
  self,
  pkgs,
  ...
}: {
  nix.nixPath = [
    "nixpkgs=${pkgs.path}"
    # nixos config compat
    "nixos-config=${self}/lib/compat/nixos"
    "home-manager=${inputs.home}"
  ];
}
