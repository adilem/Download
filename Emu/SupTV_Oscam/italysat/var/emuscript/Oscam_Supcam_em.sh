#!/bin/sh
#### "*******************************************"
#### "              Created By RAED              *"
#### "*        << Edited by  MOHAMED_OS >>       *"
#### "*        ..:: www.tunisia-sat.com ::..     *"
#### "*******************************************"

remove_tmp() {
    rm -rf /tmp/ecm.info /tmp/pid.info /tmp/cardinfo /tmp/mg* /tmp/oscam*
}

case "$1" in
start)
    remove_tmp
    /var/bin/oscam -c /etc/tuxbox/config &
    /usr/local/etc/oscammips -c /usr/local/etc &
    sleep 3
    ;;
stop)
    killall -9 oscam
    killall -9 oscammips
    remove_tmp
    sleep 2
    ;;
*)
    $0 stop
    exit 1
    ;;
esac

exit 0
