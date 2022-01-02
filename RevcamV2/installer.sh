#!/bin/sh
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL RevcamV2
# ###########################################
#
# Command: wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/RevcamV2/installer.sh -qO - | /bin/sh
#
# ###########################################

###########################################
# Configure where we can find things here #
TMPDIR='/tmp'
VERSION='2'
PACKAGE='enigma2-plugin-softcams-revcam'
MY_URL='https://raw.githubusercontent.com/MOHAMED19OS/Download/main/RevcamV2/'

####################
#  Image Checking  #
if [ -f /etc/opkg/opkg.conf ] ; then
    OSTYPE='Opensource'
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
    OPKGLIST='opkg list-installed'
    OPKGREMOV='opkg remove --force-depends'
elif [ -f /etc/apt/apt.conf ] ; then
    OSTYPE='DreamOS'
    OPKG='apt-get update'
    OPKGINSTAL='apt-get install'
    OPKGLIST='apt-get list-installed'
    OPKGREMOV='apt-get purge --auto-remove'
    DPKINSTALL='dpkg -i --force-overwrite'
fi

##################################
# Remove previous files (if any) #
rm -rf $TMPDIR/"${PACKAGE:?}"* > /dev/null 2>&1

if [ "$($OPKGLIST $PACKAGE |  awk '{ print $3 }')" = $VERSION ]; then
    echo " You are use the laste Version: $VERSION"
    exit 1
elif [ -z "$($OPKGLIST $PACKAGE | awk '{ print $3 }')" ]; then
    echo; clear
else
    $OPKGREMOV $PACKAGE
fi

#########
$OPKG > /dev/null 2>&1

###################
#  Install Plugin #

echo "Insallling RevcamV2 plugin Please Wait ......"
if [ $OSTYPE = "Opensource" ]; then
    wget $MY_URL/${PACKAGE}_${VERSION}_all.ipk -qP $TMPDIR
    $OPKGINSTAL $TMPDIR/${PACKAGE}_${VERSION}_all.ipk
else
    wget $MY_URL/${PACKAGE}_${VERSION}.deb -qP $TMPDIR
    $DPKINSTALL $TMPDIR/${PACKAGE}_${VERSION}_all.deb; $OPKGINSTAL -f -y
fi

##################################
# Remove previous files (if any) #
rm -rf $TMPDIR/"${PACKAGE:?}"*

sleep 1; clear
echo ""
echo "***********************************************************************"
echo "**                                                                    *"
echo "**                       RevcamV2   : $VERSION                                *"
echo "**                       Uploaded by: MOHAMED_OS                      *"
echo "**                       Develop by : OTEX                            *"
echo "** Support    : https://www.facebook.com/groups/298510744799488/about *"
echo "**                                                                    *"
echo "***********************************************************************"
echo ""

if [ $OSTYPE = "Opensource" ]; then
    killall -9 enigma2
else
    systemctl restart enigma2
fi

exit 0
