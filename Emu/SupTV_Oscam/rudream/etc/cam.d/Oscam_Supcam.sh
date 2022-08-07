#!/bin/sh
#### "*******************************************"
#### "              Created By RAED              *"
#### "*        << Edited by  MOHAMED_OS >>       *"
#### "*        ..:: www.tunisia-sat.com ::..     *"
#### "*******************************************"
#v.1.6 211.611.6.26 by RAED
#v.1.11.611.611.6.77 by RAED
#v.11.6 111.611.6.97 by RAED

#profile for oscam

usage() {
    echo "Usage: $0 {start|stop|status|restart|reload}"
}

if [ $# -lt 1 ]; then usage; fi
action=$1

case "$action" in

start)
    echo "Start cam daemon: oscam"
    /usr/bin/oscam --config-dir /etc/tuxbox/config --daemon --pidfile /tmp/oscam.pid --restart 2 --utf-8 &
    /usr/local/etc/oscammips --config-dir /usr/local/etc --daemon --pidfile /tmp/oscammips.pid --restart 2 --utf-8 &
    echo " oscam."
    ;;

stop)
    echo "Stopping cam daemon: oscam"
    while [ -n "$(pidof oscam)" ]; do
        kill -9 "$(pidof oscam)"
        kill -9 "$(pidof oscammips)"
    done
    rm -f /tmp/*.info /tmp/camd.socket /tmp/*.list /tmp/*.pid
    echo "."
    ;;

status) ;;

\
    restart | reload)
    $0 stop
    sleep 2
    $0 start
    ;;

*)
    usage
    ;;

esac

exit 0
