{...}: let
  path = "nwg-launchers/dmenu";
in {
  xdg.configFile."${path}/style.css".source = ./style.css;
}
