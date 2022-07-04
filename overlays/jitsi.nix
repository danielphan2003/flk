final: prev: let
  inherit
    (prev)
    jibri
    jicofo
    jitsi-meet
    jitsi-meet-prosody
    jitsi-videobridge
    ;
in {
  jibri = jibri.overrideAttrs (_: {
    inherit (final.dan-nixpkgs.jibri) src version;
  });

  jicofo = jicofo.overrideAttrs (_: {
    inherit (final.dan-nixpkgs.jicofo) src version;
  });

  jitsi-meet = jitsi-meet.overrideAttrs (_: {
    inherit (final.dan-nixpkgs.jitsi-meet) src version;
  });

  jitsi-meet-prosody = jitsi-meet-prosody.overrideAttrs (_: {
    inherit (final.dan-nixpkgs.jitsi-meet-prosody) src version;
  });

  jitsi-videobridge = jitsi-videobridge.overrideAttrs (_: {
    inherit (final.dan-nixpkgs.jitsi-videobridge2) src version;
  });
}
