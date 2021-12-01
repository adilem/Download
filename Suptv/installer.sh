#!/bin/sh
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL Suptv
# ###########################################
#
# Command: wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Suptv/installer.sh -qO - | /bin/sh
#
# ###########################################

###########################################
# Configure where we can find things here #
TMPDIR='/tmp'
PACKAGE='enigma2-plugin-extensions-suptv'
MY_URL='https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Suptv'

####################
#  Image Checking  #
if [ -f /etc/opkg/opkg.conf ] ; then
    OSTYPE='Opensource'
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
    OPKGLIST='opkg list-installed'
fi

if python --version 2>&1 | grep -q '^Python 3\.'; then
    echo ":You have Python3 image ..."
    sleep 1; clear
    VERSION='3.1'
else
    echo ":You have Python2 image ..."
    sleep 1; clear
    VERSION='2.0.1'
fi

##################################
# Remove previous files (if any) #
rm -rf $TMPDIR/"${PACKAGE:?}"* > /dev/null 2>&1

######
$OPKG > /dev/null 2>&1
###################
#  Install Plugin #

if [ "$($OPKGLIST $PACKAGE |  awk '{ print $3 }')" = $VERSION ]; then
    echo " You are use the laste Version: $VERSION"
elif "$($OPKGLIST $PACKAGE |  awk '{ print $3 }')":; then
    if python --version 2>&1 | grep -q '^Python 3\.'; then
        echo "Insallling Suptv plugin Please Wait ......"
        wget $MY_URL/${PACKAGE}_${VERSION}_all.ipk -qP $TMPDIR
        $OPKGINSTAL $TMPDIR/${PACKAGE}_${VERSION}_all.ipk
    else
        echo "Insallling Suptv plugin Please Wait ......"
        wget $MY_URL/${PACKAGE}_${VERSION}_all.ipk -qP $TMPDIR
        $OPKGINSTAL $TMPDIR/${PACKAGE}_${VERSION}_all.ipk
    fi
fi

##################################
# Remove previous files (if any) #
rm -rf $TMPDIR/"${PACKAGE:?}"* > /dev/null 2>&1

sleep 2; clear
echo ""
echo "***********************************************************************"
echo "**                                                                    *"
echo "**                       Suptv      : $VERSION                             *"
echo "**                       Uploaded by: MOHAMED_OS                      *"
echo "**                       Develop by : Suptv                           *"
echo "**  Support    : https://script-enigma2.club/suptv/                   *"
echo "**                                                                    *"
echo "***********************************************************************"
echo ""

exit 0
