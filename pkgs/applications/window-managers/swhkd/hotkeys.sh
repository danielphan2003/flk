#! @runtimeShell@

PATH="$PATH:@path@"

@psmisc@/bin/killall swhks

@out@/bin/swhks & /run/wrappers/bin/pkexec @out@/bin/swhkd -c "$HOME"/.config/swhkd/swhkdrc
