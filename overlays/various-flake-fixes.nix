channels: final: prev: {
  # Since: https://github.com/NixOS/nixpkgs/pull/126137
  nix-direnv =
    if builtins.hasAttr "enableFlakes" channels.latest.nix-direnv.override.__functionArgs
    then
      channels.latest.nix-direnv.override
        {
          enableFlakes = true;
        }
    else prev.nix-direnv;
}
