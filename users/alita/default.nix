{ self, ... }: {
  home-manager.users.alita = { suites, ... }: {
    imports = suites.alita;
    programs.git = {
      userEmail = "alita@pik2.duckdns.org";
      userName = "Alita";
    };
  };

  age.secrets.alita.file = "${self}/secrets/alita.age";

  users.users.alita = {
    uid = 1000;
    description = "default";
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "kvm" "adbusers" "input" "podman" ];
    passwordFile = "/run/secrets/alita";
    openssh.authorizedKeys.keyFiles = [ "${self}/secrets/ssh/danie.pub" ];
  };
}
