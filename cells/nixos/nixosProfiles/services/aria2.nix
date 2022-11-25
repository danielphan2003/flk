# unmaintained
{pkgs, ...}: {
  environment.systemPackages = [pkgs.aria2];

  services.aria2 = {
    enable = true;
    downloadDir = "/var/lib/aria2/Downloads";
    extraArguments = "--check-certificate=false";
  };
}
