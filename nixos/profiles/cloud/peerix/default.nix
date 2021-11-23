{ self, config, hostConfigs, pkgs, ... }:
let
  inherit (config.networking) hostName;
  inherit (config.age.secrets.peerix) path;
  inherit (config.services.peerix) user group;
in
{
  age.secrets.peerix = {
    file = "${self}/secrets/nixos/profiles/cloud/peerix/${hostName}.age";
    owner = user;
    inherit group;
  };

  services.peerix = {
    enable = true;
    openFirewall = config.services.tailscale.enable;
    privateKeyFile = path;
    group = "nogroup";
    publicKey = hostConfigs.hosts."${hostName}".binary_cache_public_key;
  };
}
