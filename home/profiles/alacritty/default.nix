{ pkgs, ... }: {
  xdg.configFile."alacritty/alacritty.yml".source = ./alacritty.yml;
  programs.alacritty = {
    enable = true;
    # settings = {
    #   window = {
    #     dynamic_padding = true;
    #     dynamic_title = true;
    #     decoration = "full";
    #   };

    #   scrolling = {
    #     history = 10000;
    #     multiplier = 3;
    #   };

    #   font = {
    #     normal = {
    #       family = "Iosevka Term";
    #       style = "Regular";
    #     };
    #     bold = {
    #       family = "Iosevka Term";
    #       style = "Bold";
    #     };
    #     italic = {
    #       family = "Iosevka Term";
    #       style = "Italic";
    #     };
    #     bold_italic = {
    #       family = "Iosevka Term";
    #       style = "Bold Italic";
    #     };
    #     size = 14.0;
    #   };

    #   draw_bold_text_with_bright_colors = true;

    #   colors = {
    #     primary = {
    #       background = "0x282c34";
    #       foreground = "0xdcdfe4";
    #     };
    #     normal = {
    #       black = "0x282c34";
    #       red = "0xe06c75";
    #       green = "0x98c379";
    #       yellow = "0xe5c07b";
    #       blue = "0x61afef";
    #       magenta = "0xc678dd";
    #       cyan = "0x56b6c2";
    #       white = "0xdcdfe4";
    #     };
    #     bright = {
    #       black = "0x282c34";
    #       red = "0xe06c75";
    #       green = "0x98c379";
    #       yellow = "0xe5c07b";
    #       blue = "0x61afef";
    #       magenta = "0xc678dd";
    #       cyan = "0x56b6c2";
    #       white = "0xdcdfe4";
    #     };
    #   };

    #   background_opacity = 0.8;
    #   cursor.style = "Beam";
    #   live_config_reload = true;
    #   shell.program = "${pkgs.zsh}/bin/zsh";

    #   hints.enabled = [
    #     {
    #       regex = ''(magnet:|mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:)\
    #               [^\u0000-\u001F\u007F-\u009F<>\"\\s{-}\\^⟨⟩`]+'';
    #       command = "${pkgs.ungoogled-chromium}/bin/chromium-browser";
    #       post_processing = true;
    #       mouse.enabled = true;
    #       # multi regex for different purposes:
    #       # 1. Kubernetes Resources
    #       # 2. UUIDs
    #       # 3. hex (for example signatures)
    #       # 4. IP addresses
    #     }
    #     {
    #       regex = ''((deployment.app|binding|componentstatuse|configmap|endpoint|event|limitrange|namespace|node|persistentvolumeclaim|persistentvolume|pod|podtemplate|replicationcontroller|resourcequota|secret|serviceaccount|service|mutatingwebhookconfiguration.admissionregistration.k8s.io|validatingwebhookconfiguration.admissionregistration.k8s.io|customresourcedefinition.apiextension.k8s.io|apiservice.apiregistration.k8s.io|controllerrevision.apps|daemonset.apps|deployment.apps|replicaset.apps|statefulset.apps|tokenreview.authentication.k8s.io|localsubjectaccessreview.authorization.k8s.io|selfsubjectaccessreviews.authorization.k8s.io|selfsubjectrulesreview.authorization.k8s.io|subjectaccessreview.authorization.k8s.io|horizontalpodautoscaler.autoscaling|cronjob.batch|job.batch|certificatesigningrequest.certificates.k8s.io|events.events.k8s.io|daemonset.extensions|deployment.extensions|ingress.extensions|networkpolicies.extensions|podsecuritypolicies.extensions|replicaset.extensions|networkpolicie.networking.k8s.io|poddisruptionbudget.policy|clusterrolebinding.rbac.authorization.k8s.io|clusterrole.rbac.authorization.k8s.io|rolebinding.rbac.authorization.k8s.io|role.rbac.authorization.k8s.io|storageclasse.storage.k8s.io)[[:alnum:]_#$%&+=/@-]+)|([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})|([0-9a-f]{12,128})|([[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3})'';
    #       action = "Copy";
    #       post_processing = false;
    #       binding = {
    #         key = "U";
    #         mods = "Control|Shift";
    #       };
    #     }
    #   ];

    #   key_bindings = [
    #     { key = "V";               mods = "Control|Shift"; action = "Paste";            }
    #     { key = "C";               mods = "Control|Shift"; action = "Copy";             }
    #     { key = "Equals";          mods = "Control";       action = "IncreaseFontSize"; }
    #     { key = "NumpadAdd";       mods = "Control";       action = "IncreaseFontSize"; }
    #     { key = "NumpadSubtract";  mods = "Control";       action = "DecreaseFontSize"; }
    #     { key = "Minus";           mods = "Control";       action = "DecreaseFontSize"; }
    #     { key = "Return";          mods = "Alt";           action = "ToggleFullscreen"; }
    #     { key = "PageUp";          mods = "Shift";         action = "ScrollPageUp";    mode = "~Alt"; }
    #     { key = "PageDown";        mods = "Shift";         action = "ScrollPageDown";  mode = "~Alt"; }
    #     { key = "Home";            mods = "Shift";         action = "ScrollToTop";     mode = "~Alt"; }
    #     { key = "End";             mods = "Shift";         action = "ScrollToBottom";  mode = "~Alt"; }
    #   ];
    # };
  };
}
