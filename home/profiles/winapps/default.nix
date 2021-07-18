{ ... }: {
  xdg.configFile."winapps/winapps.conf".text = ''
    source /run/secrets/accounts
    RDP_USER="$MICROSOFT_DANIE_USER"
    RDP_PASS="$MICROSOFT_DANIE_PASSWORD"
    RDP_IP="$MICROSOFT_DANIE_RDP_IP"
    # RDP_SCALE=100
    MULTIMON="false"
    # DEBUG="true"
  '';
}
