{...}: {
  flk = {
    shared = {
      domain = "c-137.me";

      tailscale = {
        https = {
          domain = "penguin-major";
        };
      };
    };

    hosts = {
      bootstrap = {
        type = "ephemeral";
        managed = false;
      };

      NixOS = {
        type = "ephemeral";
        managed = false;
      };

      rog-bootstrap = {
        type = "ephemeral";
        managed = false;
      };

      yubikey-image = {
        type = "ephemeral";
        managed = false;
      };

      cortana = {
        tailscale = {
          ip = "100.71.82.52";
          ipv6 = "fd7a:115c:a1e0:ab12:4843:cd96:6247:5234";
        };
        tags = ["device_phone" "os_android" "user_admin"];
        managed = false;
      };

      dan-laptop = {
        tailscale = {
          ip = "100.111.65.104";
          ipv6 = "fd7a:115c:a1e0:ab12:4843:cd96:626f:4168";
        };
        tags = ["device_laptop" "os_windows" "user_admin"];
        managed = false;
      };

      living-room-tv = {
        tailscale = {
          ip = "100.101.168.3";
          ipv6 = "fd7a:115c:a1e0:ab12:4843:cd96:6265:a803";
        };
        tags = ["device_tv" "os_android" "user_regular"];
        managed = false;
      };

      pik2 = {
        gateway = ["10.0.0.1"];
        address = ["10.69.65.120/8"];
        tailscale = {
          ip = "100.69.65.120";
          ipv6 = "fd7a:115c:a1e0:ab12:4843:cd96:6245:4178";
        };
        publicKeys = {
          binaryCache = "pik2-1:Hat4WLviXd5PywqBzmf/oShlRrafPHZXMtvy/KstRjs=";
        };
        tags = ["device_nas" "os_linux" "user_admin"];
        managed = true;
      };

      themachine = {
        gateway = ["10.0.0.1"];
        address = ["10.103.176.30/8"];
        tailscale = {
          ip = "100.103.176.30";
          ipv6 = "fd7a:115c:a1e0:ab12:4843:cd96:6267:b01e";
        };
        publicKeys = {
          binaryCache = "themachine-1:p6yGZAWNBbSIlL6VX+SS6HuNXEeTu2vbgZGtDmi+h+s=";
        };
        tags = ["device_pc" "os_linux" "user_admin"];
        managed = true;
      };
    };
  };
}
