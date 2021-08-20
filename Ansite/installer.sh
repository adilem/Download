#!/bin/sh
#####################################
# wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Ansite/installer.sh -qO - | /bin/sh

###########################################
# Configure where we can find things here #
TMPDIR='/tmp'
VERPY2='ansite_1.3'
VERPY3='ansite_1.4'
Package='enigma2-plugin-extensions-ansite*'
URL='https://github.com/MOHAMED19OS/Download/blob/main/Ansite'

####################
#  Image Checking  #
if [ -f /etc/opkg/opkg.conf ] ; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
fi

if [ $OSTYPE = "Opensource" ]; then
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
    OPKGREMOV='opkg remove --force-depends'
fi

######################
#  Remove Old Plugin #
if grep -qs "Package: $Package" $STATUS ; then
    echo ""
    echo "Remove old version..."
    $OPKGREMOV $Package
    echo ""
    sleep 1; clear
else
    echo ""
    echo "No older version was found on the device... "
    sleep 2
    echo ""
fi

###################
#  Install Plugin #
if python --version 2>&1 | grep -q '^Python 3\.'; then
    echo ""
    echo "You have Python3 image"
    sleep 3; clear
    echo "Opkg Update ..."
    $OPKG > /dev/null 2>&1
    echo ""
    wget --show-progress "$URL"/enigma2-plugin-extensions-"$VERPY3"_all.ipk?raw=true -qO $TMPDIR/enigma2-plugin-extensions-"$VERPY3"_all.ipk;
    $OPKGINSTAL $TMPDIR/enigma2-plugin-extensions-"$VERPY3"_all.ipk
else
    echo ""
    echo "You have Python2 image"
    sleep 3; clear
    echo "Opkg Update ..."
    $OPKG > /dev/null 2>&1
    echo ""
    wget --show-progress "$URL"/enigma2-plugin-extensions-"$VERPY2"_all.ipk?raw=true -qO $TMPDIR/enigma2-plugin-extensions-"$VERPY2"_all.ipk;
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
