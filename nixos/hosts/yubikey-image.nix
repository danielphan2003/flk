# NixOS liveCD configuration to generate an iso to interact with Yubikey
# To build the iso:
# nixos-generate -f iso --system x86_64-linux --flake .\#yubikey-image
{
  self,
  config,
  lib,
  pkgs,
  profiles,
  nixosModulesPath,
  ...
}: let
  mkVeryForce = lib.mkOverride 0;
in {
  imports = [
    profiles.apps.fonts.fancy
    "${nixosModulesPath}/profiles/hardened.nix"
    "${nixosModulesPath}/installer/cd-dvd/installation-cd-base.nix"
  ];

  isoImage.edition = "minimal";

  # Installs all necessary packages for the iso
  environment.systemPackages = with pkgs; [
    # Pre-req Packages
    age
    cryptsetup
    ctmg
    e2fsprogs
    findutils
    gnupg
    haskellPackages.hopenpgp-tools
    mtools
    pinentry-curses
    pinentry-qt
    paperkey
    pcsctools
    pcsclite
    pwgen
    (qutebrowser.override {
      withPdfReader = false;
      withMediaPlayback = false;
    })
    srm
    wezterm
    wget

    # Yubikey Packages
    yubikey-manager
    yubikey-personalization
    yubico-piv-tool

    # CA packages
    autoconf
    automake
    libtool
    pkg-config
    check
    gengetopt
    help2man
    openssl
  ];

  system.fsPackages = [pkgs.e2fsprogs pkgs.mtools];

  # Adds the user to be able to access the yubikey
  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  # Enables the smart card mode of the Yubikey
  services.pcscd.enable = true;

  # Sets the root user to have an empty password
  services.getty.helpLine = "The 'root' account has an empty password.";
  users.extraUsers.root.initialHashedPassword = "";

  # Makes sure that all data is written to ram and not persistently stored
  boot.kernelParams = ["copytoram"];

  # Defaults to make sure everything in here is secured
  boot.kernelModules = ["dm-crypt"];
  boot.supportedFilesystems = ["ext2" "ext3" "ext4" "vfat"];
  boot.cleanTmpDir = true;
  boot.kernel.sysctl = {
    "kernel.unprivileged_bpf_disabled" = 1;
  };

  # Air-gapped system
  boot.initrd.network.enable = mkVeryForce false;
  networking.dhcpcd.enable = mkVeryForce false;
  networking.dhcpcd.allowInterfaces = mkVeryForce [];
  networking.firewall.enable = mkVeryForce true;
  networking.useDHCP = mkVeryForce false;
  networking.useNetworkd = mkVeryForce false;
  networking.wireless.enable = mkVeryForce false;
  services.openssh = {
    enable = mkVeryForce false;
    permitRootLogin = mkVeryForce false;
  };

  # Allows Yubukey to have SSH and GPG authentication
  programs = {
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  programs.sway.enable = true;

  environment.etc."sway/config".text = ''
    include ${pkgs.sway}/etc/sway/config
    bindsym Mod1+Return wezterm
    exec systemctl --user import-environment
    exec qutebrowser ${pkgs.yubikey-guide}
    exec wezterm
  '';

  # Automatically configure and start Sway when logging in on tty1:
  programs.bash.loginShellInit = ''
    if [ "$(tty)" = "/dev/tty1" ]; then
      set -e
      sway --validate
      sway
    fi
  '';

  # Sets up the shell to have an environment variable that creates the directory for all generated keys
  # Also utilizes a preconfigured gpg config and configures a gpg-agent config.
  programs.bash.interactiveShellInit = ''
        gpg-switch-key () {
          gpg-connect-agent "scd $1" "learn --force" /bye
        }

        secret () {
          output=~/"''${1}".$(date +%s).enc
          gpg --encrypt --armor --output ''${output} "''${2}" "''${1}" && echo "''${1} -> ''${output}"
        }

        reveal () {
          output=$(echo "''${1}" | rev | cut -c16- | rev)
          gpg --decrypt --output ''${output} "''${1}" && echo "''${1} -> ''${output}"
        }

        truncate () {
          dd if=/dev/urandom of="''${2}" bs=''${1}
        }

        export GNUPGHOME=/run/user/$(id -u)/gnupghome

        if [ ! -f ~/.yubikey-image.lock ]; then
          touch ~/.yubikey-image.lock

          if [ ! -d $GNUPGHOME ]; then
            mkdir $GNUPGHOME
          fi

          sudo cp ${pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/drduh/config/2334d3d1d058d9d16ca797f49740643f793303ed/gpg.conf";
      sha256 = "118fmrsn28fz629y7wwwcx7r1wfn59h3mqz1snyhf8b5yh0sb8la";
    }} "$GNUPGHOME/gpg.conf"

          sudo cat << EOF > $GNUPGHOME/gpg-agent.conf
    pinentry-program /run/current-system/sw/bin/pinentry-curses
    EOF

          sudo chown nixos:users $GNUPGHOME/gpg-agent.conf
          find $GNUPGHOME -type f -exec sudo chmod 600 {} \;
          find $GNUPGHOME -type d -exec sudo chmod 700 {} \;

          echo "\$GNUPGHOME has been set up for you. Generated keys will be in $GNUPGHOME."

          [[ -L ~/oldkey.sec.age ]] && unlink ~/oldkey.sec.age
          ln -s ${self}/secrets/nixos/hosts/oldkey.sec.age ~/oldkey.sec.age
          echo "An existing key is also available at ~/oldkey.sec.age"
        fi
  '';

  fileSystems."/" = {device = "/dev/disk/by-label/nixos";};
}
