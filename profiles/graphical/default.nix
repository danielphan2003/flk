{ pkgs, lib, ... }:
let
  inherit (builtins) attrValues readFile;
  theme = "Materia-dark";
  themePkgs = pkgs.materia-theme;
  font = "SF Pro Display 11";
  cursor = "Bibata_Ice";
  cursorPkgs = pkgs.bibata-cursors;
  icon = "Papirus";
  iconPkgs = pkgs.papirus-icon-theme;
in
{
  imports = [
    ./gtk
    ./im
    ./qutebrowser
    ./spotify
    ./wayland
    ./wine
  ];

  hardware.opengl = {
    setLdLibraryPath = true;
    enable = true;
    extraPackages = [
      pkgs.libGL_driver
    ];
  };

  hardware.pulseaudio.enable = lib.mkForce false;

  security.rtkit.enable = true;

  systemd.services.rtkit-daemon.serviceConfig.ExecStart = [
    "${pkgs.rtkit}/libexec/rtkit-daemon --our-realtime-priority=95 --max-realtime-priority=90"
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
    media-session.enable = true;
  };

  environment = {
    pathsToLink = [ "/libexec" ];
    systemPackages = attrValues {
      # gnome and cinnamon
      inherit (pkgs.gnome) file-roller gvfs nautilus networkmanagerapplet;
      inherit (pkgs.cinnamon) nemo;

      # qt5
      inherit (pkgs.libsForQt5) qtstyleplugins;
      inherit (pkgs.qt5) qtgraphicaleffects;

      inherit (pkgs)
        # important
        feh
        ffmpeg-full
        freerdp
        gnome-themes-extra
        gtk-engine-murrine
        gtk_engines
        parted
        libnotify
        pavucontrol
        pulsemixer
        pamixer
        playerctl
        protonvpn-cli
        pywal
        rofi
        sddm-chili
        virtualgl
        xclip
        xidlehook
        xsel

        # nice touch
        etcher
        gparted
        microsoft-edge-beta
        maim
        scrcpy
        trash-cli
        youtube-dl

        # graphical utils
        czkawka
        gimp
        imagemagick

        # extras
        calibre
        fanficfare
        droidcam
        dzen2
        imlib2
        librsvg
        leonflix
        woeusb
        zathura

        # stuffs I wish I could delete
        zoom-us
        ;
    };
  };

  services.dbus.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;
  services.teamviewer.enable = true;
  services.xbanish.enable = true;

  services.xserver = {
    enable = true;
    updateDbusEnvironment = true;
    displayManager = {
      sddm = {
        enable = true;
        theme = "chili";
        autoNumlock = true;
        settings = {
          Theme = {
            CursorTheme = "${cursor}";
          };
        };
      };
    };
  };

  services.cron.systemCronJobs = with pkgs; [
    "*/20 * * * *      danie      $HOME/.local/bin/wal-set" 
  ];

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = attrValues {
      inherit (pkgs.ibus-engines)
        # bamboo
        uniemoji
      ;
    };
  };

  programs.dconf = {
    enable = true;
    packages = [ pkgs.ibus ];
  };

  programs.gnupg.agent.pinentryFlavor = "gnome3";
}
