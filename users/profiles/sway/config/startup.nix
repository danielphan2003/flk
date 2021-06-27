{ pkgs, ... }:
let
  clipboard-daemon = pkgs.callPackage ./scripts/clipboard-daemon.nix { };
  import-gsettings = pkgs.callPackage ./scripts/import-gsettings.nix { };
in
{
  startup = with pkgs; [
    { command = "${autotiling}/bin/autotiling"; }
    { command = "${clipboard-daemon}"; }
    { command = "${import-gsettings}"; always = true; }
    { command = "${coreutils}/bin/mkfifo $$SWAYSOCK.wob && ${coreutils}/bin/tail -f $$SWAYSOCK.wob | ${wob}/bin/wob"; }
    { command = "${ibus}/bin/ibus-daemon -drxR"; always = true; }
  ];
}
