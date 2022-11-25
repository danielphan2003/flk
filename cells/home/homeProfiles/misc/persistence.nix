{config, ...}: {
  systemd.user.tmpfiles.rules = [
    "L /home/danie/.gnupg - - - - /mnt/danie/.gnupg"
    "L /home/danie/.ssh - - - - /mnt/danie/.ssh"
    "L /home/danie/.nixops - - - - /mnt/danie/.nixops"
    "L /home/danie/.cache/spotify - - - - /mnt/danie/.cache/spotify"
    "L /home/danie/.local/share/keyrings - - - - /mnt/danie/.local/share/keyrings"
    "L /home/danie/.local/share/direnv - - - - /mnt/danie/.local/share/direnv"
    "L /home/danie/.local/share/libvirt - - - - /mnt/danie/.local/share/libvirt"
    "L /home/danie/av - - - - /mnt/danie/av"
    "L /home/danie/dl - - - - /mnt/danie/dl"
    "L /home/danie/docs - - - - /mnt/danie/docs"
    "L /home/danie/games - - - - /mnt/danie/games"
    "L /home/danie/mus - - - - /mnt/danie/mus"
    "L /home/danie/ongoing - - - - /mnt/danie/ongoing"
    "L /home/danie/pics - - - - /mnt/danie/pics"
  ];
}
