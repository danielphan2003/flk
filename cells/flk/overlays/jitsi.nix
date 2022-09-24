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
    inherit (final.fog.jibri) src version;
  });

  jicofo = jicofo.overrideAttrs (_: {
    inherit (final.fog.jicofo) src version;
  });

  jitsi-meet = jitsi-meet.overrideAttrs (_: {
    inherit (final.fog.jitsi-meet) src version;
  });

  jitsi-meet-prosody = jitsi-meet-prosody.overrideAttrs (_: {
    inherit (final.fog.jitsi-meet-prosody) src version;
  });

  jitsi-videobridge = jitsi-videobridge.overrideAttrs (_: {
    inherit (final.fog.jitsi-videobridge2) src version;
  });
}
