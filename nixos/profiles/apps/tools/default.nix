{ pkgs, lib, ... }: {
  environment.systemPackages = builtins.attrValues
    {
      inherit (pkgs)
        czkawka
        ffmpeg-full
        gnufdisk
        gparted
        libnotify
        pamixer
        parted
        pavucontrol
        pulsemixer
        playerctl
        pueue
        pywal
        trash-cli
        wgcf
        woeusb
        ydotool
        zathura
        ;
    }
  ++
  (lib.optionals
    (pkgs.system == "x86_64-linux")
    (with pkgs; [ etcher ]));
}
