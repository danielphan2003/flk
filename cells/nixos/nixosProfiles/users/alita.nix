{
  self,
  config,
  ...
}: {
  age.secrets.alita.file = "${self}/secrets/home/users/alita.age";

  users.users.alita = {
    description = "Alita";
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd" "kvm" "adbusers" "input" "podman"];

    passwordFile = config.age.secrets.alita.path;

    openssh.authorizedKeys.keyFiles = [
      "${self}/secrets/ssh/alita.pub"
      "${self}/secrets/ssh/danie.pub"
    ];
  };
}
