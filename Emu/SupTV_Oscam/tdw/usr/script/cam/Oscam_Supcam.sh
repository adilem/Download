#!/bin/sh
#### "*******************************************"
#### "              Created By RAED              *"
#### "*        << Edited by  MOHAMED_OS >>       *"
#### "*        ..:: www.tunisia-sat.com ::..     *"
#### "*******************************************"

OSD="Oscam_Supcam"
PID=$(pidof oscam)
Action=$1

cam_clean() {
    rm -rf /tmp/*.info* /tmp/*.tmp*
}

cam_handle() {
    if test -z "${PID}"; then
        cam_up
    else
        cam_down
    fi
}

cam_down() {
    killall -9 oscam
    killall -9 oscammips
    sleep 2
    cam_clean
}

cam_up() {
    /usr/bin/cam/oscam -c /etc/tuxbox/config &
    /usr/local/etc/oscammips -c /usr/local/etc &
}

if test "$Action" = "cam_res"; then
    cam_down
    cam_up
elif test "$Action" = "cam_down"; then
    cam_down
elif test "$Action" = "cam_up"; then
    cam_up
else
    cam_handle
fi

exit 0
