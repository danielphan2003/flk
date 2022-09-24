{...}: {
  # will be overridden by the bootstrap-iso `nixos-generate` format profile
  # defined by the digga "nixos-generators" devshell module
  fileSystems."/" = {device = "/dev/disk/by-label/nixos";};
}
