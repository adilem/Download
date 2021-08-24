#!/bin/sh
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL ANSITE
# ###########################################
#
# Command: wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Ansite/installer.sh -qO - | /bin/sh
#
# ###########################################

###########################################
# Configure where we can find things here #
TMPDIR='/tmp'
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

if python --version 2>&1 | grep -q '^Python 3\.'; then
   echo "You have Python3 image"
   sleep 2; clear
   VERSION='1.4'
else
  echo "You have Python2 image"
  sleep 2; clear
  VERSION='1.3'
fi

######################
#  Remove Old Plugin #
if grep -qs "Package: $Package" $STATUS ; then
    echo
    echo "Remove old version..."
    $OPKGREMOV $Package
    sleep 1; clear
else
    echo "No older version was found on the device... "
    sleep 2; clear
fi

###################
#  Install Plugin #
if python --version 2>&1 | grep -q '^Python 3\.'; then
    echo "Opkg Update ..."
    $OPKG > /dev/null 2>&1
    echo "Downloading And Insallling Ansite plugin Please Wait ......"
    wget "$URL"/enigma2-plugin-extensions-ansite_"$VERSION"_all.ipk?raw=true -qO $TMPDIR/enigma2-plugin-extensions-ansite_"$VERSION"_all.ipk
    $OPKGINSTAL $TMPDIR/enigma2-plugin-extensions-ansite_"$VERSION"_all.ipk
else
    echo "Opkg Update ..."
    $OPKG > /dev/null 2>&1
    echo "Downloading And Insallling Ansite plugin Please Wait ......"
    wget "$URL"/enigma2-plugin-extensions-ansite_"$VERSION"_all.ipk?raw=true -qO $TMPDIR/enigma2-plugin-extensions-ansite_"$VERSION"_all.ipk
    $OPKGINSTAL $TMPDIR/enigma2-plugin-extensions-ansite_"$VERSION"_all.ipk
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
echo "**                       Ansite     : $VERSION                             *"
echo "**                       Uploaded by: MOHAMED_OS                      *"
echo "**                       Develop by : aime_jeux                       *"
echo "**  Support    : https://www.tunisia-sat.com/forums/threads/4209147/  *"
echo "**                                                                    *"
echo "***********************************************************************"
echo ""

exit 0
