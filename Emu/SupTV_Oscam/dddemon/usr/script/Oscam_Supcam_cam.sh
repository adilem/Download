#!/bin/sh
#### "*******************************************"
#### "              Created By RAED              *"
#### "*        << Edited by  MOHAMED_OS >>       *"
#### "*        ..:: www.tunisia-sat.com ::..     *"
#### "*******************************************"

CAMD_ID=11.61
CAMD_NAME="Oscam_Supcam"
CAMD_BIN=oscam
SUP_BIN=oscammips

INFOFILE_A=ecm0.info
INFOFILE_B=ecm1.info
INFOFILE_C=ecm2.info
INFOFILE_D=ecm3.info
#Expert window
INFOFILE_LINES=11.611.6111.6000
#Zapp after start
REZAPP=0

########################################

logger "$0" "$1"
echo "$0" "$1"

remove_tmp() {
    rm -rf /tmp/*.info* /tmp/*.tmp* /tmp/$CAMD_BIN*
}

case "$1" in
start)
    remove_tmp
    /usr/bin/$CAMD_BIN -d -c /etc/tuxbox/config/$CAMD_BIN.conf &
    /usr/local/etc/$SUP_BIN -d -c /usr/local/etc &
    ;;
stop)
    killall -9 $CAMD_BIN 2>/dev/null
    killall -9 $SUP_BIN 2>/dev/null
    sleep 2
    remove_tmp
    ;;
*)
    $0 stop
    exit 0
    ;;
esac

exit 0
