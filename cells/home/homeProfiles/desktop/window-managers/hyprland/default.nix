{
  lib,
  nixosConfig,
  pkgs,
  ...
}: {
  # home.packages = [pkgs.grimblast];

  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    xwayland.enable = true;
    # package = pkgs.hyprland;
    extraConfig = let
      vars = rec {
        term = "${pkgs.alacritty}/bin/alacritty";
        menu = "${pkgs.nwg-drawer}/bin/nwg-drawer -ovl";
        wallpaper = "$(${pkgs.psmisc}/bin/pkill hyprpaper || true) && ${pkgs.hyprpaper}/bin/hyprpaper";
        fm = "${pkgs.gnome.nautilus}/bin/nautilus";
        # lock = "${pkgs.sway-physlock}/bin/sway-physlock";
        logout = "${pkgs.nwg-launchers}/bin/nwgbar -o 0.2";
        btop-interactive = "${term} --class btop-interactive --title btop-interactive --command btop";
        # screenshot = args: "${pkgs.grimblast}/bin/grimblast --notify ${lib.concatStringsSep " " args}";
        ibus-startup = "${pkgs.ibus}/bin/ibus restart || ${pkgs.ibus}/bin/ibus-daemon -drx";
        polkit-gnome = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      };
    in
      with lib.flk.hyprland;
        lib.flk.concatNewline [
          (monitor "" "preferred" "auto" 1)

          (exec vars.wallpaper)

          (workspace "HDMI-A-1" 1)

          (exec vars.ibus-startup)

          (exec-once vars.polkit-gnome)

          (section "general" {
            main_mod = "SUPER";

            gaps_in = 5;
            gaps_out = 20;
            border_size = 2;
            "col.active_border" = "0x66" + nixosConfig.lib.stylix.colors.base0A; # "0x66ee1111";
            "col.inactive_border" = "0x66" + nixosConfig.lib.stylix.colors.base03; # "0x66333333";

            apply_sens_to_raw = 0; # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
          })

          (section "decoration" {
            rounding = 10;
            blur = 1;
            blur_size = 3; # minimum 1
            blur_passes = 1; # minimum 1, more passes = more resource intensive.
            # Your blur "amount" is blur_size * blur_passes, but high blur_size (over around 5-ish) will produce artifacts.
            # if you want heavy blur, you need to up the blur_passes.
            # the more passes, the more you can up the blur_size without noticing artifacts.
            blur_new_optimizations = "true"; # whether to enable further optimizations to the blur. Recommended to leave on, as it will massively improve performance, but some people have experienced graphical issues
          })

          (section "animations" {
            enabled = 1;
            extraConfig = lib.flk.concatNewline [
              (defaultAnimation "windows" 7)
              (defaultAnimation "border" 10)
              (defaultAnimation "fade" 10)
              (defaultAnimation "workspaces" 6)
            ];
          })

          (section "input" {
            kb_layout = "us";
            kb_variant = "";
            kb_model = "";
            kb_options = "";
            kb_rules = "";

            numlock_by_default = "true";

            follow_mouse = 1;

            extraConfig = section "touchpad" {
              natural_scroll = "no";
            };

            # sensitivity = 1.0; # for mouse cursor
          })

          (section "gestures" {
            workspace_swipe = "true";
          })

          (section "misc" {
            enable_swallow = "true";
            swallow_regex = "alacritty";
          })

          (section "dwindle" {
            pseudotile = 0; # enable pseudotiling on dwindle
          })

          # Binds - User managed
          (bind "SUPER" "Return" "exec" vars.term)
          (bind "CTRLALT" "delete" "exec" vars.logout)
          (bind "CTRLSHIFT" "escape" "exec" vars.btop-interactive)
          (bind "SUPER" "E" "exec" vars.fm)
          (bind "SUPER" "D" "exec" vars.menu)
          # (bind "SUPERALT" "L" "exec" vars.lock)

          # Binds - Screenshoting
          # Follows KDE style.
          # (bind "" "print" "exec"
          #   (vars.screenshot ["save" "output"]))

          # (bind "CTRL" "print" "exec"
          #   (vars.screenshot ["copy" "output"]))

          # (bind "CTRLALT" "print" "exec"
          #   (vars.screenshot ["copy" "active"]))

          # (bind "ALT" "print" "exec"
          #   (vars.screenshot ["save" "active"]))

          # (bind "ALT" "S" "exec"
          #   (vars.screenshot ["copy" "area"]))

          # (bind "SHIFT" "print" "exec"
          #   (vars.screenshot ["save" "area"]))

          # # Extras
          # (bind "SUPERALT" "S" "exec"
          #   (vars.screenshot ["save" "area"]))

          # Binds - Hyprland native
          (bind "SUPER" "C" "killactive" "")
          (bind "ALT" "F4" "killactive" "")
          (bind "SUPER" "escape" "exit" "")
          (bind "SUPER" "P" "pseudo" "")
          (bind "SUPER" "F" "fullscreen" "")
          (bind "SUPERSHIFT" "space" "togglefloating" "")

          # Binds - Window focus
          (bind "SUPER" "left" "movefocus" "l")
          (bind "SUPER" "right" "movefocus" "r")
          (bind "SUPER" "up" "movefocus" "u")
          (bind "SUPER" "down" "movefocus" "d")

          # Binds - workspace change relative
          (bind "SUPER" "mouse_down" "workspace" "e+1")
          (bind "SUPER" "mouse_up" "workspace" "e-1")
          (bind "SUPERCTRL" "right" "workspace" "e+1")
          (bind "SUPERCTRL" "left" "workspace" "e-1")

          # Binds - playerctl
          (bind "SUPERALT" "space" "exec" "playerctl play-pause")
          (bind "SUPERALT" "left" "exec" "playerctl previous")
          (bind "SUPERALT" "right" "exec" "playerctl next")
          (bind "" "XF86AudioPlay" "exec" "playerctl play")
          (bind "" "XF86AudioStop" "exec" "playerctl pause")
          (bind "" "XF86AudioPrev" "exec" "playerctl previous")
          (bind "" "XF86AudioNext" "exec" "playerctl next")

          # Binds - volumectl
          (bind "SUPERALT" "down" "exec" "volumectl -")
          (bind "SUPERALT" "m" "exec" "volumectl %")
          (bind "SUPERALT" "up" "exec" "volumectl +")
          (bind "" "XF86AudioLowerVolume" "exec" "volumectl -")
          (bind "" "XF86AudioMute" "exec" "volumectl %")
          (bind "" "XF86AudioRaiseVolume" "exec" "volumectl +")

          # Binds - workspace change absolute
          (applyWorkspaceBinds (bind: "bind=SUPER,${toString bind.key},workspace,${lib.flk.concatComma bind.args}"))

          # Binds - move to workspace (silent)
          (applyWorkspaceBinds (bind: "bind=SUPERALT,${toString bind.key},movetoworkspacesilent,${lib.flk.concatComma bind.args}"))

          # Window Rules - floating
          (float {class = "btop-interactive";})

          ## Firefox
          (float {title = "^(About.*Firefox.*)$";})
          (float {title = "^Page Info —.*$";})
          (float {title = "Library";})
          (floatWith ["move 700 965"] {title = "^.*— Sharing Indicator$";})

          ## Jetbrains
          (float {class = "jetbrains-toolbox";})
          (float {title = "win1";})
          (float {title = "Migrating Plugins";})
          (float {title = "^(Import IntelliJ.*Settings)$";})

          ## pavucontrol
          (float {class = "pavucontrol";})

          ## Picture in Picture
          (float
            /*
            With ["sticky"]
            */
            {title = "^Picture(-in-P| in p)icture$";})

          # pinentry
          (float {class = "^.*pinentry.*$";})

          # Steam
          (float {title = "Friends List";})
          (float
            /*
            With ["size 760 600"]
            */
            {title = "^Steam - News.*$";})
          (float {title = "^.* - Chat$";})
          (float {title = "^.* - event started$";})
          (float {title = "^.* CD key$";})
          (float {title = "Screenshot Uploader";})
          (float {class = "Steam Keyboard";})

          # Telegram
          (floatWith ["fullscreen"] {title = "Media viewer";})

          ## zenity
          (float {title = "Progress";})

          ## zoom
          (float {title = "zoom";})
          (floatWith [
            "move 700 940"
            /*
            "border pixel 1"
            */
          ] {title = "^.* sharing (a window|your screen)$";})

          # (floatWith ["size 1000 600"] {title = "^(?!Zoom Meeting$)";})
          # (float {title = "Welcome.*"with lib.flk.hyprland;
          # (float {app_id = "yad";})
          # (floatWith ["size 1276 814"] {title = ".*kdbx - KeePass";})
          # (float {class = "KeePass2";})
          # (float {app_id = "nm-connection-editor";})
          # (float {class = "KeyStore Explorer";})
          # (float {app_id = "virt-manager";})
          # (float {app_id = "xfce-polkit";})
          # (float {instance = "origin.exe";})
          # (float {app_id = "blueberry.py";})
          # (float {title = "Manage KeeAgent.*";})
          # (float {title = "Page Info - .*";})
          # (float {class = "ConkyKeyboard";})
          # (float {class = "Gufw.py";})
          # (floatWith ["size 1276 814"] {app_id = "keepassxc";})
          # (float {app_id = "blueman-manager";})
          # (float {title = "^Open Filwith lib.flk.hyprland;$";})
          # (float {class = "^zoom$";})
          # (rule "border pixel 0" {app_id = "avizo-service";})
          # (rule ["sticky toggle"] {app_id = "avizo-service";})
          # (float {app_id = "tlp-ui";})
          # (float {title = "mpvfloat";})
          # (float {title = ".*Kee - Mozilla Firefox";})
          # (float {app_id = "nm-openconnect-auth-dialog";})
          # (float {class = "davmail-DavGateway";})
          # (float {title = "Open Database File";})
          # (float {app_id = "evolution-alarm-notify";})
          # (float {app_id = "gnome-calculator";})
          # (float {title = "TeamSpeak 3";})
          # (float {
          #   app_id = "(?i)Thunderbird";
          #   title = ".*Reminder";
          # })
          # (float {title = "Create New Calendar";})
          # (float {title = "About Mozilla .*";})
          # (float {title = "Advanced Address Book Search";})
          # (float {class = "ATLauncher";})
          # (floatWith ["border pixel 1" "sticky" "size 40 30"] {title = "File Operation Progress";})
          # (float {title = "nmtui";})
          # (float {title = "Save File";})
          # (float {window_role = "pop-up";})
          # (float {window_role = "bubble";})
          # (float {window_role = "dialog";})
          # (float {app_id = "floating";})
          # (rule ["center" "size 590 340"] {window_role = "GtkFileChooserDialog";})
          # (float {instance = "lxappearance";})
          # (float {app_id = "pamac-manager";})
          # (float {app_id = "wdisplays";})
          # (floatWith ["border pixel 1" "sticky enable" "size 30 40"] {app_id = "floating_shell_portrait";})
          # (floatWith ["border pixel 1" "sticky enable"] {app_id = "floating_shell";})
          # (float {app_id = "qt5ct";})
          # (float {app_id = "gnome-tweaks";})
          # (floatWith ["move 1500 100" "size 1200 700" "move to scratchpad" "mark $criteria"] {title = "(?i)$criteria";})
          # (rule ["title_format %title゜"] {title = ".*";})
          # (rule ["move 1503 640" "size 384 360"] {title = "^Snapdrop$";})
          # (rule ["size $φ"] {app_id = "Alacritty";})
          # (rule ["size $Φ"] {app_id = "org.qutebrowser.qutebrowser";})
          # (rule ["move left"] {app_id = "org.qutebrowser.qutebrowser";})
          # (rule ''title_format "%title (%app_id)"'' {shell = "xdg_shell";})
          # (rule ''title_format "<span>[X] %title</span>"'' {shell = "xwayland";})
        ];
  };
}
