#!/bin/sh
#### "*******************************************"
#### "              Created By RAED              *"
#### "*        << Edited by  MOHAMED_OS >>       *"
#### "*        ..:: www.tunisia-sat.com ::..     *"
#### "*******************************************"

NAME="Oscam_Supcam"

remove_tmp() {
    rm -rf /tmp/*oscam* /tmp/camd.socket /tmp/pid.info /tmp/ecm*.info /tmp/cardinfo /tmp/*cam*.pid /tmp/cam.kill
}

case "$1" in
start)
    echo "[SCRIPT] $1: $NAME"
    remove_tmp
    sleep 1
    /usr/bin/oscam &
    /usr/local/etc/oscammips &
    sleep 1
    pidof oscam >/tmp/oscam.pid
    ;;
stop)
    echo "[SCRIPT] $1: $NAME"
    kill 2>/dev/null "$(cat 2>/dev/null /tmp/oscam.pid)"
    sleep 1
    killall -9 oscam 2>/dev/null
    killall -9 oscammips 2>/dev/null
    remove_tmp
    ;;
*)
    $0 stop
    exit 1
    ;;
esac

exit 0
