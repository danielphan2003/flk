{pkgs, ...}: {
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = builtins.attrValues {
      inherit (pkgs.ibus-engines) bamboo uniemoji;
    };
  };

  environment.sessionVariables = {
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE = "ibus";
    XMODIFIERS = "@im=ibus";
    IBUS_DISCARD_PASSWORD_APPS = "'firefox,.*chrome.*'";
  };
}
