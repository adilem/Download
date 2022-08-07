#!/bin/sh
#### "*******************************************"
#### "              Created By RAED              *"
#### "*        << Edited by  MOHAMED_OS >>       *"
#### "*        ..:: www.tunisia-sat.com ::..     *"
#### "*******************************************"
Action=$1
OSD="Oscam_Supcam"

cam_clean() {
    rm -rf /tmp/ecm.info /tmp/script.info /tmp/pid.info /tmp/cardinfo /tmp/cam.info /tmp/debug.txt /tmp/ecm0.info /tmp/mbox.ver /tmp/newcs.pid /tmp/share.info /tmp/share.onl /tmp/stat.info
}

cam_up() {
    cam_clean
    sleep 2
    /usr/bin/oscam -c /etc/tuxbox/config &
    /usr/local/etc/oscammips -c /usr/local/etc &
}

cam_down() {
    sleep 4
    killall -9 oscam 2>/dev/null
    killall -9 oscammips 2>/dev/null
    sleep 2
    cam_clean
}

if test "$Action" = "cam_up"; then
    cam_up
elif test "$Action" = "cam_down"; then
    cam_down
elif test "$Action" = "cam_res"; then
    cam_down
    cam_up
fi
exit 0
