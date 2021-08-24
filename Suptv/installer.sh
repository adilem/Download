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

if python --version 2>&1 | grep -q '^Python 3\.'; then
   echo "You have Python3 image"
   sleep 2; clear
   VERSION='3.1'
else
  echo "You have Python2 image"
  sleep 2; clear
  VERSION='2.0.1'
fi

###################
#  Install Plugin #

if grep -qs "Package: $Package" $STATUS ; then
    echo ""
    echo "SupTV found in device..."
    sleep 1; clear
    echo "Goodbye!"
elif python --version 2>&1 | grep -q '^Python 3\.'; then
    echo "Opkg Update ..."
    $OPKG > /dev/null 2>&1
    echo "Downloading And Insallling Suptv plugin Please Wait ......"
    wget "$URL"/enigma2-plugin-extensions-suptv_"$VERSION"_all.ipk?raw=true -qO $TMPDIR/enigma2-plugin-extensions-suptv_"$VERSION"_all.ipk
    $OPKGINSTAL $TMPDIR/enigma2-plugin-extensions-suptv_"$VERSION"_all.ipk
else
    echo "Opkg Update ..."
    $OPKG > /dev/null 2>&1
    echo "Downloading And Insallling Suptv plugin Please Wait ......"
    wget "$URL"/enigma2-plugin-extensions-suptv_"$VERSION"_all.ipk?raw=true -qO $TMPDIR/enigma2-plugin-extensions-suptv_"$VERSION"_all.ipk
    $OPKGINSTAL $TMPDIR/enigma2-plugin-extensions-suptv_"$VERSION"_all.ipk
fi

######################
# Delete File In TMP #

if [ -f $TMPDIR/$Package ] ; then
    rm -rf $TMPDIR/$Package
else
    echo
fi

sleep 2; clear
echo ""
echo "***********************************************************************"
echo "**                                                                    *"
echo "**                       Suptv      : $VERSION                           *"
echo "**                       Uploaded by: MOHAMED_OS                      *"
echo "**                       Develop by : Suptv                           *"
echo "**  Support    : https://script-enigma2.club/suptv/                   *"
echo "**                                                                    *"
echo "***********************************************************************"
echo ""

exit 0
