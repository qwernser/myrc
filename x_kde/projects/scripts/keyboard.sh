#! /bin/bash
function remap() {
    sleep $1
    xkbcomp $HOME/.config/output.xkb $DISPLAY ;
}

if [ -z $1 ] ; then remap 6 ; fi
inotifywait -e modify /sys/devices/virtual/tty/tty0/active
if [ "$(cat /sys/devices/virtual/tty/tty0/active)" = "tty7" ] ; then
    remap 1
fi
exec $0 non-initial
