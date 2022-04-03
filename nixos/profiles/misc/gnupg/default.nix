{lib, ...}: {
  programs.gnupg.agent = {
    enable = true;
    # enableSSHSupport = true;
    enableExtraSocket = true;
    pinentryFlavor = lib.mkDefault "curses";
  };

  # gnupg-agent starts its own agent
  # programs.ssh.startAgent = false;
  # not unless ssh uses id_rsa_sk
}
