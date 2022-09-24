{
  lib,
  writeShellScriptBin,
  coreutils,
  glib,
  gnugrep,
}:
writeShellScriptBin "import-gsettings" ''
  config="''${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini"

  [ ! -f "$config" ] && {
    notify-send "import-gsettings" "Error finding $config"
    exit 1
  }

  getProp() {
    ${gnugrep}/bin/grep "$1" "$config" | ${coreutils}/bin/cut -d'=' -f2
  }

  gnome_schema="org.gnome.desktop.interface"

  ${glib}/bin/gsettings set org.gtk.Settings.FileChooser window-size "(1100,700)"

  ${lib.concatMapStringsSep "\n"
    (x: ''${glib}/bin/gsettings set "$gnome_schema" ${x} "$(getProp ${x}-name)"'')
    [
      "gtk-theme"
      "icon-theme"
      "cursor-theme"
      "font"
    ]}
''
