{...}: {
  users.users.alita = {
    description = "Alita";
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd" "kvm" "adbusers" "input" "podman"];
  };
}
