{
  lib,
  pkgs,
  ...
}: {
  programs.chromium = {
    enable = true;

    package = lib.mkDefault pkgs.ungoogled-chromium;

    commandLineArgs = lib.flatten (builtins.attrValues {
      inherit
        (pkgs.lib.electron-utils.flags)
        extras
        wayland
        ;
    });

    extensions = [
      # Chrome Remote Desktop
      {id = "inomeogfingihgjfjlpeplalcfajhgai";}

      # Chromium Web Store
      {id = "ocaahdebbfolfmndjeplogmgcagdmblk";}

      # Clickbait Remover for Youtube
      {id = "omoinegiohhgbikclijaniebjpkeopip";}

      # Dark Reader
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";}

      # PDF Reader
      {id = "ieepebpjnkhaiioojkepfniodjmjjihl";}

      # Picture-in-Picture Extension (by Google)
      {id = "hkgfoiooedgoejojocmhlaklaeopbecg";}

      # Save Tab Groups for Tab Session Manager
      {id = "aghdiknflpelpkepifoplhodcnfildao";}

      # SponsorBlock for YouTube - Skip Sponsorships
      {id = "mnjggcdmjocbbbhaepdhchncahnbgone";}

      # Tab Session Manager
      {id = "iaiomicjabeggjcfkbimgmglanimpnae";}

      # uBlock Origin
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}

      # uGet Integration
      {id = "efjgjleilhflffpbnkaofpmdnajdpepi";}

      # User-Agent Switcher and Manager
      {id = "bhchdcejhohfmigjafbampogmaanbfkg";}
    ];
  };

  # flutter debugger or other apps need this
  home.sessionVariables.CHROME_EXECUTABLE = "${pkgs.ungoogled-chromium}/bin/chromium-browser";
}
