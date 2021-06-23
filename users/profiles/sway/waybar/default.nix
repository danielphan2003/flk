{ pkgs, lib, config, ... }:
let
  inherit (lib.our) mkWaybarModule;
  inherit (lib.our.pywal) mkWaybarColors;

  mediaplayer = mkWaybarModule ./modules/mediaplayer.nix { inherit pkgs; };

  play-pause = mkWaybarModule ./modules/play-pause.nix { inherit pkgs; };

  battery = name: {
    bat = name;
    states = {
      warning = 30;
      critical = 15;
    };
    format = "{capacity}% {icon}";
    format-charging = "{capacity}% ";
    format-plugged = "{capacity}% ";
    format-alt = "{time} {icon}";
    format-icons = [ "" "" "" "" "" ];
  };

  media = player: {
    format = "{icon} {}";
    return-type = "json";
    max-length = 55;
    format-icons = {
      Playing = "";
      Paused = "";
    };
    exec = "${mediaplayer} ${player}";
    exec-if = "[ $(${pkgs.playerctl}/bin/playerctl -l | wc -l) -ge ${player} ] || [ $(${pkgs.playerctl}/bin/playerctl -l | grep ${player}) ]";
    interval = 1;
    on-click = "${play-pause} ${player}";
  };
in
{
  programs.waybar = {
    enable = true;
    package = pkgs.waylandPkgs.waybar;
    systemd.enable = true; 
    settings = [{
      height = 40;
      modules-left = [
        "sway/workspaces"
        "sway/mode"
        "custom/media#firefox"
        "custom/media#spotify"
        "custom/media#vlc"
        "custom/media#other"
      ];
      modules-center = [ ];
      modules-right = [
        "idle_inhibitor"
        "tray"
        "pulseaudio"
        "network"
        "memory"
        "cpu"
        "backlight"
        "clock"
        "custom/power"
      ];
      modules = {
        "sway/workspaces" = {
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            "9" = "";
            "10" = "";
            "22" = "";
            focused = "";
            urgent = "";
            default = "";
          };
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        tray = {
          spacing = 10;
        };
        clock = {
          format = "{:%a at %d/%m → %H:%M:%S}";
          interval = 1;
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%A, %d %b}";
        };
        cpu = {
          format = "{usage}% ";
        };
        memory = {
          format = "{}% ";
        };
        backlight = {
          format = "{icon}";
          format-alt = "{percent}% {icon}";
          format-alt-click = "click-right";
          format-icons = [ "○" "◐" "●" ];
          on-scroll-down = "light -U 10";
          on-scroll-up = "light -A 10";
        };
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
          format-linked = "Ethernet (No IP) ";
          format-disconnected = "Disconnected ";
          format-alt = " {bandwidthDownBits}   {bandwidthUpBits}";
          on-click-middle = "nm-connection-editor";
        };
        pulseaudio = {
          scroll-step = 1;
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };
        "custom/media#firefox" = media "firefox";
        "custom/media#spotify" = media "spotify";
        "custom/media#vlc" = media "vlc";
        "custom/media#other" = media "other";
        "custom/power" = {
          format = "";
          on-click = "exec ${pkgs.waylandPkgs.nwg-launchers}/bin/nwgbar -o 0.2";
          escape = true;
          tooltip = false;
        };
      };
    }];
    style = mkWaybarColors {
      inherit config;
      style = ./style.css;
      pywalPath = "/home/danie/.cache/wal/colors-waybar.css";
      workspaces = 22;
    };
  };
}
