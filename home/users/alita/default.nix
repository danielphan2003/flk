{ hmUsers, self, ... }: {
  home-manager.users = { inherit (hmUsers) alita; };

  age.secrets.alita.file = "${self}/secrets/alita.age";

  users.users.alita = {
    description = "default";
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "kvm" "adbusers" "input" "podman" ];
    passwordFile = "/run/secrets/alita";
    openssh.authorizedKeys.keyFiles = [ "${self}/secrets/ssh/danie.pub" ];
  };
}
