args@{ pkgs, ... }:
let
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
in
{
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
    idle_inhibitor = {
      format = "{icon}";
      format-icons = {
        activated = "";
        deactivated = "";
      };
    };

    tray.spacing = 10;

    clock = {
      format = "{:%a at %d/%m → %H:%M:%S}";
      interval = 1;
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format-alt = "{:%A, %d %b}";
    };

    cpu.format = "{usage}% ";

    memory.format = "{}% ";

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

    "custom/power" = {
      format = "";
      on-click = "exec ${pkgs.waylandPkgs.nwg-launchers}/bin/nwgbar -o 0.2";
      escape = true;
      tooltip = false;
    };
  };
}
