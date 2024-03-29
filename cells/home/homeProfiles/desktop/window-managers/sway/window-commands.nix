{lib, ...}: let
  inherit (lib.flk.i3wm) rule floatingNoBorder;
in {
  wayland.windowManager.sway.config.window.commands = [
    (rule ''      floating {
            move position cursor
            move down 60px
          }''
    {app_id = "waybar";})
    (rule "sticky enable" {app_id = "eww";})
    (rule "floating enable, sticky enable" {title = "^(Picture-in-Picture|Picture in picture)$";})
    (rule "floating enable, resize set 1000 600" {
      app_id = "zoom";
      title = "^(?!Zoom Meeting$)";
    })
    (floatingNoBorder {class = "jetbrains-toolbox";})
    (floatingNoBorder {
      class = "jetbrains.*";
      title = "Welcome.*";
    })
    (floatingNoBorder {
      class = "jetbrains.*";
      title = "win0";
    })
    (floatingNoBorder {app_id = "ulauncher";})
    (rule "floating enable" {
      app_id = "firefox";
      title = "^About.*Firefox.*$";
    })
    (rule "floating enable" {
      app_id = "";
      title = "zoom";
    })
    (rule "floating enable, move position 700 965" {
      app_id = "firefox";
      title = ".*Sharing Indicator";
    })
    (rule "floating enable, move position 700 940, border pixel 1" {title = ".* sharing (a window|your screen)";})
    (rule "floating enable" {app_id = "onedrive_tray";})
    (rule "floating enable" {app_id = "(pavucontrol|psensor)";})
    (rule "floating enable" {class = "Pavucontrol";})
    (rule "floating enable" {class = "Tk";})
    (rule "resize set width $φ" {app_id = "Alacritty";})
    (rule "resize set width $Φ" {app_id = "org.qutebrowser.qutebrowser";})
    (rule "move left" {app_id = "org.qutebrowser.qutebrowser";})
    (rule ''title_format "%title (%app_id)"'' {shell = "xdg_shell";})
    (rule ''title_format "<span>[X] %title</span>"'' {shell = "xwayland";})
    (rule "floating enable" {
      class = "^Steam$";
      title = "^Friends$";
    })
    (rule "floating enable" {
      class = "^Steam$";
      title = "Steam - News";
    })
    (rule "floating enable" {
      class = "^Steam$";
      title = ".* - Chat";
    })
    (rule "floating enable" {
      class = "^Steam$";
      title = "^Settings$";
    })
    (rule "floating enable" {
      class = "^Steam$";
      title = ".* - event started";
    })
    (rule "floating enable" {
      class = "^Steam$";
      title = ".* CD key";
    })
    (rule "floating enable" {
      class = "^Steam$";
      title = "^Steam - Self Updater$";
    })
    (rule "floating enable" {
      class = "^Steam$";
      title = "^Screenshot Uploader$";
    })
    (rule "floating enable" {
      class = "^Steam$";
      title = "^Steam Guard - Computer Authorization Required$";
    })
    (rule "floating enable" {class = "^Steam Keyboard$";})
    (rule "floating enable" {window_role = "pop-up";})
    (rule "floating enable" {window_role = "bubble";})
    (rule "floating enable" {window_role = "dialog";})
    (rule "floating enable" {window_type = "dialog";})
    (rule "floating enable" {app_id = "floating";})
    (rule "floating enable" {class = "(?i)pinentry";})
    (rule "floating enable" {app_id = "Yad";})
    (rule "floating enable" {app_id = "yad";})
    (rule "floating enable, resize set 1276px 814px" {title = ".*kdbx - KeePass";})
    (rule "floating enable" {class = "KeePass2";})
    (rule "floating enable" {app_id = "nm-connection-editor";})
    (rule "floating enable" {class = "KeyStore Explorer";})
    (rule "floating enable" {app_id = "virt-manager";})
    (rule "floating enable" {app_id = "xfce-polkit";})
    (rule "floating enable" {instance = "origin.exe";})
    (rule "floating enable, border pixel 1, sticky enable" {
      app_id = "firefox";
      title = "Library";
    })
    (rule "floating enable" {app_id = "pavucontrol";})
    (rule "floating enable" {app_id = "blueberry.py";})
    (rule "floating enable" {title = "Manage KeeAgent.*";})
    (rule "floating enable" {title = "Page Info - .*";})
    (rule "floating enable" {class = "ConkyKeyboard";})
    (rule "floating enable" {class = "Gufw.py";})
    (rule "floating enable, resize set 1276px 814px" {app_id = "keepassxc";})
    (rule "floating enable" {app_id = "blueman-manager";})
    (rule "floating enable" {title = "^Open File$";})
    (rule "floating enable" {class = "^zoom$";})
    (rule "border pixel 0" {app_id = "avizo-service";})
    (rule "sticky toggle" {app_id = "avizo-service";})
    (rule "resize set 590 340" {window_role = "GtkFileChooserDialog";})
    (rule "move position center" {window_role = "GtkFiileChooserDialog";})
    (rule "floating enable" {app_id = "tlp-ui";})
    (rule "floating enable" {title = "mpvfloat";})
    (rule "floating enable" {title = ".*Kee - Mozilla Firefox";})
    (rule "floating enable" {app_id = "nm-openconnect-auth-dialog";})
    (rule "floating enable" {class = "davmail-DavGateway";})
    (rule "floating enable" {title = "Open Database File";})
    (rule "floating enable" {app_id = "evolution-alarm-notify";})
    (rule "floating enable" {app_id = "gnome-calculator";})
    (rule "floating enable" {title = "TeamSpeak 3";})
    (rule "floating enable" {
      app_id = "(?i)Thunderbird";
      title = ".*Reminder";
    })
    (rule "floating enable" {class = "ATLauncher";})
    (rule "floating enable" {instance = "lxappearance";})
    (rule "floating enable" {app_id = "pamac-manager";})
    (rule "floating enable, border pixel 1, sticky enable, resize set width 40 ppt height 30 ppt" {title = "File Operation Progress";})
    (rule "floating enable" {title = "nmtui";})
    (rule "floating enable" {title = "Save File";})
    (rule "floating enable" {app_id = "wdisplays";})
    (rule "floating enable, border pixel 1, sticky enable, resize set width 30 ppt height 40 ppt" {app_id = "floating_shell_portrait";})
    (rule "floating enable, border pixel 1, sticky enable" {app_id = "floating_shell";})
    (rule "floating enable" {app_id = "qt5ct";})
    (rule "floating enable" {app_id = "gnome-tweaks";})
    (rule "floating enable, move absolute position 1500px 100px, resize set 1200px 700px, move to scratchpad, mark $criteria" {title = "(?i)$criteria";})
    (rule "title_format %title゜" {title = ".*";})
    (rule "move position 1503 640, resize set 384 360" {title = "^Snapdrop$";})
    # (rule ''floating disable'' { title = "~nwg"; })
  ];
}
