#!/bin/sh
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL ANSITE
# ###########################################
#
# Command: wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/YouTube/installer.sh -qO - | /bin/sh
#
# ###########################################

###########################################
# Configure where we can find things here #
TMPDIR='/tmp'
VERSION='git824'
GIT='9e892cb'
PACKAGE='enigma2-plugin-extensions-youtube'
MY_URL='https://raw.githubusercontent.com/MOHAMED19OS/Download/main/YouTube'

####################
#  Image Checking  #

if [ -f /etc/opkg/opkg.conf ] ; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
    OPKGREMOV='opkg remove --force-depends'
elif [ -f /etc/apt/apt.conf ] ; then
    STATUS='/var/lib/dpkg/status'
    OSTYPE='DreamOS'
    OPKG='apt-get update'
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

echo "Opkg Update ..."
$OPKG > /dev/null 2>&1

###################
#  Install Plugin #
if python --version 2>&1 | grep -q '^Python 3\.'; then
    echo "Insallling YouTube plugin Please Wait ......"
    wget $MY_URL/${PACKAGE}_h1+${VERSION}+${GIT}-r0_all.ipk -qP $TMPDIR
    $OPKGINSTAL $TMPDIR/${PACKAGE}_h1+${VERSION}+${GIT}-r0.0_all.ipk
else
    if [ $OSTYPE = "Opensource" ]; then
        echo "Insallling YouTube plugin Please Wait ......"
        wget $MY_URL/${PACKAGE}_h1+${VERSION}+${GIT}-r0.0_all.ipk -qP $TMPDIR
        $OPKGINSTAL $TMPDIR/${PACKAGE}_h1+${VERSION}+${GIT}-r0.0_all.ipk
    else
        echo "Insallling YouTube plugin Please Wait ......"
        wget $MY_URL/${PACKAGE}_1+${VERSION}+${GIT}-r0_all.deb -qP $TMPDIR
        $DPKINSTALL $TMPDIR/${PACKAGE}_1+${VERSION}+${GIT}-r0_all.deb; $OPKGINSTAL -f -y
    fi
fi

#########################
# Remove files (if any) #
rm -rf $TMPDIR/"${PACKAGE:?}"*

if [ -f /etc/enigma2/YouTube.key-opkg ]; then
    rm -rf /etc/enigma2/YouTube.key-opkg
else
    echo

fi

echo ""
echo "***********************************************************************"
echo "**                                                                    *"
echo "**                       Ansite     : $VERSION                          *"
echo "**                       Uploaded by: MOHAMED_OS                      *"
echo "**                       Develop by : Taapat                          *"
echo "**  Support    : https://www.tunisia-sat.com/forums/threads/3776759/  *"
echo "**                                                                    *"
echo "***********************************************************************"
echo ""

if [ $OSTYPE = "Opensource" ]; then
    killall -9 enigma2
else
    systemctl restart enigma2
fi

exit 0

exit 0
