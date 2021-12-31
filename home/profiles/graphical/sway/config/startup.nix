{ pkgs }:
let
  clipboard-daemon = pkgs.callPackage ./scripts/clipboard-daemon.nix { };
  import-gsettings = pkgs.callPackage ./scripts/import-gsettings.nix { };
in
with pkgs;
[
  { command = "${autotiling}/bin/autotiling"; }
  { command = "${clipboard-daemon}"; }
  { command = "${import-gsettings}"; always = true; }
  { command = "${coreutils}/bin/mkfifo $$SWAYSOCK.wob && ${coreutils}/bin/tail -f $$SWAYSOCK.wob | ${wob}/bin/wob"; }
  { command = "${flameshot}/bin/flameshot"; always = true; }
  { command = "[ $(${ibus}/bin/ibus restart && exit) ] || ${ibus}/bin/ibus-daemon -drx"; always = true; }
]
