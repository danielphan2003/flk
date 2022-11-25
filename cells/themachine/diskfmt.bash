DRIVE="$1"

while [ "$DRIVE" = "" ]; do
  DRIVE="$(
    lsblk -n --output PATH | fzf \
      --header="+ Choose the drive to be formatted:" \
      --preview="lsblk --output PATH,TYPE,SIZE,FSTYPE {}" \
      --preview-window=down \
      --layout=reverse \
      --cycle
  )"

  echo "+ You choosed: $DRIVE"

  echo -n "> Are you sure? [y/N] "
  read -n 1 REPLY
  if [ ! $(expr "$REPLY" : '^[Yy]$') ]; then
    echo "None chosen"
    exit 1
  fi
done

# useful if you are migrating from the original machine that already have this mapper
mapper_system_name=""
echo -n "+ Set system mapper (default to system): "
read mapper_system_name
mapper_system_name="${mapper_system_name:-"system"}"
mapper_system="/dev/mapper/$mapper_system_name"

sgdisk --clear \
  --new=1:0:+550MiB --typecode=1:ef00 --change-name=1:EFI \
  --new=2:0:+64GiB --typecode=2:8200 --change-name=2:cryptswap \
  --new=3:0:0 --typecode=3:8300 --change-name=3:cryptsystem \
  "$DRIVE"

mkfs.fat -F32 -n EFI /dev/disk/by-partlabel/EFI

cryptsetup open --type plain --key-file /dev/urandom /dev/disk/by-partlabel/cryptswap swap

mkswap -L swap /dev/mapper/swap

swapon -L swap

cryptsetup luksFormat --align-payload=8192 -s 256 -c aes-xts-plain64 /dev/disk/by-partlabel/cryptsystem

cryptsetup open /dev/disk/by-partlabel/cryptsystem "$mapper_system_name"

mkfs.btrfs --label system "$mapper_system"

o="defaults,x-mount.mkdir"
o_btrfs="$o,compress=zstd,ssd,noatime"

mount -t btrfs LABEL=system /mnt

# We first create the subvolumes outlined above:
for subvolume in root home nix persist log; do
  btrfs subvolume create "/mnt/$subvolume"
done

# We then take an empty *readonly* snapshot of the root subvolume,
# which we'll eventually rollback to on every boot.
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

umount -R /mnt

mount -o "subvol=root,$o_btrfs" "$mapper_system" /mnt

mount -o "subvol=log,$o_btrfs" "$mapper_system" /mnt/var/log

for subvolume in home nix persist; do
  mount -o "subvol=$subvolume,$o_btrfs" "$mapper_system" "/mnt/$subvolume"
done

# don't forget this!
mkdir /mnt/boot

mount LABEL=EFI /mnt/boot

nixos-generate-config --root /mnt
