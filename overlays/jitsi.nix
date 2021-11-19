channels: final: prev:
let
  inherit (channels.latest)
    jibri
    jicofo
    jitsi-meet
    jitsi-meet-prosody
    jitsi-videobridge
    ;
in
{
  jibri = jibri.overrideAttrs (_: {
    inherit (final.sources.jibri) src version;
  });

  jicofo = jicofo.overrideAttrs (_: {
    inherit (final.sources.jicofo) src version;
  });

  jitsi-meet = jitsi-meet.overrideAttrs (_: {
    inherit (final.sources.jitsi-meet) src version;
  });

  jitsi-meet-prosody = jitsi-meet-prosody.overrideAttrs (_: {
    inherit (final.sources.jitsi-meet-prosody) src version;
  });

  jitsi-videobridge = jitsi-videobridge.overrideAttrs (_: {
    inherit (final.sources.jitsi-videobridge2) src version;
  });
}
