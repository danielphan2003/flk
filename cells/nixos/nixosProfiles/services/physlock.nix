{lib, ...}: {
  services.physlock = {
    enable = true;
    allowAnyUser = lib.mkDefault true;
  };
}
