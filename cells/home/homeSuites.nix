{
  desktop = [
    cell.homeProfiles.desktop.xdg
    cell.homeProfiles.gui.gtk
    cell.homeProfiles.services.udiskie
  ];

  ephemeral = [
    cell.homeProfiles.desktop.xdg
    # dead hard drive lmao
    # cell.homeProfiles.misc.persistence;
  ];

  streaming = [
    cell.homeProfiles.programs.obs-studio
  ];
}
