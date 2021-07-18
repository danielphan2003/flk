{ coreutils, glib, gnugrep, writeScript }:
writeScript "import-gsettings.sh" ''
  # usage: import-gsettings
  config="$HOME/.config/gtk-3.0/settings.ini"

  [ ! -f "$config" ] && exit 1

  gnome_schema="org.gnome.desktop.interface"
  gtk_theme="$(${gnugrep}/bin/grep "gtk-theme-name" "$config" | ${coreutils}/bin/cut -d'=' -f2)"
  icon_theme="$(${gnugrep}/bin/grep "gtk-icon-theme-name" "$config" | ${coreutils}/bin/cut -d'=' -f2)"
  cursor_theme="$(${gnugrep}/bin/grep "gtk-cursor-theme-name" "$config" | ${coreutils}/bin/cut -d'=' -f2)"
  font_name="$(${gnugrep}/bin/grep "gtk-font-name" "$config" | ${coreutils}/bin/cut -d'=' -f2)"

  ${glib}/bin/gsettings set org.gtk.Settings.FileChooser window-size "(1100,700)"
  ${glib}/bin/gsettings set "$gnome_schema" gtk-theme "$gtk_theme"
  ${glib}/bin/gsettings set "$gnome_schema" icon-theme "$icon_theme"
  ${glib}/bin/gsettings set "$gnome_schema" cursor-theme "$cursor_theme"
  ${glib}/bin/gsettings set "$gnome_schema" font-name "$font_name"
''
