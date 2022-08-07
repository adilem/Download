#!/bin/sh
#### "*******************************************"
#### "              Created By RAED              *"
#### "*        << Edited by  MOHAMED_OS >>       *"
#### "*        ..:: www.tunisia-sat.com ::..     *"
#### "*******************************************"
#emuname=Oscam_Supcam
#ecminfofile=ecm.info

remove_tmp() {
    rm -rf /tmp/ecm.info /tmp/ecm0.info /tmp/pid.info /tmp/cardinfo /tmp/oscam*
}

case "$1" in
start)
    remove_tmp
    sleep 1
    /usr/bin/oscam -d -c /etc/tuxbox/config/oscam.conf &
    /usr/local/etc/oscammips -d -c /usr/local/etc &
    sleep 5
    ;;
stop)
    touch /tmp/oscam.kill
    sleep 3
    killall -9 oscam 2>/dev/null
    killall -9 oscammips 2>/dev/null
    sleep 2
    remove_tmp
    ;;
*)
    $0 stop
    exit 1
    ;;
esac

exit 0
