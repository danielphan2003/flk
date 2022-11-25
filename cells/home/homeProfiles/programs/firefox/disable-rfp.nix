{...}: {
  programs.firefox.profiles.default.arkenfox = {
    /*
    override recipe: RFP is not for me **
    */
    "4500" = {
      "4501"."privacy.resistFingerprinting".value = false;
      "4504"."privacy.resistFingerprinting.letterboxing".value = false; # [pointless if not using RFP]
      "4520"."webgl.disabled".value = false; # [mostly pointless if not using RFP]
    };
  };
}
