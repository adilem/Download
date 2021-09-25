#!/bin/sh
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL XcPlugin Forever
# ###########################################
#
# Command: wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/XC-Code/installer.sh -qO - | /bin/sh
#
# ###########################################

###########################################
# Configure where we can find things here #
TMPDIR='/tmp'
VERSION='1.8'
PACKAGE='enigma2-plugin-extensions-xcplugin-forever'
MY_URL='https://raw.githubusercontent.com/MOHAMED19OS/Download/main/XC-Code'

####################
#  Image Checking  #

if [ -f /etc/opkg/opkg.conf ] ; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
    OPKGINSTAL='opkg install'
    OPKGREMOV='opkg remove --force-depends'
elif [ -f /etc/apt/apt.conf ] ; then
    STATUS='/var/lib/dpkg/status'
    OSTYPE='DreamOS'
    OPKGINSTAL='apt-get install'
    OPKGREMOV='apt-get purge --auto-remove'
    DPKINSTALL='dpkg -i --force-overwrite'
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

###################
#  Install Plugin #
if [ $OSTYPE = "Opensource" ]; then
    echo "Insallling XcPlugin Forever plugin Please Wait ......"
    wget $MY_URL/${PACKAGE}_${VERSION}_all.ipk -qP $TMPDIR
    $OPKGINSTAL $TMPDIR/${PACKAGE}_${VERSION}_all.ipk
else
    echo "Insallling XcPlugin Forever plugin Please Wait ......"
    wget $MY_URL/${PACKAGE}_${VERSION}_all.deb -qP $TMPDIR
    $DPKINSTALL $TMPDIR/${PACKAGE}_${VERSION}_all.deb; $OPKGINSTAL -f -y
fi

#########################
# Remove files (if any) #
rm -rf $TMPDIR/"${PACKAGE:?}"*

sleep 1; clear
echo ""
echo "****************************************************************************************"
echo "**                                                                                     *"
echo "**                            XcPlugin   : $VERSION                                         *"
echo "**                            Uploaded by: MOHAMED_OS                                  *"
echo "**                            Develop by : Lululla                                     *"
echo "**  Support: https://www.linuxsat-support.com/thread/143881-xcplugin-forever-version/  *"
echo "**                                                                                     *"
echo "****************************************************************************************"
echo ""

if [ $OSTYPE = "Opensource" ]; then
    killall -9 enigma2
else
    systemctl restart enigma2
fi

exit 0
