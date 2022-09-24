{
  channel,
  inputs,
  self,
  ...
}: {
  nix.nixPath = [
    "nixpkgs=${channel.input}"
    # nixos config compat
    "nixos-config=${self}/lib/compat/nixos"
    "home-manager=${inputs.home}"
  ];
}
