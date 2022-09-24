{...}: {
  users.users.nixos = {
    uid = 1000;
    description = "default";
    isNormalUser = true;
    extraGroups = ["wheel"];
  };
}
