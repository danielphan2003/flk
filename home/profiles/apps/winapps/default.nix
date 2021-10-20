{ ... }: {
  xdg.configFile."winapps/winapps.conf".text = ''
    source /run/secrets/accounts
    RDP_USER="$MICROSOFT_DANIE_USER"
    RDP_PASS="$MICROSOFT_DANIE_PASSWORD"
    RDP_DOMAIN="uwu"
    RDP_NAME="uwu"
    RDP_IP="100.73.226.125"
    SHARE_PATH="$HOME/docs"
    # RDP_SCALE=100
    MULTIMON="false"
    # DEBUG="true"
  '';
}
