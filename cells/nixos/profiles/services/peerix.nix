{
  self,
  config,
  pkgs,
  ...
}: let
  inherit (config.age.secrets.peerix) path;
  inherit (config.services.peerix) user group;
in {
  age.secrets.peerix = {
    file = "${self}/secrets/nixos/profiles/cloud/peerix/${config.networking.hostName}.age";
    owner = user;
    inherit group;
  };

  services.peerix = {
    enable = true;
    package = pkgs.peerix;
    openFirewall = config.services.tailscale.enable;
    privateKeyFile = path;
    group = "nogroup";
    publicKey = config.flk.currentHost.publicKeys.binaryCache;
  };
}
