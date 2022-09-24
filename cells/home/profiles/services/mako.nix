{
  config,
  pkgs,
  ...
}: {
  programs.mako = {
    enable = true;
    anchor = "top-right";
    layer = "overlay";

    # padding = "15,20";
    # margin = "0,10,10,0";
    iconPath = "${config.gtk.iconTheme.package}/share/icons/${config.gtk.iconTheme.name}";

    # borderSize = 1;
    borderRadius = 10;

    defaultTimeout = 10000;
  };
}
