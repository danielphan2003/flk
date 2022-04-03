{
  self,
  config,
  hmUsers,
  ...
}: let
  user = "alita";
in {
  home-manager.users."${user}" = hmUsers."${user}";

  age.secrets."${user}".file = "${self}/secrets/home/users/${user}.age";

  users.users."${user}" = {
    description = "Alita";
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd" "kvm" "adbusers" "input" "podman"];
    passwordFile = config.age.secrets."${user}".path;
    openssh.authorizedKeys.keyFiles = [
      "${self}/secrets/ssh/${user}.pub"
      "${self}/secrets/ssh/danie.pub"
    ];
  };
}
