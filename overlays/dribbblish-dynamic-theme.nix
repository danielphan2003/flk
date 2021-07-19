final: prev: {
  dribbblish-dynamic-theme = prev.dribbblish-dynamic-theme.overrideAttrs (_: {
    # TODO: see https://github.com/morpheusthewhite/spicetify-themes/issues/467
    prePatch = ''
      substituteInPlace user.css \
        --replace ".connect-device-list-container {" ".connect-device-list-container { overflow-y: scroll; height: 120px;" # \
        # --replace "#dribs-sidebar-config {" "#dribs-sidebar-config { left: 120px !important; "
        # # --replace ".main-contextMenu-menu {" ".main-contextMenu-menu { left: 120px; "
    '';
  });
}
