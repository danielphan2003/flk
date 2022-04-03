{
  writeShellScriptBin,
  lib,
  btrfs-progs,
  coreutils,
  gnused,
  util-linux,
}:
writeShellScriptBin "fs-diff" ''
  PATH="$PATH:${lib.makeBinPath [btrfs-progs coreutils gnused util-linux]}"

  set -euo pipefail

  mkdir -p /mnt-btrfs
  [[ $(findmnt -M /mnt-btrfs) ]] || mount -t btrfs -o subvol=/ /dev/mapper/system /mnt-btrfs

  OLD_TRANSID=$(btrfs subvolume find-new /mnt-btrfs/root-blank 9999999)
  OLD_TRANSID=''${OLD_TRANSID#transid marker was }

  btrfs subvolume find-new "/mnt-btrfs/root" "$OLD_TRANSID" |
  sed '$d' |
  cut -f17- -d' ' |
  sort |
  uniq |
  while read path; do
    path="/$path"
    if [ -L "$path" ]; then
      : # The path is a symbolic link, so is probably handled by NixOS already
    elif [ -d "$path" ]; then
      : # The path is a directory, ignore
    else
      echo "$path"
    fi
  done
''
