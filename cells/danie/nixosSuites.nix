let
  inherit (inputs) cells;
in {
  danie = {
    self,
    config,
    ...
  }: {
    imports = with cells.nixos.nixosProfiles; [
      # desktop.login-managers.gdm
      desktop.window-managers.hyprland
    ];

    home-manager.users.danie.imports = [cells.danie.homeSuites.danie];

    age.secrets.danie.file = "${self}/secrets/home/users/danie.age";

    users.users.danie = {
      description = "Daniel Phan";
      isNormalUser = true;
      extraGroups = ["wheel" "libvirtd" "kvm" "adbusers" "input" "podman"];

      passwordFile = config.age.secrets.danie.path;

      # trust yourself. who wouldn't trust themselves?
      openssh.authorizedKeys.keyFiles = ["${self}/secrets/ssh/danie.pub"];
    };

    # pwease trust me root-senpai~~
    users.users.root.openssh.authorizedKeys.keyFiles = ["${self}/secrets/ssh/danie.pub"];

    services.xserver.displayManager.autoLogin.user = "danie";

    # stylix.targets.vscode.enable = false;
  };
}
