{...}: {
  programs.git = {
    userEmail = "danielphan.2003@c-137.me";

    userName = "Daniel Phan";

    signing.signByDefault = true;

    extraConfig.github.user = "danielphan2003";
  };
}
