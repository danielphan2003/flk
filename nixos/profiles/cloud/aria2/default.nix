{ pkgs, ... }: {
  environment.systemPackages = builtins.attrValues { inherit (pkgs) aria2; };

  services.aria2 = {
    enable = true;
    # do not set this to your home directory.
    # apparently aria2 create tmpfiles based on downloadDir with root:root, so doing so would result in something like this:
    # "Detected unsafe path transition /home/${user} → /home/${user}/dl during canonicalization of /home/${user}/dl."
    downloadDir = "/var/lib/aria2/Downloads";
    extraArguments = "--check-certificate=false";
  };
}
