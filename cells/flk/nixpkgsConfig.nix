{
  inherit (inputs.nixpkgs) system;
  config = {
    allowUnfree = true;
  };
}
