#!/bin/sh
#### "*******************************************"
#### "              Created By RAED              *"
#### "*        << Edited by  MOHAMED_OS >>       *"
#### "*        ..:: www.tunisia-sat.com ::..     *"
#### "*******************************************"

CAMNAME="Oscam_Supcam"

usage() {
    echo "Usage: $0 {start|stop|restart|reload}"
}

if [ $# -lt 1 ]; then usage; fi
action=$1

case "$action" in
start)
    echo "[SCRIPT] $1: $CAMNAME"
    /usr/bin/oscam -d -c /etc/tuxbox/config/oscam.conf &
    /usr/local/etc/oscammips -d -c /usr/local/etc &
    ;;
stop)
    echo "[SCRIPT] $1: $CAMNAME"
    killall -9 oscam
    killall -9 oscammips 2>/dev/null
    ;;
restart | reload)
    $0 stop
    $0 start
    ;;
*)
    usage
    ;;
esac

exit 0
