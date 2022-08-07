#!/bin/sh
#### "*******************************************"
#### "              Created By RAED              *"
#### "*        << Edited by  MOHAMED_OS >>       *"
#### "*        ..:: www.tunisia-sat.com ::..     *"
#### "*******************************************"

# DOMICA image
remove_tmp() {
    rm -rf /tmp/*.tmp* /tmp/*.info*
}

case "$1" in
start)
    remove_tmp
    /usr/bin/oscam -d -c /etc/tuxbox/config &
    /usr/local/etc/oscammips -d -c /usr/local/etc &
    ;;
stop)
    killall -9 oscam 2>/dev/null
    killall -9 oscammips 2>/dev/null
    sleep 2
    remove_tmp
    ;;
*)
    $0 stop
    exit 0
    ;;
esac

exit 0
