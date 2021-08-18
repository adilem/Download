#!/bin/sh
#####################################
# wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Suptv/installer.sh -qO - | /bin/sh

###########################################
# Configure where we can find things here #
TMPDIR='/tmp'
VERPY2='suptv_2.0.1'
VERPY3='suptv_3.1'
Package='enigma2-plugin-extensions-suptv*'
URL='https://github.com/MOHAMED19OS/Download/blob/main/Suptv'

####################
#  Image Checking  #
if [ -f /etc/opkg/opkg.conf ] ; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
fi

if [ $OSTYPE = "Opensource" ]; then
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
fi

###################
#  Install Plugin #

if grep -qs "Package: $Package" $STATUS ; then
    echo ""
    echo "SupTV found in device..."
    sleep 2; clear
    echo "Goodbye!"
    exit 0
elif python --version 2>&1 | grep -q '^Python 3\.'; then
    echo ""
    echo "You have Python3 image"
    sleep 3; clear
    echo "Opkg Update ..."
    $OPKG > /dev/null 2>&1
    echo ""
    wget "$URL"/enigma2-plugin-extensions-"$VERPY3"_all.ipk?raw=true -qO $TMPDIR/enigma2-plugin-extensions-"$VERPY3"_all.ipk;
    $OPKGINSTAL $TMPDIR/enigma2-plugin-extensions-"$VERPY3"_all.ipk
else
    echo ""
    echo "You have Python2 image"
    sleep 3; clear
    echo "Opkg Update ..."
    $OPKG > /dev/null 2>&1
    echo ""
    wget "$URL"/enigma2-plugin-extensions-"$VERPY2"_all.ipk?raw=true -qO $TMPDIR/enigma2-plugin-extensions-"$VERPY2"_all.ipk;
    $OPKGINSTAL $TMPDIR/enigma2-plugin-extensions-"$VERPY2"_all.ipk
fi

######################
# Delete File In TMP #

if [ -f $TMPDIR/$Package ] ; then
    rm -rf $TMPDIR/$Package
else
    echo ""
fi

exit 0
