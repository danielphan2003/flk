{ pkgs, ... }: {
  environment = {
    sessionVariables.BROWSER = "chromium-browser";
    systemPackages = with pkgs; [ ungoogled-chromium ];
  };
}
