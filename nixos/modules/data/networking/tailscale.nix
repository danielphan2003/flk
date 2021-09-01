{ config, lib, ... }:

with lib;
let
  cfg = config.uwu.tailscale;
in
{
  options = {
    uwu.tailscale = {
      nameserver = mkOption {
        type = types.str;
        default = "";
        description = ''
          Nameserver for various uses.
        '';
      };
    };
  };

  config = { };
}
