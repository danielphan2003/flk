channels: final: prev: {
  # track https://github.com/NixOS/nixpkgs/pull/125600
  # anbox =
  #   (channels.latest.anbox.override
  #     {
  #       writeScript = name: script:
  #         if name == "anbox-application-manager"
  #         then
  #           prev.writeShellScript name
  #             ''
  #               exec @out@/bin/anbox launch --package=org.anbox.appmgr --component=org.anbox.appmgr.AppViewActivity
  #             ''
  #         else prev.writeScript name script;
  #     }).overrideAttrs (o: with prev; {
  #     inherit (final.sources.anbox) src version;
  #     patches = [
  #       # Fixes compatibility with lxc 4
  #       (fetchpatch {
  #         url = "https://git.alpinelinux.org/aports/plain/community/anbox/lxc4.patch?id=64243590a16aee8d4e72061886fc1b15256492c3";
  #         sha256 = "1da5xyzyjza1g2q9nbxb4p3njj2sf3q71vkpvmmdphia5qnb0gk5";
  #       })
  #       # Wait 10× more time when starting
  #       # Not *strictly* needed, but helps a lot on slower hardware
  #       (fetchpatch {
  #         url = "https://git.alpinelinux.org/aports/plain/community/anbox/give-more-time-to-start.patch?id=058b56d4b332ef3379551b343bf31e0f2004321a";
  #         sha256 = "0iiz3c7fgfgl0dvx8sf5hv7a961xqnihwpz6j8r0ib9v8piwxh9a";
  #       })
  #     ]
  #     ++
  #     # Ensures generated desktop files work on store path change
  #     lib.our.getPatches ../pkgs/os-specific/linux/anbox
  #     ++ [
  #       # Provide window icons
  #       (fetchpatch {
  #         url = "https://github.com/samueldr/anbox/commit/2387f4fcffc0e19e52e58fb6f8264fbe87aafe4d.patch";
  #         sha256 = "12lmr0kxw1n68g3abh1ak5awmpczfh75c26f53jc8qpvdvv1ywha";
  #       })
  #     ];
  #     postInstall =
  #       let
  #         patchString = ''wrapProgram $out/bin/anbox \'';
  #         patchedPostInstall = lib.replaceString
  #           [ patchString ]
  #           [
  #             ''${patchString}
  #                 --set SDL_VIDEO_X11_WMCLASS "anbox" \''
  #           ]
  #           o.postInstall;
  #       in
  #       ''
  #         ${patchedPostInstall}
  #         chmod +x $out/bin/anbox-application-manager
  #       '';
  #   });

  inherit (channels.anbox) anbox-postmarketos-image;

  inherit (channels.latest)
    android-tools
    lxc
    ;

  androidenv.androidPkgs_9_0.platform-tools = final.android-tools;
}
