{ pkgs, hmUsers, self, ... }: {
  home-manager.users = { inherit (hmUsers) danie; };

  age.secrets = {
    accounts = {
      file = "${self}/secrets/accounts.age";
      owner = "danie";
      group = "users";
    };
    danie.file = "${self}/secrets/danie.age";
  };

  environment.systemPackages = with pkgs; [ danie-logo ];

  users.users.danie = {
    description = "Daniel Phan";
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "kvm" "adbusers" "input" "podman" ];
    passwordFile = "/run/secrets/danie";
    openssh.authorizedKeys.keyFiles = [ "${self}/secrets/ssh/danie.pub" ];
  };
}
