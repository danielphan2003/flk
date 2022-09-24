{...}: {
  xdg.configFile."winapps/winapps.conf".text = ''
    source /run/agenix/accounts
    RDP_USER="$MICROSOFT_USER"
    RDP_PASS="$MICROSOFT_PASSWORD"
    RDP_DOMAIN="uwu"
    RDP_NAME="uwu"
    RDP_IP="@RDP_IP@"
    SHARE_PATH="~/docs"
    # RDP_SCALE=100
    MULTIMON="false"
    # DEBUG="true"
  '';
}
