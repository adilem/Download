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
VERSION='v3.0'
CURL='libcurl4'
TMPDIR='/tmp'
PACKAGE='enigma2-plugin-extensions-xtraevent'
CHECK=$(opkg list-installed "${PACKAGE}" | awk -F"- " '{print $2}')
MY_URL='https://raw.githubusercontent.com/MOHAMED19OS/Download/main/XtraEvante'

####################
#  Image Checking  #

if [ -f /etc/opkg/opkg.conf ] ; then
    STATUS='/var/lib/opkg/status'
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
fi

if python --version 2>&1 | grep -q '^Python 3\.'; then
    IMAGING='python3-imaging'
    REQUESTS='python3-requests'
    SQLITE='python3-sqlite3'
    BS4='python3-beautifulsoup4'
else
    IMAGING='python-imaging'
    REQUESTS='python-requests'
    SQLITE='python-sqlite3'
    BS4='python-beautifulsoup4'
fi

##################################
# Remove previous files (if any) #
rm -rf $TMPDIR/"${PACKAGE:?}"* > /dev/null 2>&1

##################
#  Check package #
if grep -qs "Package: $CURL" $STATUS ; then
    echo
    sleep 1; clear
else
    echo "Opkg Update ..."
    $OPKG > /dev/null 2>&1
    $OPKGINSTAL $CURL
fi

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
    if grep -qs "Package: $SQLITE" $STATUS ; then
        echo
        sleep 1; clear
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL $SQLITE
    fi
    if grep -qs "Package: $BS4" $STATUS ; then
        echo
        sleep 1; clear
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL $BS4
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
    if grep -qs "Package: $SQLITE" $STATUS ; then
        echo
        sleep 1; clear
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL $SQLITE
    fi
    if grep -qs "Package: $BS4" $STATUS ; then
        echo
        sleep 1; clear
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL $BS4
    fi
fi

sleep 1; clear
###################
#  Install Plugin #
if [ "$CHECK" = "$VERSION" ]; then
    echo "You are use the laste Version: ${VERSION}"
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
echo "**                       XtraEvante    : $VERSION                         *"
echo "**                       Uploaded by: MOHAMED_OS                      *"
echo "**                       Develop by : digiten                         *"
echo "**  Support    : https://www.tunisia-sat.com/forums/threads/4247338/  *"
echo "**                                                                    *"
echo "***********************************************************************"

exit 0
