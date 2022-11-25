{profiles, ...}: {
  imports = [profiles.system.encryption.manual];

  boot.initrd = {
    availableKernelModules = ["tpm-tis" "tpm-crb"];
    luks.devices.system.crypttabExtraOpts = ["tpm2-device=auto"];
  };
}
