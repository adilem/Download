#!/bin/sh
#### "*******************************************"
#### "              Created By RAED              *"
#### "*        << Edited by  MOHAMED_OS >>       *"
#### "*        ..:: www.tunisia-sat.com ::..     *"
#### "*******************************************"

CAMNAME="Oscam_Supcam"

remove_tmp() {
    rm -rf /tmp/cainfo.* /tmp/camd.* /tmp/sc.* /tmp/*.info* /tmp/*.tmp*
    [ -e /tmp/.emu.info ] && rm -rf /tmp/.emu.info
    [ -e /tmp/oscam.mem ] && rm -rf /tmp/oscam.mem
    [ -e /tmp/oscam.mem ] && rm -rf /tmp/oscam.mem
}

case "$1" in
start)
    echo "[SCRIPT] $1: $CAMNAME"
    remove_tmp
    touch /tmp/.emu.info
    echo $CAMNAME >/tmp/.emu.info
    /usr/bin/oscam -b -r 2 -c /etc/tuxbox/config &
    /usr/local/etc/oscammips -b -r 2 -c /usr/local/etc &
    ;;
stop)
    echo "[SCRIPT] $1: $CAMNAME"
    kill "$(pidof oscam)"
    kill "$(pidof oscammips)"
    remove_tmp
    ;;
restart)
    $0 stop
    sleep 2
    $0 start
    exit
    ;;
*)
    $0 stop
    exit 0
    ;;
esac

exit 0
