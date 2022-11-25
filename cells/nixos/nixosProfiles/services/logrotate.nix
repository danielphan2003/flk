{...}: {
  # Keep 4 rotations of log files before removing or mailing to the address specified in a mail directive
  services.logrotate.settings.default = {
    global = true;
    # Rotate when the size is bigger than 5MB
    rotate = 4;
    size = "5M";
    # Compress old log files
    compress = true;
    # Truncate the original log file in place after creating a copy
    copytruncate = true;
    # Don't panic if not found
    missingok = true;
    # Don't rotate log if file is empty
    notifempty = true;
    # Add date instaed of number to rotated log file
    dateext = true;
    # Date format of dateext
    dateformat = "-%Y-%m-%d-%s";
  };
}
