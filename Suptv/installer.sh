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
if which opkg > /dev/null 2>&1; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
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
rm -rf $TMPDIR/"${PACKAGE:?}/"* > /dev/null 2>&1

###################
#  Install Plugin #

if grep -qs "Package: $PACKAGE" $STATUS ; then
    echo "   >>>>   SupTV found in device   <<<<"
    sleep 1; clear
    echo "Goodbye!"
elif python --version 2>&1 | grep -q '^Python 3\.'; then
    echo "Opkg Update ..."
    $OPKG > /dev/null 2>&1
    echo "Insallling Suptv plugin Please Wait ......"
    wget $MY_URL/${PACKAGE}_${VERSION}_all.ipk -qP $TMPDIR
    $OPKGINSTAL $TMPDIR/${PACKAGE}_${VERSION}_all.ipk
else
    echo "Opkg Update ..."
    $OPKG > /dev/null 2>&1
    echo "Insallling Suptv plugin Please Wait ......"
    wget $MY_URL/${PACKAGE}_${VERSION}_all.ipk -qP $TMPDIR
    $OPKGINSTAL $TMPDIR/${PACKAGE}_${VERSION}_all.ipk
fi

##################################
# Remove previous files (if any) #
rm -rf $TMPDIR/"${PACKAGE:?}/"* > /dev/null 2>&1

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
