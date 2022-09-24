{
  inputs,
  cell,
}:
let
  l = nixlib // builtins;
  inherit (inputs) cells nixlib;
in {
  default = {channelName ? "nixos", ...}@args: let
    otherArguments = l.removeAttrs args ["target" "channelName" "__functor"];
  in
    inputs.${channelName}.lib.nixosSystem otherArguments;
}
