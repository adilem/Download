#!/bin/sh
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL XtraEvante
# ###########################################
#
# Command: wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/XtraEvante/installer.sh -qO - | /bin/sh
#
# ###########################################

###########################################
# Configure where we can find things here #
TMPDIR='/tmp'
PACKAGE='enigma2-plugin-extensions-xtraevent'
MY_URL='https://raw.githubusercontent.com/MOHAMED19OS/Download/main/XtraEvante'

####################
#  Image Checking  #

if [ -f /etc/opkg/opkg.conf ] ; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
    OPKGREMOV='opkg remove --force-depends'
fi

if python --version 2>&1 | grep -q '^Python 3\.'; then
    echo ":You have Python3 image ..."
    sleep 1; clear
    IMAGING=python3-imaging
    REQUESTS=python3-requests
    VERSION='v3.0'
else
    echo ":You have Python2 image ..."
    sleep 1; clear
    IMAGING=python-imaging
    REQUESTS=python-requests
    VERSION='v2.0'
fi

##################################
# Remove previous files (if any) #
rm -rf $TMPDIR/"${PACKAGE:?}"* > /dev/null 2>&1

######################
#  Remove Old Plugin #
if grep -qs "Package: $PACKAGE" $STATUS ; then
    echo "   >>>>   Remove old version   <<<<"
    $OPKGREMOV $PACKAGE
    sleep 1; clear
else
    echo "   >>>>   No Older Version Was Found   <<<<"
    sleep 1; clear
fi

##################
#  Check package #
if python --version 2>&1 | grep -q '^Python 3\.'; then
    if grep -qs "Package: $IMAGING" $STATUS ; then
        echo
        sleep 1; clear
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL $IMAGING
    fi
        if grep -qs "Package: $REQUESTS" $STATUS ; then
        echo
        sleep 1; clear
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL $REQUESTS
    fi
else
    if grep -qs "Package: $IMAGING" $STATUS ; then
        echo
        sleep 1; clear
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL $IMAGING
    fi
        if grep -qs "Package: $REQUESTS" $STATUS ; then
        echo
        sleep 1; clear
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL $REQUESTS
    fi
fi

###################
#  Install Plugin #
if python --version 2>&1 | grep -q '^Python 3\.'; then
    echo "Insallling xtraEvent plugin Please Wait ......"
    wget $MY_URL/${PACKAGE}_${VERSION}_all.ipk -qP $TMPDIR
    $OPKGINSTAL $TMPDIR/${PACKAGE}_${VERSION}_all.ipk
else
    echo "Insallling xtraEvent plugin Please Wait ......"
    wget $MY_URL/${PACKAGE}_${VERSION}_all.ipk -qP $TMPDIR
    $OPKGINSTAL $TMPDIR/${PACKAGE}_${VERSION}_all.ipk
fi

#########################
# Remove files (if any) #
rm -rf $TMPDIR/"${PACKAGE:?}"* > /dev/null 2>&1

echo ""
echo "***********************************************************************"
echo "**                                                                    *"
echo "**                       XtraEvante    : $VERSION                       *"
echo "**                       Uploaded by: MOHAMED_OS                      *"
echo "**                       Develop by : digiten                         *"
echo "**  Support    : https://www.tunisia-sat.com/forums/threads/4247338/  *"
echo "**                                                                    *"
echo "***********************************************************************"

sleep 2
killall -9 enigma2

exit 0
