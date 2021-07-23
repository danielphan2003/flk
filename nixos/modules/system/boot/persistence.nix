{ config, lib, ... }:

with lib;
let
  cfg = config.boot.persistence;
  reminder = ''
    Do not use this module or profile misc.persistence
    unless your configuration follows mine exactly.
  '';
in
{
  options = {
    boot.persistence = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable persistence for stateless machines.
        '';
      };
      path = mkOption {
        type = types.str;
        default = "";
        description = ''
          Which path to use as persist.
        '';
      };
    };

  };

  config = mkIf cfg.enable {
    security.sudo.extraConfig = ''
      # rollback results in sudo lectures after each reboot
      Defaults lecture = never
    '';

    boot.initrd.postDeviceCommands = lib.mkBefore ''
      mkdir -p /mnt

      # We first mount the btrfs root to /mnt
      # so we can manipulate btrfs subvolumes.
      mount -o subvol=/ /dev/mapper/system /mnt

      # While we're tempted to just delete /root and create
      # a new snapshot from /root-blank, /root is already
      # populated at this point with a number of subvolumes,
      # which makes `btrfs subvolume delete` fail.
      # So, we remove them first.
      #
      # /root contains subvolumes:
      # - /root/var/lib/portables
      # - /root/var/lib/machines
      #
      # I suspect these are related to systemd-nspawn, but
      # since I don't use it I'm not 100% sure.
      # Anyhow, deleting these subvolumes hasn't resulted
      # in any issues so far, except for fairly
      # benign-looking errors from systemd-tmpfiles.
      btrfs subvolume list -o /mnt/root |
      cut -f9 -d' ' |
      while read subvolume; do
        echo "deleting /$subvolume subvolume..."
        btrfs subvolume delete "/mnt/$subvolume"
      done &&
      echo "deleting /root subvolume..." &&
      btrfs subvolume delete /mnt/root

      echo "restoring blank /root subvolume..."
      btrfs subvolume snapshot /mnt/root-blank /mnt/root

      # Once we're done rolling back to a blank snapshot,
      # we can unmount /mnt and continue on the boot process.
      umount /mnt
    '';
  };

}
