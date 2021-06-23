final: prev:
{
  # libsForQt5 = prev.libsForQt5 // {
  #   sddm = prev.libsForQt5.sddm.overrideAttrs
  #     (o:
  #       let src = final.srcs.sddm;
  #       in
  #       {
  #         inherit src;
  #         inherit (src) version;
  #       });
  # };
}