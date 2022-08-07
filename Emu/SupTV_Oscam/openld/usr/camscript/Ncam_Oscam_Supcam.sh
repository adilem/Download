#!/bin/sh
#### "*******************************************"
#### "              Created By RAED              *"
#### "*        << Edited by  MOHAMED_OS >>       *"
#### "*        ..:: www.tunisia-sat.com ::..     *"
#### "*******************************************"

CAMNAME="Oscam_Supcam"

remove_tmp() {
    rm -rf /tmp/*.info* /tmp/*.tmp* /tmp/*oscam*
}
echo "[SCRIPT] $1: $CAMNAME"
start_cam() {
    remove_tmp
    sleep 2
    /usr/bin/oscam -d -c /etc/tuxbox/config/oscam.conf &
    /usr/local/etc/oscammips -d -c /usr/local/etc &
}
echo "[SCRIPT] $1: $CAMNAME"
stop_cam() {
    remove_tmp
    killall -9 oscam 2>/dev/null
    killall -9 oscammips 2>/dev/null
}
case "$1" in
start)
    start_cam
    ;;
stop)
    stop_cam
    ;;
restart)
    $0 stop
    $0 start
    ;;
*) ;;

esac

exit 0
