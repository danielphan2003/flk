{
  config,
  lib,
  profiles,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [profiles.services.fail2ban];

  programs.ssh.startAgent = mkDefault true;

  # For rage encryption, all hosts need a ssh key pair
  services.openssh = {
    enable = true;

    openFirewall =
      mkDefault
      (lib.any
        (i: i == config.services.tailscale.interfaceName && config.services.tailscale.enable)
        config.networking.firewall.trustedInterfaces);

    passwordAuthentication = false;

    permitRootLogin = "yes";

    allowSFTP = false;

    kbdInteractiveAuthentication = false;

    kexAlgorithms = [
      "curve25519-sha256@libssh.org"
      "diffie-hellman-group16-sha512"
      "diffie-hellman-group18-sha512"
      "diffie-hellman-group14-sha256"
    ];

    macs = [
      "hmac-sha2-512-etm@openssh.com"
      "hmac-sha2-256-etm@openssh.com"
      "umac-128-etm@openssh.com"
    ];

    extraConfig = ''
      #-------------------------------------------------------#
      # Login restrictions                                    #
      #-------------------------------------------------------#
      LoginGraceTime 30s
      StrictModes yes
      MaxAuthTries 3
      MaxSessions 5

      AuthenticationMethods publickey
      HostbasedAuthentication no
      IgnoreRhosts yes
      PermitEmptyPasswords no

      AllowAgentForwarding yes
      AllowTcpForwarding no
      StreamLocalBindUnlink yes

      PermitTTY yes
      PermitUserEnvironment no

      #-------------------------------------------------------#
      # Enable compression                                    #
      #-------------------------------------------------------#
      Compression yes

      ClientAliveInterval 600
      ClientAliveCountMax 0
      MaxStartups 10:30:100
      PermitTunnel no
      VersionAddendum none

      #-------------------------------------------------------#
      # Display a banner before authenticating to the system. #
      # Use your own /etc/issue.net file                      #
      #-------------------------------------------------------#
      Banner /etc/issue

      #-------------------------------------------------------#
      # Allow client to pass locale environment variables     #
      #-------------------------------------------------------#
      AcceptEnv LANG LC_*
    '';
  };
}
